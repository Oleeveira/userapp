import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:userapp/components/custom_text_field.dart';
import 'package:userapp/resources/constant_colors.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
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
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()?['name'] ?? '';
          email = snapshot.data()?['email'] ?? '';
          image = snapshot.data()?['userImage'] ?? '';
          number = snapshot.data()?['phoneNumber'] ?? '';
          address = snapshot.data()?['address'] ?? '';

          nameController.text = name ?? '';
          emailController.text = email ?? '';
          phoneController.text = number ?? '';
          addressController.text = address ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados do perfil.')));
    }
  }

  Future pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageXFile = File(pickedFile.path);
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    if (imageXFile == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${currentUser.uid}.jpg');
      uploadTask = ref.putFile(imageXFile!);

      final snapshot = await uploadTask!.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with new image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'userImage': downloadUrl,
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Imagem atualizada!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar imagem: $e')));
    }
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).go('/bar_state');
            },
          ),
          title: const Text('Editar Perfil'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
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
                const SizedBox(height: 20),
                _buildTextFieldWithLabel(
                    'Nome', TextInputType.text, nameController),
                const SizedBox(height: 15),
                _buildTextFieldWithLabel(
                    'Email', TextInputType.emailAddress, emailController),
                const SizedBox(height: 15),
                _buildTextFieldWithLabel(
                    'Telefone', TextInputType.phone, phoneController),
                const SizedBox(height: 15),
                _buildTextFieldWithLabel(
                    'Endereço', TextInputType.text, addressController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveProfile,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'name': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneController.text,
        'address': addressController.text,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Perfil atualizado!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar perfil: $e')));
    }
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
}
