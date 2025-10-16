import 'package:first_app/models/cartItem.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/repositores/api_order.dart';
import 'package:first_app/state/authen_provider.dart';
import 'package:first_app/state/cartProvider.dart';
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
  String? selectedUnit;
  List<String> _listUnit = [];
  @override
  void initState() {
    super.initState();

    fetchDataProduct();
    selectedUnit = _listUnit.first; // gán giá trị mặc định
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

  void fetchDataProduct() {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final List<String> listUnit = productProvider.products
        .map((p) => p.unit ?? '') // lấy unit, nếu null thì để ''
        .where((unit) => unit.isNotEmpty) // bỏ rỗng
        .toSet() // loại bỏ trùng lặp
        .toList(); // thành list

    _listUnit = List<String>.from(listUnit);
    _listUnit.insert(0, "All");
  }

  void selectedProductByUnit(String unit) {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final List<String> listUnit = productProvider.products
        .map((p) => p.unit ?? '') // lấy unit, nếu null thì để ''
        .where((unit) => unit.isNotEmpty) // bỏ rỗng
        .toSet() // loại bỏ trùng lặp
        .toList(); // thành list

    _listUnit = List<String>.from(listUnit);
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
        title: const Text("HOME PAGE"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButtonHideUnderline(
              child: PopupMenuButton<String>(
                icon: Icon(Icons.filter_list, color: Colors.blue),
                onSelected: (value) {
                  setState(() {
                    selectedUnit = value;
                  });
                },
                itemBuilder: (context) {
                  return _listUnit.map((unit) {
                    return PopupMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ],
      ),

      body: Consumer<ProductProvider>(
        builder: (_, provider, __) {
          final filteredProducts = selectedUnit == "All"
              ? provider.products
              : provider.products.where((p) => p.unit == selectedUnit).toList();

          if (filteredProducts.isEmpty && provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // ✅ 2 cột
                crossAxisSpacing: 12, // khoảng cách ngang giữa 2 card
                mainAxisSpacing: 12, // khoảng cách dọc giữa các hàng
                childAspectRatio: 3 / 4, // tỷ lệ khung (ngang/dọc)
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
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
                            mainAxisSize: MainAxisSize.max,
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
                                  "${product.price} đ",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final item = CartItem(
                                      productId: product.id,
                                      code: product.code,
                                      name: product.name,
                                      price: product.price,
                                      quantity: 1,
                                    );
                                    context.read<CartProvider>().addToCart(
                                      item,
                                    );
                                  },
                                  child: Text("Add To Cart"),
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
            );
          }
        },
      ),
    );
  }
}
