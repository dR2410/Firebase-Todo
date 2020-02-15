import 'package:flutter/material.dart';


class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AboutUs"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.cyan[100],
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage("images/about.png")),
              ),
              Padding(padding: EdgeInsets.all(30)),
              Container(
                child: Text("Firebase Todo App is a new project that is focused on sign in and sign up which requires" +
                "firebase authentication which has to be stored in the authentication or newly user created with valid" +
                "email and password then user can access the database todo app with priorites they want to set."+
                "This is Flutter project which is supported in IOS and Android app which has high OS version."+
                "You can check other apps at LearncodeOnline by Hitesh Choudhary if you you liked it",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600],fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}