import 'package:flutter/material.dart';

Widget buildInputField(
    {required String label,
    required String hintText,
    String? iniVal,
    bool? obscureText,
    TextInputType? keyboardType,
    TextEditingController? controller,
    String? Function(String?)? validator,
    Function(String)? onChanged}) {
  return TextFormField(
    initialValue: iniVal,
    controller: controller,
    obscureText: obscureText ?? false,
    onChanged: onChanged,
    keyboardType: keyboardType ?? TextInputType.text,
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      hintText: hintText,
      labelText: label, // The label text on the border
      labelStyle: const TextStyle(
        color: Color(0xff1E1E1E),
      ), // Label color
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xff086CB4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xff086CB4), width: 2),
      ),
    ),
  );
}
