import 'package:flutter/material.dart';

//text box
class CustomTextBox extends StatefulWidget {
  const CustomTextBox(
      {super.key,
      required this.controller,
      required this.labelText,
      this.validator,
      this.prefixIcon,
      this.keyboardType});
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;

  @override
  State<CustomTextBox> createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      validator: widget.validator,
      keyboardType: widget.keyboardType,
    );
  }
}