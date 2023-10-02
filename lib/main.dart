import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notekeep/firebase_options.dart';
import 'package:notekeep/views/login_view.dart';
import 'package:notekeep/views/register_view.dart';
import 'package:notekeep/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

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
        '/register/': (context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
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
                //print('Email is verified');
                return const NotesView();
              } else {
                devtools.log('Email is not verified');
                devtools.log(user.toString());
                // print('Email is not verified');
                // print(user);
                return const VerifyEmailView();

                // Debugging For Stuck Emailverified issue (refresh user)
                // FirebaseAuth.instance.currentUser!.reload();
                // FirebaseAuth.instance.signOut();
                // return const LoginView();
              }
            } else{
              return const LoginView();
            } 
            //return const Text('Done');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction{
  logout
}

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              //devtools.log(value.toString());
              switch (value){
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if(shouldLogout){
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/login/', (_) => false,);
                  }
                  // devtools.log(shouldLogout.toString());
                  // break;
              }
            }, 
            itemBuilder: (context){
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout, 
                child: Text('Log Out'), 
              ),
            ];
          },)
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            }, 
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
            }, 
            child: const Text('Log Out'),
          ),
        ],
      );
    }
  ).then((value) => value ?? false );
}