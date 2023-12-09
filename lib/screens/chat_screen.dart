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

      // void getMessages() async{
      //  final messages= await _firestore.collection('messages').get();
      //  for(var message in messages.docs){
      //    print(message.data());
      //  }
      // }


      void messagesStreams() async{

       await  for (var snapshot in _firestore.collection('messages').snapshots()){
         for (var message in snapshot.docs){
           print(message.data());
         }
       }
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
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot){
                  List<MessageLine> messageWidgets=[];
                  if(!snapshot.hasData){
                    //add here a spinner
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }

                  final messages=snapshot.data!.docs;
                  for(var message in messages){
                    final messageText=message.get('text');
                    final messageSender=message.get('sender');
                    final messageWidget=MessageLine(sender: messageSender,text: messageText);
                    messageWidgets.add(messageWidget);
                  }
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      children: messageWidgets,

                    ),
                  );
                },
            ),
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


class MessageLine extends StatelessWidget {
  final String sender;
  final String text;

  const MessageLine({super.key, required this.sender, required this.text});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Material(

        color: Colors.blue[800],
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Text(
              '$text - $sender',
              style: TextStyle(fontSize: 15.0,color: Colors.white),
            ),
          ),
      ),
    );
  }
}
