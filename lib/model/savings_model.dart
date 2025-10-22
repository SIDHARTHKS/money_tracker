import 'package:hive/hive.dart';

part 'savings_model.g.dart';

@HiveType(typeId: 3) // ⚠️ Make sure this ID is unique in your app
class SavingsModel extends HiveObject {
  @HiveField(0)
  double amount; // The amount saved

  @HiveField(1)
  DateTime date; // When the saving was made

  @HiveField(2)
  String? note; // Optional description or goal name

  SavingsModel({
    required this.amount,
    required this.date,
    this.note,
  });
}
