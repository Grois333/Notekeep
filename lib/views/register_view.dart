// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeep/extensions/buildcontext/loc.dart';
//import 'dart:developer' as devtools show log;

//import 'package:notekeep/constants/routes.dart';
import 'package:notekeep/services/auth/auth_exceptions.dart';
//import 'package:notekeep/services/auth/auth_service.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              //'Weak password'
              context.loc.register_error_weak_password,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              //'Email is already in use'
              context.loc.register_error_email_already_in_use,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              //'Failed to register'
              context.loc.register_error_generic,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              //'Invalid email'
              context.loc.register_error_invalid_email,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.register),
          //title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //const Text('Enter your email and password to create your notes!'),
              Text(context.loc.register_view_prompt),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  //hintText: 'Enter your email'
                  hintText: context.loc.email_text_field_placeholder,
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    InputDecoration(
                      //hintText: 'Enter your password'
                      hintText: context.loc.password_text_field_placeholder,
                    ),
              ),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                         context.read<AuthBloc>().add(
                            AuthEventRegister(
                              email,
                              password,
                            ),
                          );

                        // try {
                        //   //final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                        //   //devtools.log(userCredential.toString());

                        //   await AuthService.firebase()
                        //       .createUser(email: email, password: password);

                        //   //final user = FirebaseAuth.instance.currentUser;
                        //   //await user?.sendEmailVerification();

                        //   AuthService.firebase().sendEmailVerification();
                        //   Navigator.of(context).pushNamed(verifyEmailRoute);
                        //   //print(userCredential);
                        // } on WeakPasswordAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Weak Password',
                        //   );
                        // } on EmailAlreadyInUseAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Email is already in use',
                        //   );
                        // } on InvalidEmailAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Email is invalid',
                        //   );
                        // } on GenericAuthException {
                        //   await showErrorDialog(
                        //     context,
                        //     'Failed To Register',
                        //   );
                        // }
                        // // catch (e){
                        // //   await showErrorDialog(context, e.toString(),);
                        // // }

                      },
                      //child: const Text('Register'),
                      child: Text(
                          context.loc.register,
                      ),
                    ),

                    TextButton(
                      onPressed: () {

                        context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );

                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   loginRoute,
                        //   (route) => false,
                        // );

                      },
                      //child: const Text('Already registered? Login here!')
                      child: Text(
                          context.loc.register_view_already_registered,
                      ),
                    )

                  ],
                  
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
