import 'package:ai_cv_generator/models/user/userDetails.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';


//for creating a user and editing a user
@JsonSerializable()
class UserModel {
  @JsonKey(name: "fname")
  String fname;
  @JsonKey(name: "userid")
  String? id;
  String? createdAt;
  String? updatedAt;
  Details? details;
  

  UserModel({
    required this.fname,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}