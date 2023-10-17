// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:notekeep/constants/routes.dart';
import 'package:notekeep/services/auth/auth_exceptions.dart';
import 'package:notekeep/services/auth/auth_service.dart';
import 'package:notekeep/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({ Key? key }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
      appBar: AppBar(title: const Text('Register'),),
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
          TextButton( onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try{
            //final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
            //devtools.log(userCredential.toString());

            await AuthService.firebase().createUser(email: email, password: password);

            //final user = FirebaseAuth.instance.currentUser;
            //await user?.sendEmailVerification();

            AuthService.firebase().sendEmailVerification();
            Navigator.of(context).pushNamed(verifyEmailRoute);
            //print(userCredential);
            } 
            on WeakPasswordAuthException{
               await showErrorDialog(context, 'Weak Password',);
            }
            on EmailAlreadyInUseAuthException{
              await showErrorDialog(context, 'Email is already in use',);
            }
            on InvalidEmailAuthException{
              await showErrorDialog(context, 'Email is invalid',);
            }
            on GenericAuthException{
              await showErrorDialog(context, 'Failed To Register',);
            }
            // catch (e){
            //   await showErrorDialog(context, e.toString(),);
            // }
          }, child: const Text('Register'),),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false,);
            }, child: const Text('Already registered? Login here!')
          )
        ],
      ),
    );
  }
}
