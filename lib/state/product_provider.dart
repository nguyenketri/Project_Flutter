import 'package:first_app/models/product.dart';
import 'package:first_app/repositores/api_product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  int _skip = 0;
  final int _top = 20;
  String? _sessionId;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  void setSession(String sessionId) {
    _sessionId = sessionId;
  }

  Future<void> fetchNextPage() async {
    if (_isLoading || _sessionId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await fetchProducts(_sessionId!, _top, _skip);
      print("New Prouduct: ${newProducts}");
      _products.addAll(newProducts);
      _skip += _top;
    } catch (e) {
      debugPrint("Fetch products error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProduct(String keyword) async {
    if (_isLoading || _sessionId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // reset khi search
      _skip = 0;
      _products.clear();

      final allProducts = await fetchProducts(_sessionId!, 9999, 0); // lấy hết
      final filtered = allProducts
          .where(
            (item) =>
                item.name.toLowerCase().contains(keyword.toLowerCase()) ||
                item.code.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();

      _products = filtered;
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ProductModel> cart = [];

  void addToCart(ProductModel product) {
    final index = cart.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      cart[index].quantity = product.quantity;
    } else {
      cart.add(product);
    }
    notifyListeners();
  }

  void changeListP() {
    _products = [];
  }

  void reset() {
    _products = [];
    _skip = 0;
    notifyListeners();
  }

  void clearCart() {
    cart = [];
    notifyListeners();
  }
}
