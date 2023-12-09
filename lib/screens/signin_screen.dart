import 'package:flutter/material.dart';
import 'package:msg_app/screens/chat_screen.dart';

import '../widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String screenRoute='signin_screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showSpinner=false;
  final _auth=FirebaseAuth.instance;
  late String email ;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Change spinner color here
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
              MyButton(color: Colors.yellow[900]!, title: 'Sign in', onPressed: ()async{
                try{
                  setState(() {
                    showSpinner=true;
                  });
                 final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                 if(_auth.currentUser!=null){
                   Navigator.pushNamed(context, ChatScrren.screenRoute);
                   setState(() {
                     showSpinner=false;
                   });
                 }
                }catch(e)
                {
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
