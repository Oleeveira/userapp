import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:userapp/components/custom_text_field.dart';
import 'package:userapp/resources/constant_colors.dart';
import 'package:userapp/services/firebase_auth_methods.dart';

class InstitutionRegisterPage extends StatefulWidget {
  @override
  _InstitutionRegisterPage createState() => _InstitutionRegisterPage();
}

class _InstitutionRegisterPage extends State<InstitutionRegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FirebaseAuthMethods authMethods =
        FirebaseAuthMethods(FirebaseAuth.instance);

    User? user = await authMethods.registerNewUser(
      emailController.text.trim(),
      passwordController.text,
      context,
    );

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': nameController.text,
        'address': addressController.text,
        'number': phoneController.text,
        'image': '',
        'createdOn': DateTime.now(),
      });

      GoRouter.of(context).go('/bar_state');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 214, 212, 212),
                ConstantsColors.CorPrinciapal,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.6, 1.0],
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldWithLabel(
                      'Nome: ', TextInputType.text, nameController),
                  const SizedBox(height: 20),
                  _buildTextFieldWithLabel(
                      'Telefone: ', TextInputType.phone, phoneController),
                  const SizedBox(height: 20),
                  _buildTextFieldWithLabel(
                      'E-mail: ', TextInputType.emailAddress, emailController),
                  const SizedBox(height: 20),
                  _buildTextFieldWithLabel(
                      'Endereço: ', TextInputType.text, addressController),
                  const SizedBox(height: 20),
                  _buildTextFieldWithLabel(
                    'Senha: ',
                    TextInputType.text,
                    passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 60,
                      width: double.infinity, // Full width button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstantsColors.CorPrinciapal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: registerUser,
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
      String label, TextInputType inputType, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
          keyboardType: inputType,
          obscureText: isPassword,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: isPassword
                ? IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}