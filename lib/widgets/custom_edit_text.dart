import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomEditText extends StatelessWidget{

  final String hiddenText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final int maxLength;
  final TextInputType textInputType;
  bool obscureText;

  CustomEditText({
    @required this.controller,
    @required this.validator,
    @required this.maxLength,
    this.hiddenText,
    this.textInputType,
    this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText?? false,
      keyboardType: textInputType ?? TextInputType.text,
      maxLength: this.maxLength,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          hintText: hiddenText?? "Ingresa la información",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey, width: 2.0)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.green.shade800, width: 2.0)
          )
      ),
    );
  }
}