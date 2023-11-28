//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeep/constants/routes.dart';
import 'package:notekeep/services/auth/auth_service.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({ Key? key }) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Verify email'),),
      body: Column(
        children: [
          const Text("We've sent you an email verification. Please open it to verify your account"),
          const Text("If you Haven't received a verification email yet, press the button below"),
          TextButton(
            onPressed: () {

              context.read<AuthBloc>().add(
                const AuthEventSendEmailVerification(),
              );

              //await AuthService.firebase().sendEmailVerification();
              //final user = FirebaseAuth.instance.currentUser;
              //await user?.sendEmailVerification();
            }, 
            child: const Text('Send email verification'),
          ),
          TextButton(
           onPressed: () {

            context.read<AuthBloc>().add(
              const AuthEventLogOut(),
            );

            // final user = FirebaseAuth.instance.currentUser;
            // // Check if a user is signed in before attempting to delete
            // if (user != null) {
            //   await user.delete(); //delete user to start again
            // }
            //await AuthService.firebase().logOut();
            //await FirebaseAuth.instance.signOut();
            //Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false,);

           }, 
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}