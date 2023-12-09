import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late User signInUser;

final _firestore=FirebaseFirestore.instance;

class ChatScrren extends StatefulWidget {
  const ChatScrren({super.key});


  static const String screenRoute ='chat_screen';




  @override
  State<ChatScrren> createState() => _ChatScrrenState();
}



class _ChatScrrenState extends State<ChatScrren> {
  final messageTextController=TextEditingController();
  String? messageText;
  final _auth =FirebaseAuth.instance;

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
            MessageStreamBuilder(),
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
                        controller: messageTextController,
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
                    messageTextController.clear();
                    _firestore.collection('messages').add({
                     'text':messageText,
                     'sender':signInUser.email,
                      'time':FieldValue.serverTimestamp(),
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







class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot){
        List<MessageLine> messageWidgets=[];
        if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
          //add here a spinner
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            ),
          );
        }else {
          final messages=snapshot.data!.docs.reversed;
          for(var message in messages){
            final messageText=message.get('text');
            final messageSender=message.get('sender');
            final currentUser=signInUser.email;


            final messageWidget=MessageLine(
                sender: messageSender,
                text: messageText,
                isMe: currentUser==messageSender,
            );
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: messageWidgets,

            ),
          );

        }


      },
    );
  }
}








class MessageLine extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  const MessageLine({super.key, required this.sender, required this.text, required this.isMe});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,

        children:[


          Text('$sender',style: TextStyle(fontSize: 12,color:Colors.black45),),

          Material(

            borderRadius:isMe? BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ):BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ),
          elevation: 5,
          color:isMe? Colors.blue[800]:Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 15.0,color: isMe? Colors.white:Colors.black87),
              ),
            ),
        ),]
      ),
    );
  }
}
