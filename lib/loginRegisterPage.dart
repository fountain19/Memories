import 'package:flutter/material.dart';
import 'package:memories/authentication.dart';
import 'package:memories/dialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
final AuthImplementation auth;
final VoidCallback onSignedIn;

  LoginRegisterPage({this.auth,this.onSignedIn,});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType{
  login,register
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
Dialogbox dialogbox=Dialogbox();
final formKey=GlobalKey<FormState>();
FormType _formType =FormType.login;
String _email = "";
String _password='';

//methods
  bool validateAndSave()
  {
    final form=formKey.currentState;
    if(form.validate())
      {
        form.save();
        return true;
      }else
        {return false;}
  }

  void validateAndSubmit()async
  {
    if(validateAndSave())
      {
        try
            {
              if(_formType==FormType.login){
                String userId=await widget.auth.SignIn(_email.trim(), _password.trim());
               // dialogbox.information(context, 'Congratulations','You are logged in successfully');
                print('login userId=' + userId);
              }else
                {
                  String userId=await widget.auth.SignUp(_email.trim(), _password.trim());
                  //dialogbox.information(context, 'Congratulations','Your account has been created successfully');
                  print('Register userId=' + userId);
                }
              widget.onSignedIn();
            }catch(e)
    {          dialogbox.information(context, 'Error', e.toString());
            print('Error =' + e.toString());
    }
      }
  }

  void moveToRegister()
  {
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.register;
    });
  }
  void moveToLogin()
  {
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar:  new AppBar(
         title: Center(child: Text(' Memories',style: TextStyle(
             fontWeight: FontWeight.bold,fontFamily: 'Signatra',fontSize: 45
         ),)),
          ),
      body:Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child:ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createInput() + createButtons(),
              ),
            ],
          )
        ),
      ) ,
    );
  }
  List<Widget> createInput()
  {
    return [
    SizedBox(height: 10.0,),
      logo(),
      SizedBox(height: 20.0,),
      TextFormField(
        decoration: InputDecoration(labelText:'Email'),
        validator: (value){
          return value.isEmpty?"Email is required":null;
        },
        onSaved: (value){
          return _email=value.trim();
        },
      ),
      SizedBox(height: 10.0,),
      TextFormField(
        decoration: InputDecoration(labelText:'Password'),
        obscureText: true,
        validator: (value){
          return value.isEmpty?"Password is required":null;
        },
        onSaved: (value){
          return _password=value.trim();
        },
      ),
      SizedBox(height: 20.0,),
    ];
  }
  Widget logo()
  {
    return Hero(
      tag: 'Hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110,
        child: Image.asset('images/logo.jpg'),
      ),
    );
  }
  List<Widget> createButtons()
  {
    if(_formType==FormType.login)
      {
        return  [
          RaisedButton(
              child: Text('Login',style: TextStyle(fontSize: 20.0),
              ),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: validateAndSubmit),
          FlatButton(
              child: Text('Not have an account? Create Account',style: TextStyle(fontSize: 14.0),
              ),
              textColor: Colors.pink,

              onPressed: moveToRegister),
        ];
      }else
        {
          return [
            RaisedButton(
                child: Text('Create Account',style: TextStyle(fontSize: 20.0),
                ),
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: validateAndSubmit),
            FlatButton(
                child: Text('Already have an Account? Login ',style: TextStyle(fontSize: 14.0),
                ),
                textColor: Colors.pink,

                onPressed: moveToLogin),
          ];
        }
  }
}
