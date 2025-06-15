import 'package:hive/hive.dart';
part 'balance_container.g.dart';

@HiveType(typeId: 1)
class BalanceContainer extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double balance;

  BalanceContainer({required this.name, required this.balance});
}
