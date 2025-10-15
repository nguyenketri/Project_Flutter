import 'package:first_app/models/categories.dart';

class ProductModel {
  final int id;
  final String code;
  final String name;
  final double price;
  final double cost;
  final String unit;
  final int categoryId;
  int quantity;
  final CategoryModel? category;
  final DateTime? createdDate;
  final DateTime? modifiedDate;

  ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.price,
    required this.cost,
    required this.unit,
    required this.categoryId,
    required this.quantity,
    this.category,
    this.createdDate,
    this.modifiedDate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['Id'],
      code: json['Code'] ?? '',
      name: json['Name'] ?? '',
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      cost: (json['Cost'] as num?)?.toDouble() ?? 0.0,
      unit: json['Unit'] ?? '',
      categoryId: json['CategoryId'] ?? 0,
      quantity: json['Quantity'] ?? 0,
      category: json['Category'] != null
          ? CategoryModel.fromJson(json['Category'])
          : null,
      createdDate: json['CreatedDate'] != null
          ? DateTime.tryParse(json['CreatedDate'])
          : null,
      modifiedDate: json['ModifiedDate'] != null
          ? DateTime.tryParse(json['ModifiedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Code": code,
      "Name": name,
      "Price": price,
      "Cost": cost,
      "Unit": unit,
      "CategoryId": categoryId,
      "Quantity": quantity,
      "Category": category?.toJson(),
      "CreatedDate": createdDate?.toIso8601String(),
      "ModifiedDate": modifiedDate?.toIso8601String(),
    };
  }
}
