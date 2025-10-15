import 'package:first_app/repositores/api_product.dart';
import 'package:flutter/material.dart';

class FormProduct extends StatefulWidget {
  final String sessionId;
  FormProduct({required this.sessionId});
  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các field
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
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
        "Id": 0,
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
      appBar: AppBar(title: const Text("Form Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // form key để quản lý trạng thái form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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

              // Create Date
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: _inputDecoration(
                  "Create Date",
                ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng chọn ngày";
                  }
                  if (_selectedDate != null) {
                    DateTime now = DateTime.now();
                    DateTime today = DateTime(now.year, now.month, now.day);

                    if (_selectedDate!.isBefore(today)) {
                      return "Ngày không được nằm trong quá khứ";
                    }
                    if (_selectedDate!.isAfter(today)) {
                      return "Ngày không được vượt quá hiện tại";
                    }
                  }
                  return null;
                },
              ),
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
                    print("CreateDate: ${_dateController.text}");
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
