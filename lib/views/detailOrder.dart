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
  List<DetailOrderModel> lists = [];
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
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) {
          final item = lists[index];
          return FutureBuilder(
            future: findProductByid(widget.sessionId, item.productId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(title: Text('Đang tải sản phẩm...'));
              } else if (snapshot.hasError) {
                return ListTile(title: Text('Lỗi: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final product = snapshot.data!;
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize:
                          MainAxisSize.min, // Make column take minimum height
                      children: <Widget>[
                        Text(
                          '${product.name}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Text('Code:${product.code} ')),
                            SizedBox(width: 5),
                            Expanded(child: Text('| Price:${product.price} ')),
                            SizedBox(width: 5),
                            Expanded(child: Text('| Unit:${product.unit} ')),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text('| Quantity:${product.quantity} '),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Tooltip(
                          message: "Detail",
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Back'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const ListTile(title: Text('Không có dữ liệu'));
              }
            },
          );
        },
      ),
    );
  }
}
