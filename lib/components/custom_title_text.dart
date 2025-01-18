import 'package:flutter/material.dart';

class CustomTitleText extends StatelessWidget {
  final String message;
  final TextStyle style;

  const CustomTitleText(
      {super.key, required this.message, required this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: style,
      textAlign: TextAlign.center,
    );
  }
}
