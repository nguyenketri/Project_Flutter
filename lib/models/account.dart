import 'dart:ffi';

class AccountModel {
  final int id;
  final String? code;
  final String name;
  final String? phone;
  final int? gender;
  final double? debt;
  final int? type;

  AccountModel({
    required this.id,
    this.code,
    required this.name,
    this.phone,
    this.gender,
    this.debt,
    this.type,
  });

  // Convert JSON -> UserModel
  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['Id'],
      name: json['Name'] ?? '',
      code: json['Code'],
      debt: json['Debt'],
      gender: json['Gender'],
      type: json['Type'],
      phone: json['Phone'],
    );
  }

  // Convert UserModel to Json
  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Name": name,
      "Code": code,
      "Debt": debt,
      "Gender": gender,
      "Type": type,
      "Phone": phone,
    };
  }
}
