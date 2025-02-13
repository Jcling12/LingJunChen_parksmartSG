import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_parksmartsg/home.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  Future<User?> createUser(
      String name, String email, String phone, String password, context) async {
    try {
      final cred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password
      });
      goHome(context);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        error(context, "Email already exists");
      } else if (e.code == "invalid-email") {
        error(context, "Email format incorrect");
      }
       else {
        error(context, "An error occurred: ${e.code}");
      }
    }
    return null;
  }

  Future<User?> loginUser(String email, String password, context) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      goHome(context);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.  code == "user-not-found" || e.code == "wrong-password" || e.code == "invalid-credential") {
        error(context, "Invalid email or password");
      } else {
        error(context, "An error occurred: ${e.code}");
      }
    }
    return null;
  }

  Future<User?> logoutUser() async {
    try {
      await auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  error(context, string) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(string),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  goHome(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const HomePage()));
}
