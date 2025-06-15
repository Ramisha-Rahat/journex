import 'package:hive/hive.dart';

part 'transaction_model.g.dart'; // ✅ Make sure this matches your Dart filename

@HiveType(typeId: 2)
class TransactionEntry extends HiveObject {
  @HiveField(0)
  String containerName;

  @HiveField(1)
  String type; // income, expense, borrowed, lent

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? notes;

  TransactionEntry({
    required this.containerName,
    required this.type,
    required this.amount,
    required this.date,
    this.notes,
  });
}
