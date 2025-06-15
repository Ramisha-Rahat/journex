class FilterModel {
  // Journal filters
  String? searchQuery;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedIcon;

  // Expense filters
  List<String> selectedContainers;
  List<String> selectedTransactionTypes;
  double? minAmount;
  double? maxAmount;

  FilterModel({
    this.searchQuery,
    this.startDate,
    this.endDate,
    this.selectedIcon,
    this.selectedContainers = const [],
    this.selectedTransactionTypes = const [],
    this.minAmount,
    this.maxAmount,
  });

  bool get hasJournalFilters =>
      searchQuery?.isNotEmpty == true ||
          startDate != null ||
          endDate != null ||
          selectedIcon != null;

  bool get hasExpenseFilters =>
      selectedContainers.isNotEmpty ||
          selectedTransactionTypes.isNotEmpty ||
          minAmount != null ||
          maxAmount != null ||
          startDate != null ||
          endDate != null;

  bool get hasAnyFilters => hasJournalFilters || hasExpenseFilters;

  void clearAll() {
    searchQuery = null;
    startDate = null;
    endDate = null;
    selectedIcon = null;
    selectedContainers = [];
    selectedTransactionTypes = [];
    minAmount = null;
    maxAmount = null;
  }
}
