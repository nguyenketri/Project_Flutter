import 'package:first_app/models/product.dart';

class ProductResponse {
  final int count;
  final List<ProductModel> results;

  ProductResponse({required this.count, required this.results});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      count: json['__count'] ?? 0,
      results: (json['results'] as List)
          .map((item) => ProductModel.fromJson(item))
          .toList(),
    );
  }
}
