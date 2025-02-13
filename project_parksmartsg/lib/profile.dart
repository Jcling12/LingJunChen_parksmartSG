import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_parksmartsg/authenticate.dart';
import 'package:project_parksmartsg/login.dart';

final authentication = AuthService();
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore database = FirebaseFirestore.instance;
Map<String, dynamic>? userData;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController =
      TextEditingController(text: '${userData?['name']}');
  TextEditingController passwordController =
      TextEditingController(text: '${userData?['password']}');
  TextEditingController emailController =
      TextEditingController(text: '${userData?['email']}');
  TextEditingController phoneController =
      TextEditingController(text: '${userData?['phone']}');

  bool nameValid = true;
  bool passwordValid = true;
  bool emailValid = true;
  bool phoneValid = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await database.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
        });
      } else {
        log("No user data found.");
      }
    }
  }

  updateProfile(BuildContext context) async {
    setState(() {
      nameController.text.trim().length < 3 || nameController.text.isEmpty
          ? nameValid = false
          : nameValid = true;

      passwordController.text.trim().length < 3 ||
              passwordController.text.isEmpty
          ? passwordValid = false
          : passwordValid = true;

      !emailController.text.contains("@") ||
              !emailController.text.contains(".") ||
              emailController.text.isEmpty
          ? emailValid = false
          : emailValid = true;

      phoneController.text.trim().length > 8 || nameController.text.isEmpty
          ? phoneValid = false
          : phoneValid = true;
    });

    if (nameValid && passwordValid && emailValid && phoneValid) {
      User? user = auth.currentUser;
      //user?.verifyBeforeUpdateEmail(emailController.text);
      user?.updatePassword(passwordController.text);
      await database.collection('users').doc(user?.uid).update({
        'name': nameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'phone': phoneController.text
      }).catchError((error) => log("Failed to update user: $error"));
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Account Updated'),
              content:
                  const Text('Please login again to see your updated changes.'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await authentication.logoutUser();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    child: const Text("Logout"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundColor: Colors.black,
              radius: 62,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('images/james-goh.jpg'),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${userData?['name']}',
              style: const TextStyle(fontSize: 22, fontFamily: 'Gilroy-Bold'),
            ),
            const SizedBox(height: 5),
            const Text(
              'Personal Info',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilroy-Bold',
                color: Color.fromARGB(255, 15, 103, 253),
              ),
            ),
            const SizedBox(height: 5),
            PersonalInfoRow(
              label: 'Username',
              controllerName: nameController,
              valid: nameValid,
              errorMsg: "Username too short",
            ),
            PersonalInfoRow(
              label: 'Password',
              controllerName: passwordController,
              valid: passwordValid,
              errorMsg: "Password too short",
            ),
            PersonalInfoRow(
                label: 'Email Address',
                controllerName: emailController,
                valid: emailValid,
                errorMsg: "Invalid/Empty email"),
            PersonalInfoRow(
              label: 'Contact No.',
              controllerName: phoneController,
              valid: phoneValid,
              errorMsg: "Phone number must be 8 numeric characters",
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                updateProfile(context);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
                backgroundColor: const Color.fromARGB(255, 15, 103, 253),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Gilroy-Bold',
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () async {
                await authentication.logoutUser();
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text(
                            'Successfully logout. Redirecting to login page.'),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                await authentication.logoutUser();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              },
                              child: const Text("Logout"))
                        ],
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Gilroy-Bold',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalInfoRow extends StatefulWidget {
  final String label;
  final TextEditingController controllerName;
  final bool valid;
  final String errorMsg;
  const PersonalInfoRow(
      {super.key,
      required this.label,
      required this.controllerName,
      required this.valid,
      required this.errorMsg});

  @override
  State<PersonalInfoRow> createState() => _PersonalInfoRowState();
}

class _PersonalInfoRowState extends State<PersonalInfoRow> {
  bool isEnable = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Gilroy-Bold',
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      !isEnable ? Icons.edit : Icons.cancel,
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isEnable == false) {
                          isEnable = true;
                        } else {
                          isEnable = false;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: widget.controllerName,
                      enabled: isEnable,
                      decoration: InputDecoration(
                          errorText: widget.valid ? null : widget.errorMsg),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
