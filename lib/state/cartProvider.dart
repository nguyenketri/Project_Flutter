import 'package:first_app/models/cartItem.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double _baseTotal = 0; // tổng gốc, chưa VAT
  double _totalAmount = 0; // tổng sau khi áp VAT

  double get totalAmount => _totalAmount;

  // Setter dùng để áp phần trăm VAT
  set totalAmount(double vatPercent) {
    _totalAmount = _baseTotal + (_baseTotal * vatPercent / 100);
    notifyListeners();
  }

  // Hàm tính lại tổng gốc (không VAT)
  void recalculateTotal() {
    _baseTotal = _items.fold(0, (sum, item) => sum + item.total);
    _totalAmount = _baseTotal; // mặc định = tổng gốc
    notifyListeners();
  }

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  // Thêm sản phẩm vào cart
  void addToCart(CartItem item) {
    final index = _items.indexWhere((p) => p.productId == item.productId);
    if (index >= 0) {
      // Nếu sản phẩm đã có trong cart, tăng quantity
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    recalculateTotal(); // ✅ Luôn gọi sau khi cập nhật giỏ hàng
    notifyListeners();
  }

  // Xóa sản phẩm khỏi cart
  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  // Xóa tất cả
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Cập nhật số lượng sản phẩm
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      quantity = 1;
      notifyListeners();
    }
    final index = _items.indexWhere((p) => p.productId == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }
}
