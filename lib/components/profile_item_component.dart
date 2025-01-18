import 'package:flutter/material.dart';

class ProfileItemComponent extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function() onTap;

  const ProfileItemComponent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(subtitle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
