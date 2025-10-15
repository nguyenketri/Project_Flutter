import 'dart:convert';
import 'package:first_app/models/authen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<AuthenModel> loginApi(String username, String password) async {
  final url = Uri.parse(
    "https://cafe365.pos365.vn/api/auth/credentials?format=json&Username=$username&Password=$password",
  );

  final response = await http.get(url);
  print('res: ${response.headers}');

  if (response.statusCode == 200) {
    print('res: ${response}');
    print('res header : ${response.headers}');

    final data = json.decode(response.body);
    print('res body: ${response.body}');

    return AuthenModel.fromJson(data); // Trả về SessionId
  } else {
    throw Exception("Login failed: empty response with ${response.statusCode}");
  }
}
