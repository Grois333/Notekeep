// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notekeep/constants/routes.dart';
//import 'package:notekeep/firebase_options.dart';
import 'package:notekeep/services/auth/auth_service.dart';
import 'package:notekeep/views/login_view.dart';
import 'package:notekeep/views/notes/notes_view.dart';
import 'package:notekeep/views/register_view.dart';
import 'package:notekeep/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;
//import 'enums/menu_action.dart';

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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.done:
            //print(FirebaseAuth.instance.currentUser);
            final user = AuthService.firebase().currentUser;
            if(user != null){
              if(user.isEmailVerified){
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