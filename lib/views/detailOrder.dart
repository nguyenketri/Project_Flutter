import 'package:first_app/models/detailOrder.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/repositores/api_order.dart';
import 'package:first_app/repositores/api_product.dart';
import 'package:flutter/material.dart';

class DetailorderScreen extends StatefulWidget {
  int orderId;
  final String sessionId;
  DetailorderScreen({required this.sessionId, required this.orderId});

  @override
  State<DetailorderScreen> createState() => _DetailorderScreenState();
}

class _DetailorderScreenState extends State<DetailorderScreen> {
  List<ProductModel> lists = [];
  Future<void> fetchDetail() async {
    final result = await fetchDetailOrder(widget.sessionId, widget.orderId);
    setState(() {
      lists = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: fetchDetail),
        ],
      ),
      body: GridView.builder(
        itemCount: lists.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // ✅ 2 cột
          crossAxisSpacing: 12, // khoảng cách ngang giữa 2 card
          mainAxisSpacing: 12, // khoảng cách dọc giữa các hàng
          childAspectRatio: 3 / 4, // tỷ lệ khung (ngang/dọc)
        ),
        itemBuilder: (context, index) {
          final product = lists[index];
          return Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq_wwpBx5FO6MoJaZZ3diehy6ODULmCWYMzg&s",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "${product.name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            "Code: ${product.code}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            "${product.price} đ",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
