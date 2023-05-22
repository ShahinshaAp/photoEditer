import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final VoidCallback? onTap;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Color? color;
  final bool? fillColor;
  final bool? obscureText;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.maxLines,
    required this.controller,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.color,
    this.fillColor, this.obscureText,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: Color.fromRGBO(230, 230, 230, 1)),
    );
    return InkWell(
      onTap: () {
        // Unfocus the text field when the user taps outside of it
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      },
      child: TextFormField(
        obscureText: widget.obscureText == true ? true : false,
        inputFormatters: [LengthLimitingTextInputFormatter(280)],
        style: TextStyle(color: widget.color),
        readOnly: widget.readOnly == true ? true : false,
        onTap: widget.onTap,
        controller: widget.controller,
        maxLines: widget.maxLines,
        focusNode: _focusNode,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          focusedBorder: border,
          enabledBorder: border,
          border: border,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: widget.fillColor == true
              ? const Color.fromRGBO(152, 160, 164, 0.25)
              : Colors.white,
        ),
      ),
    );
  }
}
