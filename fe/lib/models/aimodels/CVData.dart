import 'package:ai_cv_generator/models/aimodels/AIQualification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CVData.g.dart';

@JsonSerializable()
class CVData {
  String firstname;
  String lastname;
  String email;
  String phoneNumber;
  String location; 
  String? description;
  List<String>? employmenthis;
  List<AIQualification?>? qualifications;
  String? education_description;

  CVData({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phoneNumber,
    required this.location,
    this.description,
    this.employmenthis,
    this.qualifications,
    this.education_description
  });

  factory CVData.fromJson(Map<String,dynamic> json) => _$CVDataFromJson(json);

    Map<String,dynamic> toJson() => _$CVDataToJson(this);
}