import 'dart:convert';
import 'package:first_app/models/detailOrder.dart';
import 'package:first_app/models/orders.dart';
import 'package:first_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://cafe365.pos365.vn";

Future<List<OrderModel>> fetchOrders(String sessionId) async {
  final url = Uri.parse("${baseUrl}/api/orders?format=json&Includes=Partner");

  final response = await http.get(url, headers: {"Cookie": "ss-id=$sessionId"});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['results'] as List<dynamic>;
    print("Data: ${response.body}");
    return results.map((json) => OrderModel.fromJson(json)).toList();
  } else {
    throw Exception("Lỗi ${response.statusCode}: ${response.body}");
  }
}

Future<List<DetailOrderModel>> fetchDetailOrder(
  String sessionId,
  int orderId,
) async {
  final url = Uri.parse(
    "https://cafe365.pos365.vn/api/orders/detail?format=json&Includes=Product&IncludeSummary=false&OrderId=${orderId}",
  );
  final response = await http.get(
    url,
    headers: {"Cookie": "ss-id=${sessionId}"},
  );

  if (response.statusCode == 200) {
    print(response.body);
    final map = jsonDecode(response.body) as Map<String, dynamic>;
    final results = map['results'] as List<dynamic>;
    print("Result: ${results}");
    return results
        .map((json) => DetailOrderModel.fromJson(json)) // convert sang model
        .toList();
  } else {
    print("Lỗi---------------------: ${response.statusCode} ${response.body}");
    throw Exception("Lỗi : ${response.statusCode} ${response.body}");
  }
}

Future<void> sendOrder(String sessionId, List<ProductModel> cart) async {
  final url = Uri.parse("https://cafe365.pos365.vn/api/orders");

  final orderDetails = cart
      .map(
        (p) => {
          "ProductId": p.id,
          "Code": p.code,
          "Name": p.name,
          "Price": p.price,
          "Quantity": p.quantity,
        },
      )
      .toList();

  final body = {
    "Order": {
      "AmountReceived": 65000,
      "Code": "",
      "Description": "",
      "Discount": 0,
      "ExcessCash": 0,
      "Id": 0,
      "OrderDetails": orderDetails,
      "PurchaseDate": DateTime.now().toIso8601String(),
      "ShippingCost": 0,
      "SoldById": 167053,
      "Status": 2,
      "Total": 65000,
      "TotalAdditionalServices": 0,
      "TotalPayment": 65000,
      "VAT": 0,
      "VATRates": "0",
      "Voucher": 0,
      "AccountId": null,
      "MoreAttributes": null,
    },
  };

  print("=== BODY gửi đi ===");
  print(jsonEncode(body));

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json", "Cookie": "ss-id=$sessionId"},
    body: jsonEncode(body),
  );

  print("=== RESPONSE STATUS: ${response.statusCode}");
  print("=== RESPONSE BODY: ${response.body}");

  if (response.statusCode == 200) {
    print("✅ Gửi order thành công!");
  } else {
    print("❌ Gửi order thất bại!");
  }
}

Future<void> deleteOrderById(String sessionId, int idOrder) async {
  final url = Uri.parse(
    "https://cafe365.pos365.vn/api/orders/${idOrder}/void?format=json",
  );
  final response = await http.delete(
    url,
    headers: {"Cookie": "ss-id=${sessionId}"},
  );
  print("Response: ${url}");
  print("id: ${idOrder} amd sessionId: ${sessionId}");
  if (response.statusCode == 200) {
    print("✅ Delete order thành công!");
  } else {
    print("❌ Delete order thất bại!");
    print(response.statusCode);
  }
}
