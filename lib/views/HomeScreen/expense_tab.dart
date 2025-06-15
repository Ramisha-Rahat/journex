import 'package:flutter/material.dart';
import 'package:journex/utils/theme/jornex_colors.dart';
import 'package:journex/views/HomeScreen/transaction_Screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../model/balance_container.dart';
import '../../viewmodels/expense_viewModel.dart';

class ExpenseTab extends StatefulWidget {
  @override
  _ExpenseTabState createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseTrackerViewModel>(context, listen: false)
          .initializeDefaultContainers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseTrackerViewModel>(
      builder: (context, tracker, _) {
        final containers = tracker.allContainers;
        final allTransactions = tracker.allTransactions;

        BalanceContainer? easyPaisa;
        try {
          easyPaisa = containers.firstWhere((c) => c.name == 'EasyPaisa');
        } catch (e) {
          easyPaisa = null;
        }
        final cash = containers.firstWhere(
              (c) => c.name == 'Cash',
          orElse: () => throw Exception("Cash container not found"),
        );
        final bank = containers.firstWhere(
              (c) => c.name == 'Bank',
          orElse: () => throw Exception("Bank container not found"),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container Section
              Text(
                "My Wallets",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildContainerCard(bank, Colors.green, Icons.account_balance_wallet),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildContainerCard(cash, Colors.orange, Icons.money),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Bottom Row - Bank (centered)
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: _buildContainerCard(easyPaisa, Colors.blue, Icons.account_balance),
                ),
              ),

              SizedBox(height: 24),

              // Transaction History Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Transaction History",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => _showAllTransactions(context, allTransactions),
                    child: Text("View All"),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Recent Transactions
              if (allTransactions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long, size: 48, color: Colors.grey.shade400),
                      SizedBox(height: 8),
                      Text(
                        "No transactions yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      Text(
                        "Start by adding money to your wallets",
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              else
                ...allTransactions.reversed.take(5).map((transaction) {
                  return _buildTransactionCard(transaction);
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContainerCard(container, Color color, IconData icon) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 24),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        container.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  "Rs. ${container.balance.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: container.balance < 0 ? Colors.red : AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _showEditBalanceDialog(container),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.edit, size: 16, color: color),
                  ),
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddTransactionScreen(containerName: container.name),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(transaction) {
    final color = _getTransactionColor(transaction.type);
    final icon = _getTransactionIcon(transaction.type);

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.notes ?? transaction.type,
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.black),
                ),
                Text(
                  "${transaction.containerName} • ${DateFormat('MMM dd, hh:mm a').format(transaction.date)}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "${transaction.type == 'Add' ? '+' : '-'} Rs. ${transaction.amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction.type == 'Add' ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'Add':
        return Colors.green;
      case 'Withdraw':
        return Colors.red;
      case 'Lent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'Add':
        return Icons.add_circle;
      case 'Withdraw':
        return Icons.remove_circle;
      case 'Lent':
        return Icons.person_add;
      default:
        return Icons.circle;
    }
  }

  void _showEditBalanceDialog(container) {
    final controller = TextEditingController(text: container.balance.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit ${container.name} Balance"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "New Balance",
            prefixText: "Rs. ",
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newBalance = double.tryParse(controller.text) ?? 0;
              Provider.of<ExpenseTrackerViewModel>(context, listen: false)
                  .updateContainerBalance(container.name, newBalance);
              Navigator.pop(context);
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showAllTransactions(BuildContext context, List transactions) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text("All Transactions")),
          body: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return _buildTransactionCard(transactions.reversed.toList()[index]);
            },
          ),
        ),
      ),
    );
  }
}
