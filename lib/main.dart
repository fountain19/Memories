

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories/authentication.dart';

import 'package:memories/mapping.dart';
import 'package:memories/provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();


  runApp(Memories());
}



class Memories extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider(
      create: (context)=>App(),
      child: MaterialApp(
        title: 'Memory ',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: MappingPage(auth: Auth(),),


      ),
    );
  }
}
