import 'package:COVID19/api/service.dart';
import 'package:COVID19/data.dart';
import 'package:COVID19/pages/home_screen.dart';
import 'package:flutter/material.dart';


void main() {
  setupLocator();
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'nCOVID-19',
      theme: ThemeData(
          fontFamily: 'Ubuntu',
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: new MaterialColor(0xFF375a7a, Data.color),
              splashColor: new MaterialColor(0xFF1f3548, Data.color)),
          primaryColor: Colors.indigoAccent.shade200,
          primaryColorDark: Colors.indigoAccent.shade400,
          accentColor: Colors.indigoAccent.shade400),
      home: HomeScreen(),
    );
  }
}

