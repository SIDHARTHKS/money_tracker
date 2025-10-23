import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Generated adapter file

@HiveType(typeId: 0) // Unique typeId for this model
class UserModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? userImage; // Can store file path or base64 string

  UserModel({required this.name, this.userImage});
}
