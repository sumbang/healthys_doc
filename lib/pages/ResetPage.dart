import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/forms/ResetForm.dart';
import 'LoginPage.dart';

class ResetPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
      home: new ResetPage1(),
    );
  }
}

class ResetPage1 extends StatefulWidget {
  ResetPage1();

  @override
  ResetPageState createState() => new ResetPageState();
}

class ResetPageState extends State<ResetPage1> {
  final graycolor = const Color(0xFFdededc);
  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (_) => new LoginPage()),
              );
            },
          ),
        ),
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
                                height: 30.0,
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
                              new Text(
                                allTranslations.text("z57"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              new Divider(
                                height: 20.0,
                                color: Colors.transparent,
                              ),
                              new Text(
                               allTranslations.text("z58"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              new Divider(
                                height: 5.0,
                                color: Colors.transparent,
                              ),
                              new ResetForm(),
                              new Divider(
                                height: 30.0,
                                color: Colors.transparent,
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
