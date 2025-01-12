import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static show({
    required TextEditingController controller,
    required void Function()? onPressed,
    String? title,
    String? textOk,
    String? textCancel,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(title ?? 'Input Todo'),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text(textOk ?? 'Save'),
          ),
        ],
      ),
    );
  }
}
