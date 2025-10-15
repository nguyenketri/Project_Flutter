import 'package:flutter/material.dart';

// Fake ProductModel
class ProductModel {
  final String code;
  final String name;
  final double price;
  final int quantity;

  ProductModel({
    required this.code,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class PrintPreviewScreen extends StatelessWidget {
  final List<ProductModel> cart;

  // Nếu không truyền cart, sẽ dùng danh sách fake
  PrintPreviewScreen({List<ProductModel>? cart})
    : cart =
          cart ??
          [
            ProductModel(
              code: 'HH-2496',
              name: 'Sữa chua Kiwi',
              price: 35000,
              quantity: 1,
            ),
            ProductModel(
              code: 'HH-2495',
              name: 'Trà sữa socola',
              price: 30000,
              quantity: 2,
            ),
            ProductModel(
              code: 'HH-2481',
              name: 'Trà Đào',
              price: 25000,
              quantity: 1,
            ),
          ];

  @override
  Widget build(BuildContext context) {
    final total = cart.fold<double>(
      0,
      (sum, p) => sum + p.price * p.quantity,
    ); // tính tổng thật

    return Scaffold(
      appBar: AppBar(title: const Text("Print Preview")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'HÓA ĐƠN',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FixedColumnWidth(80),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(50),
                3: FixedColumnWidth(80),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: ['Mã SP', 'Tên sản phẩm', 'SL', 'Giá']
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            e,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                      .toList(),
                ),
                ...cart.map(
                  (p) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(p.code),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(p.name),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('${p.quantity}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('${p.price}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Tổng tiền: ${total.toStringAsFixed(0)} VND',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
