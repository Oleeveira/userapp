import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final bool textarea;

  const CustomTextField({
    super.key,
    required this.type,
    required this.controller,
    this.textarea = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: Colors.transparent,
              child: Expanded(
                child: TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite aqui';
                    }
                    return null;
                  },
                  keyboardType: type,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 243, 243, 243),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
        ],
      ),
    );
  }
}