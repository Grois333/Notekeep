//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeep/services/auth/auth_exceptions.dart';
//import 'package:notekeep/services/auth/auth_service.dart';
//import 'dart:developer' as devtools show log;

import '../constants/routes.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({ Key? key }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState(){
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email'
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password'
            ),
          ),
          TextButton( 
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try{

                context.read<AuthBloc>().add(
                  AuthEventLogIn(
                    email,
                    password,
                  ),
                );

                // await AuthService.firebase().logIn(email: email, password: password);
                // //final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                // final user = AuthService.firebase().currentUser;
                // //if user is verified
                // if(user?.isEmailVerified ?? false){
                //   Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false,);
                //   //devtools.log(userCredential.toString());
                //   //print(userCredential);
                // }else{
                //   Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false,);
                //   //devtools.log(userCredential.toString());
                // }

              } 
              on UserNotFoundAuthException{
                await showErrorDialog(context, 'User not found',);
              } 
              on WrongPasswordAuthException{
                await showErrorDialog(context, 'Wrong credentials',);
              }
              on GenericAuthException{
                await showErrorDialog(context, 'Authentication Error',);
              }
              // catch (e){
              //   //print('Something bad happened');
              //   //print(e);
              //   //print(e.runtimeType);
              //   //await showErrorDialog(context, e.toString(),);
              // }
            }, child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false,);
            }, child: const Text('Not registered yet? Register here!')
          )
        ],
      ),
    );
  }

}
