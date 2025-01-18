import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerNewItem({
  required String name,
  required String quantity,
  required String category,
  required String description,
}) async {
  User? user = _auth.currentUser;
  if (user != null) {
    String userId = user.uid;

    DocumentReference docRef = _firestore
        .collection('items')
        .doc(userId)
        .collection('user_items')
        .doc();

    await docRef.set({
      'name': name,
      'quantity': quantity, 
      'category': category,
      'description': description, 
      'timestamp': FieldValue.serverTimestamp(),
    });
  } else {
    throw Exception("Usuário não autenticado");
  }
}
}