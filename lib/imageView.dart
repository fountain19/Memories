import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memories/homePage.dart';

import 'authentication.dart';


class ImageView extends StatefulWidget {

  final String date;
  final String time;
  final String description;
  final String image;
  final String postId;
  ImageView(this.time,this.image,this.description,this.date, this.postId, );
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  DatabaseReference postsRef= FirebaseDatabase.instance.reference().child("Posts");
  final StorageReference postImageRef = FirebaseStorage.instance
      .ref()
      .child('Post Images');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete the  image'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: (){

          postsRef.child(widget.postId).remove();
          postImageRef.child(widget.postId + ".jpg" ).delete();
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return HomePage();
          }));
// Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context){
//   return HomePage();
// }), (route) => false);

          })
        ],
      ),
      body: Card(
        elevation: 10.0,
        margin: EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.date,style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.time,style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ],),
                SizedBox(height: 10.0,),
                Container(child: Image.network(widget.image,fit: BoxFit.cover,)),
                SizedBox(height: 10.0,),
                Text(
                  widget.description,style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
