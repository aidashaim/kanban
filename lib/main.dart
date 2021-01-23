import 'package:flutter/material.dart';
import 'package:kanban/bloc/Provider.dart';
import 'package:kanban/pages/loginPage.dart';
import 'package:kanban/pages/mainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
      title: 'Kanban',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amber, width: 2.0)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF909090), width: 2.0)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.amber,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF303030),
        accentColor: Color(0xFF909090),
        cursorColor: Color(0xFF909090),
        hintColor: Color(0xFF909090),
        cardColor: Colors.white,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            fontSize: 15.0,
            color: Colors.amber,
          ),
          headline2: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              letterSpacing: 3,
              color: Color(0xFFffffff)),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          final bloc = Provider.of(context);

          return StreamBuilder(
            stream: bloc.isAuthenticated,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoginPage();
              } else {
                return MainPage();
              }
            },
          );
        },
        '/home': (BuildContext context) => new MainPage()
      },
    ));
  }
}
