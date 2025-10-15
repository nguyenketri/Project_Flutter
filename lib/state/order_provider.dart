import 'package:first_app/models/orders.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/repositores/api_order.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _allOrders = []; // giữ toàn bộ dữ liệu
  List<OrderModel> _orders = []; // hiển thị
  bool _isLoading = false;
  String? _sessionId;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  void setSession(String sessionId) {
    _sessionId = sessionId;
  }

  Future<void> fetchNextPage() async {
    if (_isLoading || _sessionId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newOrders = await fetchOrders(_sessionId!);
      if (newOrders.isNotEmpty) {
        _allOrders.addAll(newOrders);
        _orders = List.from(_allOrders); // copy ra list hiển thị
      }
    } catch (e) {
      debugPrint("Fetch order error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchOrder(String keyword) async {
    if (_isLoading || _sessionId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      if (_sessionId == null) return;

      final lower = keyword.toLowerCase();
      _orders = _allOrders
          .where(
            (item) =>
                item.code.toLowerCase().contains(lower) ||
                (item.roomId != null && item.roomId.toString().contains(lower)),
          )
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshOrder(int idOrder) async {
    if (_sessionId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allOrders = _allOrders.where((item) => item.id != idOrder).toList();
      _orders = List.from(_allOrders);
    } catch (e) {
      debugPrint("Refresh error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
