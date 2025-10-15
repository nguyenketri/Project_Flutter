import 'package:first_app/repositores/api_customers.dart';
import 'package:first_app/state/account_provider.dart';
import 'package:first_app/widgets/account/formAddAccount.dart';
import 'package:first_app/widgets/account/formUpdateAccount.dart';
import 'package:first_app/widgets/common/form_delete.dart';
import 'package:first_app/widgets/product/addProduct.dart';
import 'package:first_app/widgets/product/updateProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerScreen extends StatefulWidget {
  final sessionId;
  const CustomerScreen({required this.sessionId});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  ScrollController _scrollController = ScrollController();
  bool search = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // gần cuối list => load thêm
        final provider = Provider.of<AccountProvider>(context, listen: false);
        provider.fetchNextPage();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AccountProvider>(context, listen: false);
      provider.setSession(widget.sessionId);
      provider.fetchNextPage(); // gọi lần đầu
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
                  context.read<AccountProvider>().searchAccount(value);
                },
              )
            : Text("List Customers"),
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
      body: Stack(
        children: [
          Consumer<AccountProvider>(
            builder: (_, provider, __) {
              final accounts = provider.accounts;

              if (accounts.isEmpty && provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (accounts.isEmpty) {
                return const Center(child: Text("Không có khách hàng"));
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final item = accounts[index];
                  return Card(
                    child: ListTile(
                      leading: item.gender == 1
                          ? CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.male, color: Colors.white),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.pink,
                              child: Icon(Icons.female, color: Colors.white),
                            ),
                      title: Text(item.name),
                      subtitle: Text(item.code ?? ""),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TODO: mở dialog edit
                          IconButton(
                            onPressed: () async {
                              final newProduct = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FormUpdateAccount(
                                    sessionId: widget.sessionId,
                                    account: item,
                                  ),
                                ),
                              );

                              if (newProduct != null) {
                                final pro = Provider.of<AccountProvider>(
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
                                  deleteCustomer(widget.sessionId, item.id);
                                  print("Đã xác nhận xoá!");
                                  final pro = Provider.of<AccountProvider>(
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
                },
              );
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
                    builder: (_) => FormAddAccount(sessionId: widget.sessionId),
                  ),
                );

                if (newProduct != null) {
                  final customer = Provider.of<AccountProvider>(
                    context,
                    listen: false,
                  );
                  customer.reset();
                  customer.fetchNextPage();
                  // hoặc pro.reset() + pro.fetchNextPage();
                }
              },
              icon: Icon(Icons.add_circle, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
