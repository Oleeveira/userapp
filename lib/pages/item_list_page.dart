import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:userapp/components/item_card_component.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .doc(user?.uid)
            .collection('user_items')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final itemId = item.id;
              final itemData = item.data() as Map<String, dynamic>;

              return ItemCardComponent(
                itemName: itemData['name'] ?? 'No Name',
                itemDescription: itemData['description'] ?? 'No Description',
                itemQuantity: itemData['qtd'] ?? 0,
                itemCategory: itemData['category'] ?? 'No Category',
              );
            },
          );
        },
      ),
    );
  }
}