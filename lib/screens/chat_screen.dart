import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatScrren extends StatefulWidget {
  const ChatScrren({super.key});

  static const String screenRoute ='chat_screen';

  @override
  State<ChatScrren> createState() => _ChatScrrenState();
}

class _ChatScrrenState extends State<ChatScrren> {
  final _firestore=FirebaseFirestore.instance;
  String? messageText;
  final _auth =FirebaseAuth.instance;
  late User signInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    print(signInUser.email);
  }


  void getCurrentUser(){
    try{
      final user=_auth.currentUser;
      if(user!=null){
        signInUser=user;
      }

    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/logo.png',height: 25,),
            SizedBox(width: 10,),
            Text('MessageMe')
          ],
        ),

        actions: [
          IconButton(
              onPressed: (){
                //add here logout function
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
        ],

      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(),
            Container(

              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                        onChanged: (value){
                          messageText=value;
                        },

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          hintText: 'Write your message here ...',
                          border: InputBorder.none,
                        ),

                      ),
                  ),
                  TextButton(onPressed: (){
                   _firestore.collection('messages').add({
                     'text':messageText,
                     'sender':signInUser.email,
                   });
                  }, child: Text(
                    'send',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),)
                ],
              ),


            )
          ],
        ),
      ),


    );
  }
}
