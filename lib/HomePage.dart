import 'package:flutter/material.dart';
import 'dart:async';
import 'database_helper.dart';   //to go back 2 directory ..
import 'Note.dart';
import './screnes/note_details.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "/SigninPage");
      }
    });
  }

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
      });
    }
    //print(this.user);
  }

  signOut() async {
    _auth.signOut();
  }
     
  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

   DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('DataBase ToDo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: getNoteListView(),
      drawer: Drawer(
        child: 
             !isSignedIn
                ? CircularProgressIndicator()
                :ListView(
                    children:<Widget>[
                   UserAccountsDrawerHeader(
                   accountName:  Text("User:    ${user.displayName}"),
                   accountEmail: Text("Email:   ${user.email}"),
                   currentAccountPicture: CircleAvatar(
                     backgroundImage: AssetImage("images/logo2.png"),
                        maxRadius: 30.0,
              ),
            ),
            ListTile(
              title: Text("Home"),
              trailing: Icon(Icons.home),
              onTap: () => Navigator.of(context).pushNamed("/home"),
            ),
            ListTile(
              title: Text("Add Todo"),
              trailing: Icon(Icons.edit),
              onTap: () =>  navigateToDetail(Note('','',2), 'Add Note'),
            ),
            ListTile(
              title: Text("About Us"),
              trailing: Icon(Icons.description),
              onTap: () => Navigator.of(context).pushNamed("/details"),
            ),
            ListTile(
              title: Text("Share"), 
              trailing: Icon(Icons.share),
              onTap: () => {},
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () => {},
            ),
             ListTile(
              title: Text("Sign Out"),
              trailing: Icon(Icons.exit_to_app),
              onTap: () => signOut(),
            ),
          ],
        ),
      ),
      
    );
  }

  ListView getNoteListView(){
  return ListView.builder(
    itemCount: count,
    itemBuilder: (context, position){
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.blue[800],
        elevation: 4.0,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://learncodeonline.in/mascot.png"),
          ),
          title: Text(this.noteList[position].title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 25.0),),
          subtitle: Text(this.noteList[position].date, style: TextStyle(color: Colors.white),),
          trailing: GestureDetector(        //this for right side 
            child: Icon(Icons.open_in_new, color: Colors.white,),
            onDoubleTap: (){
              navigateToDetail(this.noteList[position], 'Edit Todo');
            },
          ),
        ),
      );
    },
  );
}

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(note, title);
    }));

    if(result == true){
      //TODO: update the view
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){         //catch method type
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }


}