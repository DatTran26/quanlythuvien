// Ô nhập số tiền VND: chỉ nhận chữ số, cho phép gõ "40.000" (dấu chấm bị bỏ khi đọc).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// "40.000" -> 40000; rỗng hoặc sai -> null.
int? parseVnd(String text) =>
    int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), ''));

class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.helperText,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(int? value)? validator;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: 'đ',
        helperText: helperText,
      ),
      validator: validator == null
          ? null
          : (text) => validator!(parseVnd(text ?? '')),
    );
  }
}
