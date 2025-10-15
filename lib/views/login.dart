import 'package:first_app/state/authen_provider.dart';
import 'package:first_app/views/home.dart';
import 'package:first_app/views/siderbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController(
    text: "admin",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "123456",
  );
  bool loading = false;
  bool _obscureText = false;
  void _login() async {
    if (_formKey.currentState!.validate()) {
      // input hợp lệ
      final name = _usernameController.text;
      final pass = _passwordController.text;

      // Xử lý logic login
      final authProvider = Provider.of<AuthenProvider>(context, listen: false);
      final result = await authProvider.login(name, pass);
      if (result == true) {
        // ✅ Thành công → chuyển sang Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SideMenu3Screen()),
        );
      } else {
        print("name:${name} and pass : ${pass}");
        // ❌ Sai tài khoản hoặc mật khẩu
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sai tài khoản hoặc mật khẩu")),
        );
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login POS365")),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "User Name",
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // 🔹 Password
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Mật khẩu",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập mật khẩu";
                }
                if (value.length < 6) {
                  return "Mật khẩu phải ít nhất 6 ký tự";
                }
                return null;
              },
            ),

            const SizedBox(height: 24),
            // 🔹 Button Login
            ElevatedButton(onPressed: _login, child: const Text("Đăng nhập")),
          ],
        ),
      ),
    );
  }
}
