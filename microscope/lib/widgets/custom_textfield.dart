import 'package:flutter/material.dart';
import 'package:microscope/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        color: Colors.white,
      ),
      controller: controller,
      decoration: const InputDecoration(
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
