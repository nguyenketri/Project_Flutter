import 'package:first_app/repositores/api_order.dart';
import 'package:first_app/state/order_provider.dart';
import 'package:first_app/views/detailOrder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  final String sessionId;
  OrderScreen({required this.sessionId});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool loading = true;
  bool search = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<OrderProvider>(
        context,
        listen: false,
      );

      productProvider.setSession(widget.sessionId);
      productProvider.fetchNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: search
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(hintText: "Tìm kiếm..."),
                onChanged: (value) {
                  context.read<OrderProvider>().searchOrder(value);
                },
              )
            : Text("Quản Lý Orders"),
        actions: [
          IconButton(
            icon: Icon(search ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                search = !search;
              });
            },
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (_, provider, _) {
          final orders = provider.orders;

          if (orders.isEmpty && provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final item = orders[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3), // đổ bóng xuống dưới
                    ),
                  ],
                ),

                child: ListTile(
                  title: Text("Code: ${item.code}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // căn trái
                    mainAxisSize: MainAxisSize
                        .min, // thu nhỏ column, không chiếm full chiều cao
                    children: [
                      Text("Ngày: ${item.purchaseDate} "),
                      Text("Tổng: ${item.total ?? 0}"),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Tooltip(
                        waitDuration: Duration(
                          milliseconds: 100,
                        ), // 👈 hiện sau 0.1s
                        showDuration: Duration(seconds: 3),
                        message: "Details",
                        child: IconButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailorderScreen(
                                  sessionId: widget.sessionId,
                                  orderId: item.id,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.details_outlined),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Deletion Order'),
                              content: const Text(
                                'Are you sure you want to delete this item?.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(false); // đóng dialog, trả về false
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(true); // đóng dialog, trả về true
                                  },
                                ),
                              ],
                            ),
                          );

                          // Nếu người dùng chọn "Delete"
                          if (shouldDelete == true) {
                            // TODO: gọi hàm xóa đơn hàng ở đây
                            deleteOrderById(widget.sessionId, item.id);
                            print("Đã xác nhận xóa đơn hàng ID: ${item.id}");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Deleted Success')),
                            );
                            await context.read<OrderProvider>().refreshOrder(
                              item.id,
                            );
                          }
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
