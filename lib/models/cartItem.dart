class CartItem {
  final int productId;
  final String code;
  final String name;
  final double price;
  int quantity; // có thể tăng giảm
  double get total => price * quantity;

  CartItem({
    required this.productId,
    required this.code,
    required this.name,
    required this.price,
    this.quantity = 1,
    wwwwwww,
  });

  // Tạo từ JSON (nếu bạn muốn load từ API)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['ProductId'] ?? 0,
      code: json['Code'] ?? '',
      name: json['Name'] ?? '',
      price: (json['Price'] as num?)?.toDouble() ?? 0,
      quantity: json['Quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'Code': code,
      'Name': name,
      'Price': price,
      'Quantity': quantity,
    };
  }
}
