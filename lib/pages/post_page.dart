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
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController captionController = TextEditingController();
  File? _selectedImg;
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  Future pickImageFromGallery() async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(
      () {
        if (_selectedImg != Null) {
          _selectedImg = File(selectedImage!.path);
        } else {
          return;
        }
      },
    );
  }

  Future<void> submitPost() async {
    if (_selectedImg != null && captionController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final storageRef = FirebaseStorage.instance.ref().child('post_images/${DateTime.now().toIso8601String()}');
          await storageRef.putFile(_selectedImg!);
          final imageUrl = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance.collection('posts').add({
            'userId': user.uid,
            'username': user.displayName ?? 'Anonymous',
            'image_url': imageUrl,
            'caption': captionController.text,
            'timestamp': FieldValue.serverTimestamp(),
          });

          Navigator.of(context).pop();
        }
      } catch (e) {
        // Handle error
      } finally {
        setState(() {
           isLoading = false;
        });
      }
    }
    GoRouter.of(context).go('/home');
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
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      pickImageFromGallery();
                    },
                    child: _selectedImg == null
                        ? Center(child: Image.asset('assets/null.png'))
                        : Image.file(_selectedImg!),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Descreva a postagem:"),
                ),
                CustomTextField(),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: submitPost,
                    child: Text('Submit Post'),
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
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
    );
  }
}