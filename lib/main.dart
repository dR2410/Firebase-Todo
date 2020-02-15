import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SigninPage.dart';
import 'SignupPage.dart';
import 'AboutUS.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{    //for linking to multiple pages
        "/SigninPage": (BuildContext context) => SigninPage(),
        "/SignupPage": (BuildContext context) => SignupPage(),
        "/home" : (BuildContext context) => HomePage(),
        "/details" : (BuildContext context) => AboutUs(), 
      },
    );
  }
}