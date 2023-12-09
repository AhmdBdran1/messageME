import 'package:flutter/material.dart';
import 'package:msg_app/screens/chat_screen.dart';
import 'package:msg_app/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static const String screenRoute ='registeration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange), // Change spinner color here
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
              height: 180,
              child: Image.asset('images/logo.png'),
              ),

              SizedBox(height: 50,),

              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value){
                  email=value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange,
                    width: 1,),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue,
                      width: 2,),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),

              SizedBox(height: 8,),

              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value){
                  password=value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange,
                      width: 1,),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue,
                      width: 2,),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              MyButton(color: Colors.blue[800]!, title: 'register', onPressed: ()async{
                setState(() {
                  showSpinner=true;
                });
             try{
               final newUser= await _auth.createUserWithEmailAndPassword(email: email, password: password);
               Navigator.pushNamed(context, ChatScrren.screenRoute);
               setState(() {
                 showSpinner=false;
               });
             }catch(e){
               print(e);
               setState(() {
                 showSpinner=false;
               });
             }


              }),


            ],
          ),
        ),
      ),

    );
  }
}
