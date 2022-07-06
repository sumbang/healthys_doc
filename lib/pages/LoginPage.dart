import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/forms/LoginForm.dart';
import 'ResetPage.dart';
import 'SignupPage.dart';
import 'SignupPage2.dart';
import 'SignupPage2.dart';

class LoginPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
      home: new LoginPage1(),
    );
  }
}

class LoginPage1 extends StatefulWidget {
  LoginPage1();

  @override
  LoginPage1State createState() => new LoginPage1State();
}

class LoginPage1State extends State<LoginPage1> {
  final graycolor = const Color(0xFFdededc);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  void initState() {
    super.initState();
  }

  void _signupType() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: setupAlertDialoadContainer(),
          );
        });
  }

  Widget setupAlertDialoadContainer() {
    Widget maliste = ListView(
      children: ListTile.divideTiles(context: context, tiles: [
        ListTile(
          leading: Icon(
            Icons.person,
            color: color2,
          ),
          title: Text(allTranslations.text('type1_title')),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new SignupPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.add_box,
            color: color2,
          ),
          title: Text(allTranslations.text('type2_title')),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new SignupPage2()),
            );
          },
        ),
      ]).toList(),
    );

    return Container(
        height: 100.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: maliste);
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new Scaffold(
        backgroundColor: color,
        body: new SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Divider(
                                height: 100.0,
                                color: Colors.transparent,
                              ),
                              new Center(
                                  child: new Image.asset(
                                'img/doc.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: 200.0,
                              )),
                              new Divider(
                                height: 20.0,
                                color: Colors.transparent,
                              ),
                              new LoginForm(),
                              new Divider(
                                height: 30.0,
                                color: Colors.transparent,
                              ),
                              new GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) => new ResetPage()),
                                  );
                                },
                                child: new Center(
                                  child: new Text(
                                      allTranslations.text('pass_title'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.0,
                                          color: Colors.white)),
                                ),
                              ),
                              new Divider(
                                height: 40.0,
                                color: Colors.transparent,
                              ),
                              new GestureDetector(
                                onTap: () {
                                  //_signupType();

                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) => new SignupPage2()),
                                  );
                                },
                                child: new Center(
                                  child: new Text(
                                      allTranslations.text('compte_title'),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.0,
                                          color: Colors.white)),
                                ),
                              ),
                              new Divider(
                                height: 30.0,
                                color: Colors.transparent,
                              ),
                            ],
                          ))
                    ]))));
  }
}
