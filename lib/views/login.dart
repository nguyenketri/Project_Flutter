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
  bool _obscureText = true;
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
      appBar: AppBar(title: Text("")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // ✅ căn giữa theo chiều dọc
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // ✅ kéo full chiều ngang
            children: <Widget>[
              // 🔹 Logo
              SizedBox(
                height: 100,
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/5087/5087579.png",
                  height: 80,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: const Text(
                  "Đăng nhập hệ thống POS365",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
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
      ),
    );
  }
}
