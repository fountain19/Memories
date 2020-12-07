
import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memories/homePage.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;
  File sampleImage;
  final formKey= GlobalKey<FormState>();
  String _myValue;
  String url;

  Future getImage()async
  {
    var tempImage= await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage=tempImage;
    });
  }

  bool validateAndSave()
  {
    final form=formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else
      {
        return false;
      }
  }

  void uploadStatusImage() async
  {
    if(validateAndSave())
      {
     final StorageReference postImageRef = FirebaseStorage.instance
            .ref()
            .child('Post Images');
     var timeKey = DateTime.now();
     final StorageUploadTask uploadTask=postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

     var imageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();
     url=imageUrl.toString();
     print('Image url =' + url);
     goToHomePage();
     saveToDataBase(url);
      }
  }

  void saveToDataBase(url)
  {
    var dbTimeKey = DateTime.now();
    var formatDate= DateFormat('MMM d,yyyy');
    var formatTime= DateFormat('EEEE, hh:mm aaa');
    String date= formatDate.format(dbTimeKey);
    String time= formatTime.format(dbTimeKey);
    DatabaseReference ref= FirebaseDatabase.instance.reference();
    var data=
        {
          'image':url,
          'description':_myValue,
          'date':date,
          'time':time
        };
    ref.child('Posts').push().set(data);
  }

  void goToHomePage()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload image'),
        centerTitle: true,
      ),
      body: sampleImage== null?Center(child: Text('Select an image',style: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold
      ),)):enableUpload(),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "Add image",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
  Widget enableUpload(){
  return Container(
    child: Form(
      key: formKey,
      child: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 15.0,),
              Image.file(sampleImage,height: 330,width: 660,),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(decoration: InputDecoration(labelText: 'Description'),
                  validator: (value)
                  {
                    return value.isEmpty? 'Description is required':null;
                  },
                  onSaved:(value){
                    return  _myValue=value;
                  } ,
                ),
              ),
              SizedBox(height: 15.0,),
              RaisedButton(
                elevation: 10.0,
                child: Text('Add post'),
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: uploadStatusImage,
              )
            ],
          ),
        ],
      )
    ),
  );
  }
}
