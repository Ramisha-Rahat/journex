import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/filter_model.dart';

class FilterScreen extends StatefulWidget {
  final FilterModel currentFilter;
  final int activeTabIndex; // 0 for Journal, 1 for Expense

  const FilterScreen({
    Key? key,
    required this.currentFilter,
    required this.activeTabIndex,
  }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late FilterModel _filter;
  final _searchController = TextEditingController();
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();

  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'note', 'icon': Icons.note, 'label': 'Note'},
    {'name': 'work', 'icon': Icons.work, 'label': 'Work'},
    {'name': 'home', 'icon': Icons.home, 'label': 'Home'},
    {'name': 'favorite', 'icon': Icons.favorite, 'label': 'Favorite'},
    {'name': 'travel', 'icon': Icons.flight, 'label': 'Travel'},
    {'name': 'food', 'icon': Icons.emoji_food_beverage, 'label': 'Food'},
    {'name': 'shopping', 'icon': Icons.shopping_bag, 'label': 'Shopping'},
  ];

  final List<String> _containers = ['EasyPaisa', 'Cash', 'Bank'];
  final List<String> _transactionTypes = ['Add', 'Withdraw', 'Lent'];

  @override
  void initState() {
    super.initState();
    _filter = FilterModel(
      searchQuery: widget.currentFilter.searchQuery,
      startDate: widget.currentFilter.startDate,
      endDate: widget.currentFilter.endDate,
      selectedIcon: widget.currentFilter.selectedIcon,
      selectedContainers: List.from(widget.currentFilter.selectedContainers),
      selectedTransactionTypes: List.from(widget.currentFilter.selectedTransactionTypes),
      minAmount: widget.currentFilter.minAmount,
      maxAmount: widget.currentFilter.maxAmount,
    );

    _searchController.text = _filter.searchQuery ?? '';
    _minAmountController.text = _filter.minAmount?.toString() ?? '';
    _maxAmountController.text = _filter.maxAmount?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activeTabIndex == 0 ? 'Filter Journal' : 'Filter Expenses'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _filter.clearAll();
                _searchController.clear();
                _minAmountController.clear();
                _maxAmountController.clear();
              });
            },
            child: Text('Clear All'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Filter (Common for both)
            _buildSectionTitle('Date Range'),
            _buildDateRangeFilter(),
            SizedBox(height: 24),

            if (widget.activeTabIndex == 0) ...[
              // Journal specific filters
              _buildSectionTitle('Search'),
              _buildSearchFilter(),
              SizedBox(height: 24),

              _buildSectionTitle('Category'),
              _buildIconFilter(),
            ] else ...[
              // Expense specific filters
              _buildSectionTitle('Wallets'),
              _buildContainerFilter(),
              SizedBox(height: 24),

              _buildSectionTitle('Transaction Types'),
              _buildTransactionTypeFilter(),
              SizedBox(height: 24),

              _buildSectionTitle('Amount Range'),
              _buildAmountRangeFilter(),
            ],

            SizedBox(height: 32),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  _filter.searchQuery = _searchController.text.isEmpty ? null : _searchController.text;
                  _filter.minAmount = double.tryParse(_minAmountController.text);
                  _filter.maxAmount = double.tryParse(_maxAmountController.text);
                  Navigator.pop(context, _filter);
                },
                child: Text(
                  'Apply Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectStartDate(),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'From Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _filter.startDate != null
                        ? DateFormat('MMM dd, yyyy').format(_filter.startDate!)
                        : 'Select start date',
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectEndDate(),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'To Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _filter.endDate != null
                        ? DateFormat('MMM dd, yyyy').format(_filter.endDate!)
                        : 'Select end date',
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_filter.startDate != null || _filter.endDate != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _filter.startDate = null;
                  _filter.endDate = null;
                });
              },
              child: Text('Clear Date Range'),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchFilter() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search in title or description',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchController.clear();
            });
          },
        )
            : null,
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildIconFilter() {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableIcons.map((iconData) {
            final isSelected = _filter.selectedIcon == iconData['name'];
            return FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconData['icon'], size: 16),
                  SizedBox(width: 4),
                  Text(iconData['label']),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  _filter.selectedIcon = selected ? iconData['name'] : null;
                });
              },
            );
          }).toList(),
        ),
        if (_filter.selectedIcon != null)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _filter.selectedIcon = null;
                });
              },
              child: Text('Clear Category'),
            ),
          ),
      ],
    );
  }

  Widget _buildContainerFilter() {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _containers.map((container) {
            final isSelected = _filter.selectedContainers.contains(container);
            return FilterChip(
              selected: isSelected,
              label: Text(container),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _filter.selectedContainers.add(container);
                  } else {
                    _filter.selectedContainers.remove(container);
                  }
                });
              },
            );
          }).toList(),
        ),
        if (_filter.selectedContainers.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _filter.selectedContainers.clear();
                });
              },
              child: Text('Clear Wallets'),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionTypeFilter() {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _transactionTypes.map((type) {
            final isSelected = _filter.selectedTransactionTypes.contains(type);
            return FilterChip(
              selected: isSelected,
              label: Text(type),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _filter.selectedTransactionTypes.add(type);
                  } else {
                    _filter.selectedTransactionTypes.remove(type);
                  }
                });
              },
            );
          }).toList(),
        ),
        if (_filter.selectedTransactionTypes.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _filter.selectedTransactionTypes.clear();
                });
              },
              child: Text('Clear Types'),
            ),
          ),
      ],
    );
  }

  Widget _buildAmountRangeFilter() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minAmountController,
            decoration: InputDecoration(
              labelText: 'Min Amount',
              border: OutlineInputBorder(),
              prefixText: 'Rs. ',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _maxAmountController,
            decoration: InputDecoration(
              labelText: 'Max Amount',
              border: OutlineInputBorder(),
              prefixText: 'Rs. ',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filter.startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _filter.startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filter.endDate ?? DateTime.now(),
      firstDate: _filter.startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _filter.endDate = picked;
      });
    }
  }
}
