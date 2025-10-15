import 'package:first_app/models/account.dart';
import 'package:first_app/repositores/api_customers.dart';
import 'package:flutter/material.dart';

class AccountProvider extends ChangeNotifier {
  List<AccountModel> _accounts = [];
  bool _isLoading = false;
  int _skip = 0;
  int _type = 1;
  final int _top = 20;
  String? _sessionId;

  List<AccountModel> get accounts => _accounts;
  bool get isLoading => _isLoading;

  void setSession(String sessionId) {
    _sessionId = sessionId;
  }

  Future<void> fetchNextPage() async {
    if (_isLoading || _sessionId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newAccounts = await fetchCustomers(_sessionId!, _type, _top, _skip);
      if (newAccounts.isNotEmpty) {
        _accounts.addAll(newAccounts);
        _skip += _top;
      }
    } catch (e) {
      debugPrint("Fetch customers error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchAccount(String keyword) async {
    if (_isLoading || _sessionId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _skip = 0;
      _accounts.clear();

      // Nếu API hỗ trợ search, thì gọi thẳng API search thay vì fetch all
      final allAccounts = await fetchCustomers(_sessionId!, 1, 9999, 0);

      _accounts = allAccounts
          .where(
            (item) =>
                item.name.toLowerCase().contains(keyword.toLowerCase()) ||
                (item.code ?? '').toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _accounts = [];
    _skip = 0;
    notifyListeners();
  }
}
