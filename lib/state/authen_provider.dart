import 'package:first_app/models/authen.dart';
import 'package:first_app/repositores/api_login.dart';
import 'package:first_app/views/siderbar.dart';
import 'package:first_app/views/login.dart';
import 'package:flutter/material.dart';

class AuthenProvider extends ChangeNotifier {
  AuthenModel? _auth;
  bool _isLoading = false;

  AuthenModel? get user => _auth;
  bool get isLoading => _isLoading;

  Future<bool> login(String userName, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _auth = await loginApi(userName, password);

      // ✅ Kiểm tra thật sự có SessionId (đăng nhập thành công)
      if (_auth != null && _auth!.sessionId!.isNotEmpty) {
        debugPrint("✅ Login success: ${_auth!.sessionId}");
        return true;
      } else {
        debugPrint("❌ Login failed: SessionId empty");
        return false;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _auth = null;
    notifyListeners();
  }
}
