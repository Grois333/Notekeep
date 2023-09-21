import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notekeep/firebase_options.dart';
import 'package:notekeep/views/login_view.dart';
import 'package:notekeep/views/register_view.dart';
import 'package:notekeep/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView()
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.done:
            //print(FirebaseAuth.instance.currentUser);
            final user = FirebaseAuth.instance.currentUser;
            if(user != null){
              if(user.emailVerified){
                print('Email is verified');
              } else {
                print('Email is not verified');
                print(user);
                return const VerifyEmailView();
              }
            } else{
              return const LoginView();
            } 
            return const Text('Done');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}