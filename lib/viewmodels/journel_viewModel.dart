import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/journel_entries.dart';

class JournalViewModel extends ChangeNotifier {
  late Box<JournalEntry> _journalBox;

  List<JournalEntry> _entries = [];
  List<JournalEntry> get entries => _entries;

  Future<void> init() async {
    _journalBox = await Hive.openBox<JournalEntry>('journalBox');
    loadEntries();
  }

  void loadEntries() {
    _entries = _journalBox.values.toList();
    _entries.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    await _journalBox.add(entry);
    loadEntries();
  }

  Future<void> updateEntry(int index, JournalEntry updatedEntry) async {
    await _journalBox.putAt(index, updatedEntry);
    loadEntries();
  }

  Future<void> deleteEntry(int index) async {
    await _journalBox.deleteAt(index);
    loadEntries();
  }

  JournalEntry getEntry(int index) => _entries[index];
}
