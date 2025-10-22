import 'package:hive/hive.dart';

part 'salary_model.g.dart';

@HiveType(typeId: 2)
class SalaryModel extends HiveObject {
  @HiveField(0)
  double totalSalary; // base salary/goal

  @HiveField(1)
  DateTime updatedAt; // when it was last updated

  @HiveField(2)
  DateTime month; // 👈 for monthly tracking (salary period)

  SalaryModel({
    required this.totalSalary,
    DateTime? updatedAt,
    DateTime? month,
  })  : updatedAt = updatedAt ?? DateTime.now(),
        month = month ?? DateTime(DateTime.now().year, DateTime.now().month);
}
