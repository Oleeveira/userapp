import "dart:core";

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:userapp/utils/show_snackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

 User? get user => _auth.currentUser; 
  
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  

  Future<User?> registerNewUser(String email, String password, BuildContext context) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'Usuário não encontrado.';
        break;
      case 'wrong-password':
        message = 'Senha incorreta.';
        break;
      case 'invalid-email':
        message = 'E-mail inválido.';
        break;
      case 'user-disabled':
        message = 'Usuário desabilitado.';
        break;
      default:
        message = 'Um erro ocorreu.';
    }
    showSnackBar(context, message);
    return null; // ✅ Return null when an error occurs
  }
}

  Future<void> loginWithEmail({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    showSnackBar(context, e.message ?? 'Erro ao fazer login'); // ✅ Safe fallback
  }
}

  Future<void> signOut(BuildContext context) async {
  if (_auth.currentUser != null) { // ✅ Check if user is signed in
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Erro ao sair'); // ✅ Safe fallback
    }
  }
}

 Future<void> deleteAccount(BuildContext context) async {
  try {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      showSnackBar(context, 'Nenhum usuário autenticado.');
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      showSnackBar(context, 'Reautentique-se antes de excluir a conta.');
    } else {
      showSnackBar(context, e.message ?? 'Erro ao excluir a conta.');
    }
  }
}
}

