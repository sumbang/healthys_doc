import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/pages/HomePageNew.dart';
import 'HomePage.dart';

class SuccessPage extends StatelessWidget {
  String matricule;
  String pin;

  SuccessPage(this.matricule, this.pin);

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
      home: new SuccessPage1(matricule, pin),
    );
  }
}

class SuccessPage1 extends StatefulWidget {
  String matricule;
  String pin;

  SuccessPage1(this.matricule, this.pin);

  @override
  SuccessPageState createState() =>
      new SuccessPageState(this.matricule, this.pin);
}

class SuccessPageState extends State<SuccessPage1> {
  final graycolor = const Color(0xFFdededc);
  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String matricule;
  String pin;

  SuccessPageState(this.matricule, this.pin);

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("z56")),
          backgroundColor: color,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (_) => new HomePageNew()),
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
                              new Center(
                                  child: new Image.asset(
                                'img/success-icon.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: 200.0,
                              )),
                              new Divider(
                                height: 30.0,
                                color: Colors.transparent,
                              ),
                              Center(
                                  child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Bravo, profil patient créé. Les informations sont les suivantes: : ',
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('Matricule santé : ' + this.matricule,
                                      style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Pin de connexion :  ' + this.pin,
                                      style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                      'NB : Veuillez communiquer ses informations au patient.',
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                              new Divider(
                                height: 30.0,
                                color: Colors.transparent,
                              ),
                            ],
                          ))
                    ]))));
  }
}
