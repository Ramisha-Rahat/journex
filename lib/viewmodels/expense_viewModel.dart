import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../model/balance_container.dart';
import '../model/filter_model.dart';
import '../model/transaction_model.dart';

class ExpenseTrackerViewModel extends ChangeNotifier {
  final Box<BalanceContainer> containerBox = Hive.box<BalanceContainer>('balanceContainers');
  final Box<TransactionEntry> transactionBox = Hive.box<TransactionEntry>('transactions');

  List<TransactionEntry> _filteredTransactions = [];
  FilterModel _currentFilter = FilterModel();

  List<BalanceContainer> get allContainers => containerBox.values.toList();
  List<TransactionEntry> get allTransactions => transactionBox.values.toList();
  List<TransactionEntry> get filteredTransactions =>
      _filteredTransactions.isNotEmpty || _currentFilter.hasExpenseFilters
          ? _filteredTransactions
          : allTransactions;

  FilterModel get currentFilter => _currentFilter;
  bool get hasActiveFilters => _currentFilter.hasExpenseFilters;

  Future<void> initializeDefaultContainers() async {
    await Future.delayed(const Duration(milliseconds: 100)); // Allow Hive to finish loading

    final existingNames = allContainers.map((c) => c.name).toSet();

    if (!existingNames.contains('EasyPaisa')) {
      addContainer('EasyPaisa', 0.0);
    }
    if (!existingNames.contains('Cash')) {
      addContainer('Cash', 0.0);
    }
    if (!existingNames.contains('Bank')) {
      addContainer('Bank', 0.0);
    }
  }

  void applyFilter(FilterModel filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _currentFilter = FilterModel();
    _filteredTransactions = [];
    notifyListeners();
  }

  void _applyFilters() {
    if (!_currentFilter.hasExpenseFilters) {
      _filteredTransactions = [];
      return;
    }

    _filteredTransactions = allTransactions.where((transaction) {
      if (_currentFilter.selectedContainers.isNotEmpty &&
          !_currentFilter.selectedContainers.contains(transaction.containerName)) {
        return false;
      }

      if (_currentFilter.selectedTransactionTypes.isNotEmpty &&
          !_currentFilter.selectedTransactionTypes.contains(transaction.type)) {
        return false;
      }

      if (_currentFilter.minAmount != null && transaction.amount < _currentFilter.minAmount!) {
        return false;
      }
      if (_currentFilter.maxAmount != null && transaction.amount > _currentFilter.maxAmount!) {
        return false;
      }

      if (_currentFilter.startDate != null &&
          transaction.date.isBefore(_currentFilter.startDate!)) {
        return false;
      }

      if (_currentFilter.endDate != null) {
        final endOfDay = DateTime(
          _currentFilter.endDate!.year,
          _currentFilter.endDate!.month,
          _currentFilter.endDate!.day,
          23,
          59,
          59,
        );
        if (transaction.date.isAfter(endOfDay)) {
          return false;
        }
      }

      return true;
    }).toList();

    _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
  }

  void addContainer(String name, double initialBalance) {
    if (containerBox.values.any((c) => c.name == name)) return;

    final newContainer = BalanceContainer(name: name, balance: initialBalance);
    containerBox.add(newContainer);
    notifyListeners();
  }

  void updateContainerBalance(String containerName, double newBalance) {
    final containerList = containerBox.values.where((c) => c.name == containerName).toList();
    if (containerList.isEmpty) return;

    final container = containerList.first;
    container.balance = newBalance;
    container.save();
    notifyListeners();
  }

  void addTransaction(String containerName, String type, double amount, String? notes) {
    final containerList = containerBox.values.where((c) => c.name == containerName).toList();
    if (containerList.isEmpty) return;

    final container = containerList.first;

    switch (type.toLowerCase()) {
      case 'add':
        container.balance += amount;
        break;
      case 'withdraw':
      case 'lent':
        container.balance -= amount;
        break;
      default:
        throw Exception("Invalid transaction type: $type");
    }

    container.save();

    final entry = TransactionEntry(
      containerName: containerName,
      type: type,
      amount: amount,
      date: DateTime.now(),
      notes: notes,
    );
    transactionBox.add(entry);
    _applyFilters();
    notifyListeners();
  }

  List<TransactionEntry> getTransactionsForContainer(String containerName) {
    return allTransactions
        .where((tx) => tx.containerName == containerName)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionEntry> getTodayTransactions() {
    final today = DateTime.now();
    final transactions = hasActiveFilters ? filteredTransactions : allTransactions;

    return transactions
        .where((tx) =>
    tx.date.year == today.year &&
        tx.date.month == today.month &&
        tx.date.day == today.day)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void deleteTransaction(TransactionEntry transaction) {
    final containerList = containerBox.values.where((c) => c.name == transaction.containerName).toList();
    if (containerList.isEmpty) return;

    final container = containerList.first;

    switch (transaction.type.toLowerCase()) {
      case 'add':
        container.balance -= transaction.amount;
        break;
      case 'withdraw':
      case 'lent':
        container.balance += transaction.amount;
        break;
    }

    container.save();
    transaction.delete();
    _applyFilters();
    notifyListeners();
  }

  // For testing or reset functionality
  Future<void> resetContainersAndTransactions() async {
    await containerBox.clear();
    await transactionBox.clear();
    _filteredTransactions = [];
    _currentFilter = FilterModel();
    notifyListeners();
  }
}
