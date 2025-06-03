import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.darkOrange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24)),
      child: Text(
        text,
        style: const TextStyle(
          color: CustomColor.cream,
          fontSize: 18,
        ),
      ),
    );
  }
}
