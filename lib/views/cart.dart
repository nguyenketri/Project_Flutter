import 'package:first_app/state/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ Hàng"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              ScaffoldMessenger.of(context).showMaterialBanner(
                MaterialBanner(
                  backgroundColor: Colors.yellow[100],
                  content: const Text(
                    'Bạn có chắc muốn xóa sản phẩm này không?',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Ẩn banner nếu bấm "Hủy"
                        ScaffoldMessenger.of(
                          context,
                        ).hideCurrentMaterialBanner();
                      },
                      child: const Text('HỦY'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Xóa toàn bộ cart
                        context.read<CartProvider>().clearCart();
                        // Ẩn banner
                        ScaffoldMessenger.of(
                          context,
                        ).hideCurrentMaterialBanner();

                        // Hiện Snackbar xác nhận
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xóa sản phẩm khỏi giỏ hàng'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        'XÓA',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (_, cart, __) {
          if (cart.items.isEmpty) {
            return const Center(child: Text("Giỏ hàng trống"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (_, index) {
                    final item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(item.quantity.toString()),
                        ),
                        title: Text(item.name),
                        subtitle: Text(
                          "${item.quantity} x ${item.price.toStringAsFixed(0)} đ = ${item.total.toStringAsFixed(0)} đ",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue,
                              ),
                              onPressed: () => {
                                if (item.quantity < 20)
                                  {
                                    cart.updateQuantity(
                                      item.productId,
                                      ++item.quantity,
                                    ),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Sản phẩm chọn tối đa 20!",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  },
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),

                              onPressed: () => {
                                if (item.quantity >= 2)
                                  {
                                    cart.updateQuantity(
                                      item.productId,
                                      --item.quantity,
                                    ),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Sản phẩm chọn tối thiểu là 1!",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  },
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                ScaffoldMessenger.of(
                                  context,
                                ).showMaterialBanner(
                                  MaterialBanner(
                                    backgroundColor: Colors.yellow[100],
                                    content: const Text(
                                      'Bạn có chắc muốn xóa sản phẩm này không?',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Ẩn banner nếu bấm "Hủy"
                                          ScaffoldMessenger.of(
                                            context,
                                          ).hideCurrentMaterialBanner();
                                        },
                                        child: const Text('HỦY'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Gọi hàm xóa trong provider
                                          cart.removeFromCart(item.productId);

                                          // Ẩn banner
                                          ScaffoldMessenger.of(
                                            context,
                                          ).hideCurrentMaterialBanner();

                                          // Hiện Snackbar xác nhận
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Đã xóa sản phẩm khỏi giỏ hàng',
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'XÓA',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("VAT"),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            cart.totalAmount = 2;
                          },
                          child: Text("2%"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cart.totalAmount = 5;
                          },
                          child: Text("5%"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cart.totalAmount = 10;
                          },
                          child: Text("10%"),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tổng cộng:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${cart.totalAmount.toStringAsFixed(0)} đ",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Xử lý thanh toán ở đây
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Thanh toán thành công!")),
                  );
                  cart.clearCart();
                },
                child: const Text("Thanh toán"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
