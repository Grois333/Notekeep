// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:notekeep/constants/routes.dart';
//import 'package:notekeep/firebase_options.dart';
import 'package:notekeep/services/auth/auth_service.dart';
import 'package:notekeep/services/auth/bloc/auth_event.dart';
import 'package:notekeep/services/auth/bloc/auth_state.dart';
import 'package:notekeep/services/auth/firebase_auth_provider.dart';
import 'package:notekeep/views/forgot_password_view.dart';
import 'package:notekeep/views/login_view.dart';
import 'package:notekeep/views/notes/create_update_note_view.dart';
import 'package:notekeep/views/notes/notes_view.dart';
import 'package:notekeep/views/register_view.dart';
import 'package:notekeep/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;
import 'package:notekeep/helpers/loading/loading_screen.dart';

import 'services/auth/bloc/auth_bloc.dart';
//import 'enums/menu_action.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        // loginRoute: (context) => const LoginView(),
        // registerRoute: (context) => const RegisterView(),
        // notesRoute: (context) => const NotesView(),
        // verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state){
      if(state is AuthStateLoggedIn){
          return const NotesView();
      } else if(state is AuthStateNeedsVerification){
          return const VerifyEmailView();
      } else if(state is AuthStateLoggedOut){
          return const LoginView();
      } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    },);

    // return FutureBuilder(
    //   future: AuthService.firebase().initialize(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         //print(FirebaseAuth.instance.currentUser);
    //         final user = AuthService.firebase().currentUser;
    //         if (user != null) {
    //           if (user.isEmailVerified) {
    //             //print('Email is verified');
    //             return const NotesView();
    //           } else {
    //             devtools.log('Email is not verified');
    //             devtools.log(user.toString());
    //             // print('Email is not verified');
    //             // print(user);
    //             return const VerifyEmailView();

    //             // Debugging For Stuck Emailverified issue (refresh user)
    //             // FirebaseAuth.instance.currentUser!.reload();
    //             // FirebaseAuth.instance.signOut();
    //             // return const LoginView();
    //           }
    //         } else {
    //           return const LoginView();
    //         }
    //       //return const Text('Done');
    //       default:
    //         return const CircularProgressIndicator();
    //     }
    //   },
    // );


  }
}


// //Learning about Bloc
// class HomePage extends StatefulWidget {
//   const HomePage({ Key? key }) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose(){
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Testing bloc'),
//         ),
//         body: BlocConsumer<CounterBloc, CounterSate>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: (context, state){
//             final invalidValue = (state is CounterStateInvalidNumber) 
//              ? state.invalidValue
//              : '';
//             return Column(
//               children: [
//                 Text('Current value => ${state.value}'),
//                 Visibility(
//                   child: Text('Invalid input: $invalidValue'),
//                   visible: state is CounterStateInvalidNumber,
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter a number here',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: (){
//                         context.read<CounterBloc>().add(DecrementEvent(_controller.text));
//                       }, 
//                       child: const Text('-')
//                     ),
//                     TextButton(
//                       onPressed: (){
//                         context.read<CounterBloc>().add(IncrementEvent(_controller.text));
//                       }, 
//                       child: const Text('+')
//                     ),
//                   ],
//                 )
//               ],
//             );
//           },
//         )
//       ),
//     );
//   }
// }

// @immutable
// abstract class CounterSate{
//   final int value;
//   const CounterSate(this.value);
// }

// class CounterStateValid extends CounterSate{
//   const CounterStateValid(int value): super(value);
// }

// class CounterStateInvalidNumber extends CounterSate{
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent{
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent{
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent{
//   const DecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterSate>{
//   CounterBloc() : super(const CounterStateValid(0)){
//     on<IncrementEvent>((event,emit) {
//       final integer = int.tryParse(event.value);
//       if(integer == null){
//         emit(CounterStateInvalidNumber(invalidValue: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });

//     on<DecrementEvent>((event,emit) {
//       final integer = int.tryParse(event.value);
//       if(integer == null){
//         emit(CounterStateInvalidNumber(invalidValue: event.value, previousValue: state.value));
//       } else {
//         emit(CounterStateValid(state.value - integer));
//       }
//     });
//   }
  
// }