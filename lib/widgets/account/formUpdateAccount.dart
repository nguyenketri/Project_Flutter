import 'package:first_app/models/account.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/repositores/api_customers.dart';
import 'package:first_app/repositores/api_product.dart';
import 'package:flutter/material.dart';

class FormUpdateAccount extends StatefulWidget {
  final String sessionId;
  final AccountModel account;
  FormUpdateAccount({required this.sessionId, required this.account});
  @override
  State<FormUpdateAccount> createState() => _FormProductState();
}

class _FormProductState extends State<FormUpdateAccount> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các field
  late TextEditingController _idController;
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _typeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idController = TextEditingController(text: widget.account.id.toString());
    _codeController = TextEditingController(text: widget.account.code);
    _nameController = TextEditingController(text: widget.account.name);
    _phoneController = TextEditingController(
      text: widget.account.phone.toString(),
    );

    _typeController = TextEditingController(
      text: widget.account.type.toString(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _idController.dispose();
    _nameController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _typeController.dispose();
  }

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
        "Id": _idController.text,
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
      appBar: AppBar(title: const Text("Form Update Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // form key để quản lý trạng thái form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Id
              TextFormField(
                controller: _idController,
                decoration: _inputDecoration("Id"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Id không được để trống";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Code
              TextFormField(
                controller: _codeController,
                decoration: _inputDecoration("Code"),
              ),
              const SizedBox(height: 16),

              // Tên sản phẩm
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration("Name Customer"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tên sản phẩm không được để trống";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Giá
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration("Phone"),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone được để trống";
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
                controller: _typeController,
                decoration: _inputDecoration("Type"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Type không được để trống";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Nút Lưu
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveCustomer(widget.sessionId);
                    // ✅ Tất cả field hợp lệ
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
