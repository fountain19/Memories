import 'package:flutter/material.dart';
import 'package:memories/authentication.dart';
import 'package:memories/photoUpload.dart';

import 'dialogBox.dart';


class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  HomePage({this.auth,this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Dialogbox dialogbox=Dialogbox();

  void _logOutUser()async{
    try {
      await widget.auth.SignOut();
      widget.onSignedOut();
    }catch(e){
      dialogbox.information(context, 'Error', e.toString());
      print('Error = ' + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Container(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(
          margin: EdgeInsets.only(left: 70.0,right: 70.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(icon: Icon(Icons.local_car_wash), onPressed:_logOutUser,
              color: Colors.white,iconSize: 50.0,),
              IconButton(icon: Icon(Icons.add_a_photo),
                color: Colors.white,iconSize: 50.0,
              onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context){
                return UploadPhotoPage();
              })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
