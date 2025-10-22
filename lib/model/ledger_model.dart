import 'package:hive/hive.dart';
part 'ledger_model.g.dart';

@HiveType(typeId: 1)
class LedgerModel extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  String type; // 'lend' or 'borrow'

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String name; // person/entity

  @HiveField(4)
  String description; // new field

  LedgerModel({
    required this.amount,
    required this.type,
    required this.date,
    required this.name,
    required this.description, // added in constructor
  });
}
