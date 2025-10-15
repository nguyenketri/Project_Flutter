import 'package:first_app/repositores/api_customers.dart';
import 'package:first_app/repositores/api_product.dart';

import 'package:flutter/material.dart';

class FormAddAccount extends StatefulWidget {
  final String sessionId;
  FormAddAccount({required this.sessionId});
  @override
  State<FormAddAccount> createState() => _FormAddAccountState();
}

class _FormAddAccountState extends State<FormAddAccount> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các field
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  void _saveCustomer(String sessionId) async {
    String code = _codeController.text.isEmpty ? "" : _codeController.text;

    print("Final code: $code");

    final body = {
      "Partner": {
        "Type": _typeController.text,
        "Phone": _phoneController.text,
        "Code": code,
        "Name": _nameController.text,
      },
    };

    try {
      final result = await saveCustomer(sessionId, body);
      Navigator.pop(context, result); // trả result về
      print("✅ Lưu thành công: $result");
    } catch (e) {
      print("❌ Lỗi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Add Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // form key để quản lý trạng thái form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Code
              TextFormField(
                controller: _typeController,
                decoration: _inputDecoration("Type"),
              ),
              const SizedBox(height: 16),

              // Tên sản phẩm
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Name Customer"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name không được để trống";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Giá
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration("Phone"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone không được để trống";
                  }
                  if (double.tryParse(value) == null) {
                    return "Phone phải là số";
                  }
                  if (double.tryParse(value)! <= 0) {
                    return "Phone phải lớn hơn 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Id
              TextFormField(
                controller: _codeController,
                decoration: _inputDecoration("Code"),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Nút Lưu
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveCustomer(widget.sessionId);
                  }
                },
                child: const Text("Lưu"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
