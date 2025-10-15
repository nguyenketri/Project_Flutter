import 'package:first_app/repositores/api_order.dart';
import 'package:first_app/state/authen_provider.dart';
import 'package:first_app/state/product_provider.dart';
import 'package:first_app/utils/formatNumber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    final authProvider = Provider.of<AuthenProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      productProvider.setSession(authProvider.user!.sessionId!);
      productProvider.fetchNextPage();

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          productProvider.fetchNextPage();
        }
      });
    });
  }

  void _submitOrder(BuildContext context) async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final cart = provider.cart;
    final authProvider = Provider.of<AuthenProvider>(context, listen: false);
    print("Đang gửi order ${cart.length} sản phẩm...");

    // TODO: Gửi API ở đây
    sendOrder(authProvider.user!.sessionId!, cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List"),
        actions: [
          IconButton(
            icon: Icon(Icons.done, color: Colors.blue),
            onPressed: () {
              setState(() {
                _submitOrder(context);
              });
            },
          ),
        ],
      ),

      body: Consumer<ProductProvider>(
        builder: (_, provider, __) {
          final products = provider.products;

          if (products.isEmpty && provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                itemCount: products.length + 1,
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final item = products[index];
                    return Card(
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey, // 🎨 Màu viền
                              width: 2, // 🔢 Độ dày viền
                            ),
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // 👈 Bo nhẹ 8px
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/authen.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          item.name.toUpperCase(),
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${item.code}"),
                            Text("Giá: ${formatCurrency.format(item.price)}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Nút trừ
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  if (item.quantity > 0) item.quantity--;
                                });
                                Provider.of<ProductProvider>(
                                  context,
                                  listen: false,
                                ).addToCart(item);
                              },
                            ),

                            // Số lượng ở giữa
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Nút cộng
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  item.quantity++;
                                });
                                Provider.of<ProductProvider>(
                                  context,
                                  listen: false,
                                ).addToCart(item);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
