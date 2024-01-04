//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeep/services/auth/auth_exceptions.dart';
//import 'package:notekeep/utilities/dialogs/loading_dialog.dart';
//import 'package:notekeep/services/auth/auth_service.dart';
//import 'dart:developer' as devtools show log;
import 'package:notekeep/extensions/buildcontext/loc.dart';

//import '../constants/routes.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  //CloseDialog? _closeDialogHandle;

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
        if (state is AuthStateLoggedOut) {

          // final closeDialog = _closeDialogHandle;
          // if(!state.isLoading &&  closeDialog != null){
          //   closeDialog();
          //   _closeDialogHandle = null;
          // } else if(state.isLoading && closeDialog == null){
          //   _closeDialogHandle = showLoadingDialog(
          //     context: context, 
          //     text: 'Loading...'
          //   );
          // }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'Cannot find a user with the entered credentials!'
                //context.loc.login_error_cannot_find_user,
                );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials'
                //context.loc.login_error_wrong_credentials,
                );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error'
                //context.loc.login_error_auth_error,
                );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.login),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Please log in to your account in order to interact with your notes!'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
              ),
              
              // BlocListener<AuthBloc, AuthState>(
              //   listener: (context, state) async {
                  
              //   },
              //   child: TextButton(
              //     onPressed: () async {
              //       final email = _email.text;
              //       final password = _password.text;
              //       context.read<AuthBloc>().add(
              //             AuthEventLogIn(
              //               email,
              //               password,
              //             ),
              //           );
              //       // try {
              //       //   context.read<AuthBloc>().add(
              //       //         AuthEventLogIn(
              //       //           email,
              //       //           password,
              //       //         ),
              //       //       );

              //       //   // await AuthService.firebase().logIn(email: email, password: password);
              //       //   // //final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
              //       //   // final user = AuthService.firebase().currentUser;
              //       //   // //if user is verified
              //       //   // if(user?.isEmailVerified ?? false){
              //       //   //   Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false,);
              //       //   //   //devtools.log(userCredential.toString());
              //       //   //   //print(userCredential);
              //       //   // }else{
              //       //   //   Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false,);
              //       //   //   //devtools.log(userCredential.toString());
              //       //   // }

              //       // } on UserNotFoundAuthException {
              //       //   await showErrorDialog(
              //       //     context,
              //       //     'User not found',
              //       //   );
              //       // } on WrongPasswordAuthException {
              //       //   await showErrorDialog(
              //       //     context,
              //       //     'Wrong credentials',
              //       //   );
              //       // } on GenericAuthException {
              //       //   await showErrorDialog(
              //       //     context,
              //       //     'Authentication Error',
              //       //   );
              //       // }
              //       // catch (e){
              //       //   //print('Something bad happened');
              //       //   //print(e);
              //       //   //print(e.runtimeType);
              //       //   //await showErrorDialog(context, e.toString(),);
              //       // }
              //     },
              //     child: const Text('Login'),
              //   ),
              // ),

              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                 child: const Text('Login'),
              ),


              TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: const Text(
                      'I forgot my password'
                      //context.loc.login_view_forgot_password,
                    ),
                  ),

              
              TextButton(
                  onPressed: () {

                    context.read<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                    );

                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   registerRoute,
                    //   (route) => false,
                    // );
                  },
                  child: const Text('Not registered yet? Register here!'))
            ],
          ),
        ),
      ),
    );
  }
}
