import 'package:flutter/material.dart';

class RoundIconButtonComponent extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;

  const RoundIconButtonComponent({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 20),
    );
  }
}