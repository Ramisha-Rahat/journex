import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/expense_viewModel.dart';

class AddTransactionScreen extends StatefulWidget {
  final String containerName;

  const AddTransactionScreen({Key? key, required this.containerName}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  String selectedType = 'Add';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final tracker = Provider.of<ExpenseTrackerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.containerName} Transaction"),
        backgroundColor: _getContainerColor(widget.containerName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaction Type",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: ['Add', 'Withdraw', 'Lent'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getTypeIcon(type), size: 20),
                        SizedBox(width: 8),
                        Text(type),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedType = val!),
                validator: (value) => value == null ? 'Please select a type' : null,
              ),
              SizedBox(height: 16),

              Text(
                "Amount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "Enter amount",
                  prefixText: "Rs. ",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount greater than 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              Text(
                "Notes (Optional)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: "Add a note...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getContainerColor(widget.containerName),
                  ),
                  onPressed: _isLoading ? null : _submitTransaction,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Add Transaction",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitTransaction() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final tracker = Provider.of<ExpenseTrackerViewModel>(context, listen: false);
      final amount = double.parse(amountController.text);
      final notes = notesController.text.isEmpty ? null : notesController.text;

      tracker.addTransaction(widget.containerName, selectedType, amount, notes);

      await Future.delayed(Duration(milliseconds: 400)); // simulate a short delay
      setState(() => _isLoading = false);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Transaction added successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Color _getContainerColor(String containerName) {
    switch (containerName) {
      case 'EasyPaisa':
        return Colors.green;
      case 'Cash':
        return Colors.orange;
      case 'Bank':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
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

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
