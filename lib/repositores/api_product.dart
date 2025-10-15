import 'dart:convert';
import 'package:first_app/models/product.dart';
import 'package:first_app/models/productResponse.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/productResponse.dart';

const String baseUrl = "https://cafe365.pos365.vn";

// ---------------- Fetch Products ----------------
Future<List<ProductModel>> fetchProducts(
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

// Save
Future<Map<String, dynamic>> saveProduct(
  String sessionId,
  Map<String, dynamic> body,
) async {
  final url = Uri.parse("$baseUrl/api/products");

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Cookie": "ss-id=$sessionId",
    },
    body: jsonEncode(body),
  );

  print("Request: ${jsonEncode(body)}");
  print("Status: ${response.statusCode}");
  print("Response: ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final data = jsonDecode(response.body);
    final msg = data['ResponseStatus']?['Message'] ?? "POSException";
    throw Exception("Save thất bại: ${response.statusCode} - $msg");
  }
}

// ---------------- Delete Product ----------------
Future<Map<String, dynamic>> deleteProduct(
  String sessionId,
  int productId,
) async {
  final url = Uri.parse("$baseUrl/api/products/$productId?format=json");

  final response = await http.delete(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Cookie": "ss-id=$sessionId",
    },
  );

  print("DELETE ProductId=$productId Status=${response.statusCode}");
  print("Response: ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final data = jsonDecode(response.body);
    final msg = data['ResponseStatus']?['Message'] ?? "Xóa thất bại";
    throw Exception(msg);
  }
}

// ---------------- Find Product ----------------
Future<ProductModel> findProductByid(String sessionId, int productId) async {
  final url = Uri.parse("$baseUrl/api/products/$productId?format=json");

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Cookie": "ss-id=$sessionId",
    },
  );

  print("Response: ${response.body}");

  if (response.statusCode == 200) {
    return ProductModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  } else {
    final data = jsonDecode(response.body);
    final msg = data['ResponseStatus']?['Message'] ?? "Xóa thất bại";
    throw Exception(msg);
  }
}

// All Product by ID
Future<List<ProductModel>> fetchAllProducts(
  String sessionId,
  List<int> ids,
) async {
  final futures = ids.map((id) => findProductByid(sessionId, id)).toList();
  return await Future.wait(futures);
}
