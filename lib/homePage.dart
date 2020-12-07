import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:memories/authentication.dart';
import 'package:memories/photoUpload.dart';
import 'package:memories/posts.dart';

import 'dialogBox.dart';


class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  HomePage({this.auth,this.onSignedOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

List<Posts> postsList=[];


@override
  void initState() {
 super.initState();
 DatabaseReference postsRef= FirebaseDatabase.instance.reference().child("Posts");
 postsRef.once().then((DataSnapshot snap)
 {
   var KEYS=snap.value.keys;
   var DATA=snap.value;
   postsList.clear();
   for(var  individualKey in KEYS) {
     Posts posts = Posts(
       DATA[individualKey]['image'],
       DATA[individualKey]['description'],
       DATA[individualKey]['date'],
       DATA[individualKey]['time'],
     );
     postsList.add(posts);
   }
   setState(() {
     print('Length:' + postsList.length.toString());
   });
 });
  }

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
      body: Container(
        child: postsList.length==0?Center(child: Text('no post yet',style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold
        ),)):ListView.builder(
        itemCount: postsList.length,
        itemBuilder: (_,index)
        {
          return postsUi(postsList[index].image,postsList[index].description,postsList[index].date,
            postsList[index].time,);
        }),
      ),
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
  Widget postsUi(String date,String time,String description,String image)
  {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
             Text(
               date,style: Theme.of(context).textTheme.subtitle1,
               textAlign: TextAlign.center,
             ),
             Text(
               time,style: Theme.of(context).textTheme.subtitle1,
               textAlign: TextAlign.center,
             ),
           ],),
            SizedBox(height: 10.0,),
            Image.network(image,fit: BoxFit.cover,),
            SizedBox(height: 10.0,),
            Text(
              description,style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
