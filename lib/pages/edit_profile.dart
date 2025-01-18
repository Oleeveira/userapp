import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:userapp/components/custom_text_field.dart';
import 'package:userapp/resources/constant_colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  String? name = '';
  String? email = '';
  String? number = '';
  String? image = '';
  String? address = '';
  File? imageXFile;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()?['name'] ?? '';
          email = snapshot.data()?['email'] ?? '';
          image = snapshot.data()?['userImage'] ?? '';
          number = snapshot.data()?['phoneNumber'] ?? '';
          address = snapshot.data()?['address'] ?? '';
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/bar_state');
          },
        ),),
      body: Row(children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 3.0),
          child: Material(
            child: Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: imageXFile == null
                    ? (image != null
                        ? NetworkImage(image!)
                        : const AssetImage('assets/default_profile.jpg')
                            as ImageProvider)
                    : Image.file(imageXFile!).image,
              ),
            ),
          ),
        ),
        Column(
          children: [
            _buildTextFieldWithLabel(
                'Nome', TextInputType.text, nameController),
            _buildTextFieldWithLabel(
                'Email', TextInputType.emailAddress, emailController),
            _buildTextFieldWithLabel(
                'Telefone', TextInputType.phone, phoneController),
            _buildTextFieldWithLabel(
                'Endereço', TextInputType.text, addressController),
          ],
        ),
      ]),
    ));
  }
}

TextStyle textStyle(double size, FontWeight weight) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
  );
}

Widget _buildTextFieldWithLabel(
    String label, TextInputType inputType, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: ConstantsColors.CorPrinciapal,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomTextField(
          type: inputType,
          controller: controller,
        ),
      ],
    ),
  );
}
