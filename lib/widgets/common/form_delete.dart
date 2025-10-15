import 'package:flutter/material.dart';

Future<void> showConfirmDeleteDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
  String title = "Xác nhận xoá",
  String content = "Bạn có chắc chắn muốn xoá mục này không?",
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // không cho bấm ra ngoài để đóng
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text("Huỷ"),
            onPressed: () {
              Navigator.of(context).pop(); // đóng dialog
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Xoá"),
            onPressed: () {
              Navigator.of(context).pop(); // đóng dialog
              onConfirm(); // chạy callback xoá
            },
          ),
        ],
      );
    },
  );
}

void showTopSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      duration: const Duration(seconds: 2),
    ),
  );
}
