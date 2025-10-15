import 'package:first_app/models/product.dart';
import 'package:first_app/repositores/api_product.dart';
import 'package:first_app/state/product_provider.dart';
import 'package:first_app/widgets/common/form_delete.dart';
import 'package:first_app/widgets/product/addProduct.dart';
import 'package:first_app/widgets/product/updateProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final String sessionId;
  const ProductScreen({required this.sessionId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool search = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      productProvider.setSession(widget.sessionId);
      productProvider.fetchNextPage();

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          productProvider.fetchNextPage();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  context.read<ProductProvider>().searchProduct(value);
                },
              )
            : Text("Danh sách sản phẩm"),
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
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mã: ${item.code}"),
                            Text("Giá: ${item.price}"),
                            Text("CategoryId: ${item.categoryId ?? 0}"),
                            Text("Category: ${item.category?.name ?? ''}"),
                            Text("PId: ${item.id}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // TODO: mở dialog edit
                            IconButton(
                              onPressed: () async {
                                final newProduct = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FormUpdateProduct(
                                      sessionId: widget.sessionId,
                                      product: item,
                                    ),
                                  ),
                                );

                                if (newProduct != null) {
                                  final pro = Provider.of<ProductProvider>(
                                    context,
                                    listen: false,
                                  );
                                  pro.reset();
                                  pro.fetchNextPage();
                                  // hoặc pro.reset() + pro.fetchNextPage();
                                }
                              },
                              icon: Icon(Icons.edit, color: Colors.blue),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showConfirmDeleteDialog(
                                  context,
                                  onConfirm: () async {
                                    // TODO: gọi API xoá
                                    deleteProduct(widget.sessionId, item.id);
                                    print("Đã xác nhận xoá!");
                                    final pro = Provider.of<ProductProvider>(
                                      context,
                                      listen: false,
                                    );
                                    pro.reset();
                                    pro.fetchNextPage();
                                    showTopSnackBar(context, "Delete Success");
                                    // Ví dụ: gọi Provider để reload danh sách
                                    // final provider = Provider.of<ProductProvider>(context, listen: false);
                                    // await provider.deleteProduct(product.id);
                                    // provider.reloadProducts();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return provider.isLoading
                        ? Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : SizedBox.shrink();
                  }
                },
              ),
              Positioned(
                bottom: 5,
                right: 5,

                child: IconButton(
                  onPressed: () async {
                    final newProduct = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FormProduct(sessionId: widget.sessionId),
                      ),
                    );

                    if (newProduct != null) {
                      final pro = Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      );
                      pro.reset();
                      pro.fetchNextPage();
                      // hoặc pro.reset() + pro.fetchNextPage();
                    }
                  },
                  icon: Icon(Icons.add_circle, color: Colors.blue),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
