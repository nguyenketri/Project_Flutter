import 'package:first_app/models/product.dart';
import 'package:first_app/repositores/api_product.dart';
import 'package:first_app/state/product_provider.dart';
import 'package:first_app/views/products.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class FormUpdateProduct extends StatefulWidget {
  final String sessionId;
  final ProductModel product;
  FormUpdateProduct({required this.sessionId, required this.product});
  @override
  State<FormUpdateProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormUpdateProduct> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các field
  late TextEditingController _idController;
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _categoryIdController;
  late TextEditingController _unitController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idController = TextEditingController(text: widget.product.id.toString());
    _codeController = TextEditingController(text: widget.product.code);
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _categoryIdController = TextEditingController(
      text: widget.product.categoryId.toString(),
    );
    _unitController = TextEditingController(text: widget.product.unit);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _idController.dispose();
    _nameController.dispose();
    _codeController.dispose();
    _categoryIdController.dispose();
    _priceController.dispose();
    _unitController.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  void _saveProduct(String sessionId) async {
    String code = _codeController.text.isEmpty ? "" : _codeController.text;

    print("Final code: $code");

    final body = {
      "Product": {
        "Id": _idController.text,
        "ProductType": 1, // mặc định hàng hóa
        "Price": double.tryParse(_priceController.text) ?? 0,
        "Code": code,
        "Name": _nameController.text,
        "Unit": "Cái", // hoặc _unitController nếu có
        "CategoryId": int.tryParse(_categoryIdController.text) ?? 0,
      },
      "OnHand": 0,
      "Cost": double.tryParse(_priceController.text) ?? 0,
    };

    try {
      final result = await saveProduct(sessionId, body);
      Navigator.pop(context, result); // trả result về
      print("✅ Lưu thành công: $result");
    } catch (e) {
      print("❌ Lỗi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Update Product")),
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
                decoration: _inputDecoration("Tên sản phẩm"),
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
                controller: _priceController,
                decoration: _inputDecoration("Giá"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Giá không được để trống";
                  }
                  if (double.tryParse(value) == null) {
                    return "Giá phải là số";
                  }
                  if (double.tryParse(value)! <= 0) {
                    return "Giá phải lớn hơn 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Id
              TextFormField(
                controller: _categoryIdController,
                decoration: _inputDecoration("Category Id"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Category Id không được để trống";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              //Unit
              TextFormField(
                controller: _unitController,
                decoration: _inputDecoration("Unit"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Unit không được để trống";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),

              // Nút Lưu
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveProduct(widget.sessionId);
                    // ✅ Tất cả field hợp lệ
                    print("Form OK, submit data...");
                    print("Code: ${_codeController.text}");
                    print("Name: ${_nameController.text}");
                    print("Price: ${_priceController.text}");
                    print("CategoryId: ${_categoryIdController.text}");
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
