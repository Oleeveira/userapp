
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:userapp/components/gallery_state.dart';
import 'package:userapp/components/item_card_component.dart';
import 'package:userapp/pages/edit_profile.dart';

class OtherEntitiesProfilePage extends StatefulWidget {
  final String userId;

  const OtherEntitiesProfilePage({super.key, required this.userId});

  @override
  State<OtherEntitiesProfilePage> createState() => _OtherEntitiesProfilePageState();
}

class _OtherEntitiesProfilePageState extends State<OtherEntitiesProfilePage> {
  String? username = '';
  String? email = '';
  String? number = '';
  String? image = '';
  String? address = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      setState(() {
        username = userData['username'] ?? 'Anonymous';
        email = userData['email'] ?? 'Not Available';
        number = userData['number'] ?? 'Not Available';
        image = userData['image'] ?? '';
        address = userData['address'] ?? 'Not Available';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar dados do perfil.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(child: const CircularProgressIndicator())
            : SizedBox.expand(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0, top: 3.0),
                                  child: Material(
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 50.0,
                                        backgroundImage: image != null
                                            ? NetworkImage(image!)
                                            : const AssetImage('assets/default_profile.jpg') as ImageProvider,
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
                                        const Icon(Icons.phone_in_talk_outlined),
                                        Opacity(
                                          opacity: 0.7,
                                          child: Text(
                                            "$number",
                                            style: textStyle(14, FontWeight.normal),
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
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('items')
                                  .where('userId', isEqualTo: widget.userId)
                                  .limit(3)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final items = snapshot.data!.docs;
                                return Column(
                                  children: items.map((item) {
                                    return ItemCardComponent(
                                      itemName: item['name'],
                                      itemDescription: item['description'],
                                      itemQuantity: item['quantity'],
                                      itemCategory: item['category'],
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
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 500, child: Gallery(userId: widget.userId)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

TextStyle textStyle(double size, FontWeight weight) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
  );
}