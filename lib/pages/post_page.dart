import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:userapp/components/custom_text_field.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController captionController = TextEditingController();
  File? _selectedImg;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User get user => _auth.currentUser!;

  Future<void> pickImageFromGallery() async {
    final selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    
    if (selectedImage != null) {
      setState(() {
        _selectedImg = File(selectedImage.path);
      });
    }
  }

  Future<void> submitPost() async {
    if (_selectedImg == null || captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione uma imagem e adicione uma legenda.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (user != null) {
        final storageRef = _storage.ref().child('post_images/${DateTime.now().toIso8601String()}');
        await storageRef.putFile(_selectedImg!);
        final imageUrl = await storageRef.getDownloadURL();

        await _firestore.collection('posts').add({
          'userId': user.uid,
          'username': user.displayName ?? 'Anonymous',
          'image_url': imageUrl,
          'caption': captionController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        GoRouter.of(context).go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao postar: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/bar_state');
          },
        ),
        backgroundColor: const Color.fromARGB(255, 3, 32, 106),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: pickImageFromGallery,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: _selectedImg == null
                        ? Center(child: Image.asset('assets/null.png', fit: BoxFit.cover))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Image.file(_selectedImg!, fit: BoxFit.cover),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Descreva a postagem:"),
                ),
                CustomTextField(controller: captionController),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submitPost,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Postar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Digite a legenda da postagem...',
      ),
      maxLines: 5,
    );
  }
}