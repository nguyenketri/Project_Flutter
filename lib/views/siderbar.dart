import 'package:first_app/state/authen_provider.dart';
import 'package:first_app/views/cart.dart';
import 'package:first_app/views/customers.dart';
import 'package:first_app/views/home.dart';
import 'package:first_app/views/login.dart';
import 'package:first_app/views/orders.dart';
import 'package:first_app/views/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu3Screen extends StatefulWidget {
  const SideMenu3Screen({Key? key}) : super(key: key);

  @override
  State<SideMenu3Screen> createState() => _SideMenu3ScreenState();
}

class _SideMenu3ScreenState extends State<SideMenu3Screen> {
  int selectedIndex = 0;

  final List<String> _titles = [
    "Home",
    "Customer",
    "Product",
    "Order",
    "Cart",
    "Đăng Xuất",
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenProvider>(context);

    final List<Widget> _pages = [
      HomeScreen(),
      CustomerScreen(sessionId: authProvider.user!.sessionId),
      ProductScreen(sessionId: authProvider.user!.sessionId!),
      OrderScreen(sessionId: authProvider.user!.sessionId!),
      CartPage(),
      LoginScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("POS365"),
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            height: 50,
            color: Colors.yellow[50],

            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_titles.length, (index) {
                  final bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });

                      // nếu chọn "Đăng xuất"
                      if (_titles[index] == "Đăng Xuất") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _titles[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      body: _pages[selectedIndex],
    );
  }
}
