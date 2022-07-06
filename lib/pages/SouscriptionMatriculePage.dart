import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/forms/NewSouscriptionForm.dart';
import '../forms/LoginForm.dart';
import 'HomePage.dart';

class SouscriptionMatriculePage extends StatelessWidget {
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
      home: new SouscriptionMatriculePage1(),
    );
  }
}

class SouscriptionMatriculePage1 extends StatefulWidget {
  SouscriptionMatriculePage1();

  @override
  SouscriptionMatriculePageState createState() =>
      new SouscriptionMatriculePageState();
}

class SouscriptionMatriculePageState extends State<SouscriptionMatriculePage1> {
  final graycolor = const Color(0xFFdededc);
  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new Scaffold(
        appBar: AppBar(
          title: Text("Activer un carnet santé"),
          backgroundColor: color2,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (_) => new HomePage()),
              );
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: new SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Divider(
                                height: 5.0,
                                color: Colors.transparent,
                              ),
                              Container(
                                width: double.infinity,
                                height: 100.0,
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: color2,
                                ),
                                margin: EdgeInsets.all(10.0),
                                child: Text(
                                  'Afin d\'activer un carnet santé, bien vouloir renseigner le matricule santé du patient et continuer.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      height: 1.5),
                                ),
                              ),
                              new Divider(
                                height: 5.0,
                                color: Colors.transparent,
                              ),
                              new NewSouscriptionForm(),
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
