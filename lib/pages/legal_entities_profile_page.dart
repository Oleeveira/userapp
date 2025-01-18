import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:userapp/components/gallery_state.dart';
import 'package:userapp/components/item_card_component.dart';

class LegalEntitiesProfilePage extends StatefulWidget {
  const LegalEntitiesProfilePage({super.key});

  @override
  State<LegalEntitiesProfilePage> createState() =>
      LegalEntitiesProfilePageState();
}

class LegalEntitiesProfilePageState extends State<LegalEntitiesProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User get user => _auth.currentUser!;

  @override
  void initState() {
    super.initState();
    getData();
  }

  String? username = '';
  String? number = '';
  String? image = '';
  String? address = '';
  File? imageXFile;
  bool isLoading = true;

  TextStyle textStyle(double fontSize, FontWeight fontWeight) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: 'Poppins',
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> uploadFile() async {
    if (pickedFile == null || _auth.currentUser == null) return;

    try {
      final path =
          'userProfilePictures/${_auth.currentUser!.uid}/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);

      setState(() {
        uploadTask = ref.putFile(file);
      });

      final taskSnapshot = await uploadTask!.whenComplete(() => null);
      final downloadURL = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        'image': downloadURL,
      });

      setState(() {
        image = downloadURL;
      });
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao fazer upload da imagem")),
      );
    } finally {
      setState(() {
        uploadTask = null;
      });
    }
  }

  Future<void> getData() async {
    if (_auth.currentUser != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid) // Safer access
          .get();
      setState(() {
        username = userData['username'] ?? '';
        number = userData['number'] ?? '';
        image = userData['image'] ?? '';
        address = userData['address'] ?? '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                settings(context);
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SizedBox.expand(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Meu Perfil",
                                style: textStyle(32, FontWeight.w900),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, top: 3.0),
                                  child: Material(
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: (image != null &&
                                                image!.isNotEmpty)
                                            ? NetworkImage(image!)
                                                as ImageProvider<Object>
                                            : const AssetImage(
                                                    'assets/default_profile.jpg')
                                                as ImageProvider<Object>,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$username',
                                      style: textStyle(15, FontWeight.bold),
                                    ),
                                    const Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "Contato",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.phone_in_talk_outlined),
                                        Opacity(
                                          opacity: 0.7,
                                          child: Text(
                                            "$number",
                                            style: textStyle(
                                                14, FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Detalhes",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Suas Necessidades",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('items')
                                  .where('userId', isEqualTo: user.uid)
                                  .limit(3)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text("Erro ao carregar os itens"));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Center(
                                      child: Text("Nenhum item cadastrado"));
                                }

                                final items = snapshot.data!.docs;

                                return Column(
                                  children: items.map((item) {
                                    final data =
                                        item.data() as Map<String, dynamic>?;
                                    final itemName =
                                        data?['name'] ?? 'Desconhecido';
                                    final itemDescription =
                                        data?['description'] ?? '';
                                    final itemQuantity = data?['quantity'] ?? 0;
                                    final itemCategory =
                                        data?['category'] ?? '';

                                    return ItemCardComponent(
                                      itemName: itemName,
                                      itemDescription: itemDescription,
                                      itemQuantity: itemQuantity,
                                      itemCategory: itemCategory,
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.all(11.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Visitas",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 500, child: Gallery(userId: user.uid)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

void settings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Editar Perfil'),
            onTap: () {
              GoRouter.of(context).go('/edit_profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              GoRouter.of(context).go('/initial_page');
            },
          ),
        ],
      );
    },
  );
}
