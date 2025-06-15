import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/filter_model.dart';
import '../model/journal_entries.dart';

class JournalViewModel extends ChangeNotifier {
  late Box<JournalEntry> _journalBox;
  List<JournalEntry> _entries = [];
  List<JournalEntry> _filteredEntries = [];
  bool _isLoading = false;
  FilterModel _currentFilter = FilterModel();

  List<JournalEntry> get entries => _filteredEntries.isNotEmpty || _currentFilter.hasJournalFilters
      ? _filteredEntries
      : _entries;
  bool get isLoading => _isLoading;
  FilterModel get currentFilter => _currentFilter;
  bool get hasActiveFilters => _currentFilter.hasJournalFilters;

  Future<void> init() async {
    try {
      _isLoading = true;
      notifyListeners();

      _journalBox = await Hive.openBox<JournalEntry>('journalBox');
      loadEntries();
    } catch (e) {
      debugPrint('Error initializing journal box: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadEntries() {
    try {
      _entries = _journalBox.values.toList();
      _entries.sort((a, b) => b.date.compareTo(a.date)); // Latest first
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading entries: $e');
    }
  }

  void applyFilter(FilterModel filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _currentFilter = FilterModel();
    _filteredEntries = [];
    notifyListeners();
  }

  void _applyFilters() {
    if (!_currentFilter.hasJournalFilters) {
      _filteredEntries = [];
      return;
    }

    _filteredEntries = _entries.where((entry) {
      // Search filter
      if (_currentFilter.searchQuery?.isNotEmpty == true) {
        final query = _currentFilter.searchQuery!.toLowerCase();
        final matchesTitle = entry.title.toLowerCase().contains(query);
        final matchesDescription = entry.description?.toLowerCase().contains(query) ?? false;
        if (!matchesTitle && !matchesDescription) return false;
      }

      // Date range filter
      if (_currentFilter.startDate != null) {
        if (entry.date.isBefore(_currentFilter.startDate!)) return false;
      }
      if (_currentFilter.endDate != null) {
        final endOfDay = DateTime(_currentFilter.endDate!.year, _currentFilter.endDate!.month, _currentFilter.endDate!.day, 23, 59, 59);
        if (entry.date.isAfter(endOfDay)) return false;
      }

      // Icon filter
      if (_currentFilter.selectedIcon != null) {
        if (entry.iconName != _currentFilter.selectedIcon) return false;
      }

      return true;
    }).toList();

    _filteredEntries.sort((a, b) => b.date.compareTo(a.date));
  }

  // CREATE - Add new entry
  Future<bool> addEntry(JournalEntry entry) async {
    try {
      await _journalBox.add(entry);
      loadEntries(); // Refresh the list
      return true;
    } catch (e) {
      debugPrint('Error adding entry: $e');
      return false;
    }
  }

  // READ - Get entry by index
  JournalEntry? getEntry(int index) {
    final currentEntries = entries;
    if (index >= 0 && index < currentEntries.length) {
      return currentEntries[index];
    }
    return null;
  }

  // UPDATE - Update existing entry
  Future<bool> updateEntry(JournalEntry oldEntry, JournalEntry newEntry) async {
    try {
      final index = _entries.indexOf(oldEntry);
      if (index != -1) {
        // Update the entry in Hive
        await oldEntry.delete(); // Delete old entry
        await _journalBox.add(newEntry); // Add updated entry
        loadEntries(); // Refresh the list
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating entry: $e');
      return false;
    }
  }

  // DELETE - Delete entry
  Future<bool> deleteEntry(JournalEntry entry) async {
    try {
      await entry.delete(); // Delete from Hive
      loadEntries(); // Refresh the list
      return true;
    } catch (e) {
      debugPrint('Error deleting entry: $e');
      return false;
    }
  }

  // Search entries by title or description
  List<JournalEntry> searchEntries(String query) {
    if (query.isEmpty) return _entries;

    return _entries.where((entry) {
      return entry.title.toLowerCase().contains(query.toLowerCase()) ||
          (entry.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  // Get entries by date range
  List<JournalEntry> getEntriesByDateRange(DateTime start, DateTime end) {
    return _entries.where((entry) {
      return entry.date.isAfter(start.subtract(const Duration(days: 1))) &&
          entry.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Get entries count
  int get entriesCount => _entries.length;
  int get filteredEntriesCount => entries.length;
}
