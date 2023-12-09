import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:msg_app/screens/chat_screen.dart';
import 'package:msg_app/screens/registeration_screen.dart';
import 'package:msg_app/screens/signin_screen.dart';
import 'package:msg_app/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MessageMe app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        primarySwatch: Colors.blue,

        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),

          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),

        useMaterial3: true,
      ),

      initialRoute: WelcomeScreen.scrrenRoute,

      routes: {
        WelcomeScreen.scrrenRoute:(context) => const WelcomeScreen(),
        SignInScreen.screenRoute:(context) => const SignInScreen(),
        RegistrationScreen.screenRoute:(context) => const RegistrationScreen(),
        ChatScrren.screenRoute:(context) => const ChatScrren(),


      },


    );
  }
}