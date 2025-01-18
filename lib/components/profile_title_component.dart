import 'package:flutter/material.dart';


class ProfileTitleComponent extends StatelessWidget {
  final String title;

  const ProfileTitleComponent({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    );
  }
}
