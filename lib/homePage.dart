
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memories/authentication.dart';
import 'package:memories/imageView.dart';
import 'package:memories/loginRegisterPage.dart';
import 'package:memories/photoUpload.dart';
import 'package:memories/posts.dart';
import 'package:memories/provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dialogBox.dart';



class HomePage extends StatefulWidget  {

  final Auth auth;
  final VoidCallback onSignedOut;


  HomePage({this.auth,this.onSignedOut, });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

List<Posts> postsList=[];


DatabaseReference postsRef= FirebaseDatabase.instance.reference().child("Posts");




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
       DATA[individualKey]['postId']

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
      // dialogbox.information(context, 'Error', e.toString());
      dialogbox.information(context, 'Help', 'Please click the back button from the top to safely exit the program ');
      print('Error = ' + e.toString());

    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
    //automaticallyImplyLeading: false,
        title: Text('Memories',style: TextStyle(
            fontWeight: FontWeight.bold,fontFamily: 'Signatra',fontSize: 45
        ),),
        centerTitle: true,
      ),
      body: Container(
        child: postsList.length==0?Center(
          child: Text(''),
        ):ListView.builder(
        itemCount: postsList.length,
        itemBuilder: (_,index)
        {
          return postsUi(postsList[index].image,postsList[index].description,postsList[index].date,
            postsList[index].time,postsList[index].postId);
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
              IconButton(icon: Icon(Icons.login_outlined), onPressed:_logOutUser,
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

  Widget postsUi(String date,String time,String description,String image,String postId)
  {

    return GestureDetector(
      onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ImageView(time,image,description,date,postId,);
        }));
      } ,
      child: Card(
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
              Container(child: Image.network(image,fit: BoxFit.cover,)),
              SizedBox(height: 10.0,),
              Text(
                description,style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

//     storageReference.child('post_$postID.jpg').delete();


}
