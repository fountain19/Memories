

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  final formKey= GlobalKey<FormState>();
  String _myValue;

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
              TextFormField(decoration: InputDecoration(labelText: 'Description'),
                validator: (value)
                {
                  return value.isEmpty? 'Description is required':null;
                },
                onSaved:(value){
                  return  _myValue=value;
                } ,
              ),
              SizedBox(height: 15.0,),
              RaisedButton(
                elevation: 10.0,
                child: Text('Add post'),
                textColor: Colors.white,
                color: Colors.pink,
                onPressed: validateAndSave,
              )
            ],
          ),
        ],
      )
    ),
  );
  }
}
