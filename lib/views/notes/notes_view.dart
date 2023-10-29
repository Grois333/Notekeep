//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notekeep/constants/routes.dart';
import 'package:notekeep/services/crud/notes_service.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({ Key? key }) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;

  
   @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  void dispose(){
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(newNoteRoute);
            }, 
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              //devtools.log(value.toString());
              switch (value){
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if(shouldLogout){
                    await AuthService.firebase().logOut();
                    //await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false,);
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                      return const Text('Waiting for all notes...');
                    default:
                      return const CircularProgressIndicator();
                  }
                },              
              );
            default:
             return const CircularProgressIndicator();
          }
        },
      ),
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