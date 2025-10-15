import 'dart:convert';
import 'package:first_app/models/product.dart';
import 'package:first_app/models/productResponse.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/productResponse.dart';

const String baseUrl = "https://cafe365.pos365.vn";

// ---------------- Fetch Products ----------------
Future<List<ProductModel>> fetchCategogyById(
  String sessionId,
  int top,
  int skip,
) async {
  final url = Uri.parse(
    "$baseUrl/api/products?format=json&\$top=$top&\$skip=$skip",
  );

  final response = await http.get(url, headers: {"Cookie": "ss-id=$sessionId"});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("res: ${response.body}");
    print("Data test products:${data['results']}");
    final productResponse = ProductResponse.fromJson(data);
    return productResponse.results;
  } else if (response.statusCode == 401) {
    throw Exception("Session hết hạn (401), cần login lại");
  } else {
    throw Exception("Lấy danh sách sản phẩm thất bại: ${response.statusCode}");
  }
}
