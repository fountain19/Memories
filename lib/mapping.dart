import 'package:flutter/material.dart';
import 'package:memories/authentication.dart';
import 'package:memories/homePage.dart';
import 'package:memories/loginRegisterPage.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;
  MappingPage({this.auth});

  @override
  _MappingPageState createState() => _MappingPageState();
}
enum AuthStatus{
notSignIn,
  signedIn
}

class _MappingPageState extends State<MappingPage> {
String userId;
  AuthStatus authStatus=AuthStatus.notSignIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((fireBaseUserId){
      setState(() {
        authStatus=fireBaseUserId==null?AuthStatus.notSignIn:AuthStatus.signedIn;
      });
    }
    );
  }
  void _signedIn()
  {
    setState(() {
      authStatus=AuthStatus.signedIn;
    });
  }
  void _signOut()
  {
    setState(() {
      authStatus=AuthStatus.notSignIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.notSignIn:
        return LoginRegisterPage(auth: widget.auth,onSignedIn:_signedIn ,);
      case AuthStatus.signedIn:
        return HomePage(auth: widget.auth,onSignedOut:_signOut,);

    }

  }
}
