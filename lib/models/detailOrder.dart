import 'package:first_app/models/product.dart';

class DetailOrderModel {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double price;
  final double basePrice;
  final String description;
  final bool isLargeUnit;
  final int conversionValue;
  final int coefficient;
  final int proceessed;
  final int soldById;
  final bool isPromotion;
  final ProductModel product;

  DetailOrderModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.description,
    required this.price,
    required this.basePrice,
    required this.isLargeUnit,
    required this.soldById,
    required this.coefficient,
    required this.conversionValue,
    required this.proceessed,
    required this.isPromotion,
    required this.product,
  });

  factory DetailOrderModel.fromJson(Map<String, dynamic> json) {
    return DetailOrderModel(
      id: json['Id'] ?? 0,
      orderId: json['OrderId'] ?? 0,
      productId: json['ProductId'] ?? 0,
      quantity: (json['Quantity'] ?? 0).toInt(),
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      basePrice: (json['BasePrice'] as num?)?.toDouble() ?? 0.0,
      description: json['Description'] ?? '',
      isLargeUnit: json['IsLargeUnit'] ?? false,
      conversionValue: json['ConversionValue'] ?? 1,
      coefficient: json['Coefficient'] ?? 1,
      proceessed: json['Proceessed'] ?? 0,
      soldById: json['SoldById'] ?? 0,
      isPromotion: json['IsPromotion'] ?? false,
      product: ProductModel.fromJson(json['Product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "OrderId": orderId,
      "ProductId": productId,
      "Quantity": quantity,
      "Price": price,
      "BasePrice": basePrice,
      "Description": description,
      "IsLargeUnit": isLargeUnit,
      "ConversionValue": conversionValue,
      "Coefficient": coefficient,
      "Proceessed": proceessed,
      "SoldById": soldById,
      "IsPromotion": isPromotion,
      "Product": product,
    };
  }
}
