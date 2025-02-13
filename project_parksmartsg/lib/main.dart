import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_parksmartsg/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Initialise firebase
  await Firebase.initializeApp(
     options: const FirebaseOptions(
      apiKey: "AIzaSyAjc3eSw8dv7eu4mph-_R6nxU56KeJJUPM",
      appId: "1:918997788290:android:1a3a623fa054249d37f69b",
      messagingSenderId: "918997788290",
      projectId: "parksmartsg",
    ),
  );
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: MaterialApp(
        title: 'Project_ParkSmartSG',
        home: Login(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}