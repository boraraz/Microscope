import 'package:flutter/material.dart';
import 'package:microscope/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onTap;
  final bool? isPassword;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.onTap,
    this.isPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword ?? false,
      onSubmitted: onTap,
      style: const TextStyle(
        color: Colors.black,
      ),
      controller: controller,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color.fromRGBO(233, 233, 233, 50),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: buttonColor,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: textFieldBorder,
            width: 2,
          ),
        ),
      ),
    );
  }
}
