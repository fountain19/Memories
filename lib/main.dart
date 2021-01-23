import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memories/authentication.dart';
import 'package:memories/mapping.dart';

void main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(Memories());
}

class Memories extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MappingPage(auth: Auth(),),
    );
  }
}
