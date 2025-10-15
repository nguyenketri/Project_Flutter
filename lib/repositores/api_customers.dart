import 'dart:convert';
import 'package:first_app/models/account.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "http://cafe365.pos365.vn";

// --- fetch Cusromers ----

Future<List<AccountModel>> fetchCustomers(
  String sessionId,
  int type,
  int top,
  int skip,
) async {
  final url =
      "https://cafe365.pos365.vn/api/partners?format=json&Type=$type&\$top=$top&\$skip=$skip";
  final response = await http.get(
    Uri.parse(url),
    headers: {"Cookie": "ss-id=$sessionId"},
  );

  if (response.statusCode == 200) {
    final map = jsonDecode(response.body) as Map<String, dynamic>;
    final results = map['results'] as List<dynamic>;
    print("Result: ${results}");
    return results
        .map((json) => AccountModel.fromJson(json)) // convert sang model
        .toList();
  } else {
    throw Exception("Lỗi: ${response.statusCode} ${response.body}");
  }
}

Future<Map<String, dynamic>> saveCustomer(
  String sessionId,
  Map<String, dynamic> customerSaveData,
) async {
  final url = Uri.parse("$baseUrl/api/partners"); // xóa 1 dấu / thừa
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Cookie": "ss-id=$sessionId", // nếu cần ss-pid, thêm ss-pid
    },
    body: jsonEncode(customerSaveData), // ← đưa body vào đây
  );

  print("Request: ${jsonEncode(customerSaveData)}");
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
Future<Map<String, dynamic>> deleteCustomer(
  String sessionId,
  int customerId,
) async {
  final url = Uri.parse("$baseUrl/api/partners/$customerId?format=json");

  final response = await http.delete(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Cookie": "ss-id=$sessionId",
    },
  );

  print("DELETE CustomerId=$customerId Status=${response.statusCode}");
  print("Response: ${response.body}");

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    final data = jsonDecode(response.body);
    final msg = data['ResponseStatus']?['Message'] ?? "Xóa thất bại";
    throw Exception(msg);
  }
}
