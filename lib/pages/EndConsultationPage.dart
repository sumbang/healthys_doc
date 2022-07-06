import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/pages/HomePageNew.dart';

class EndConsultationPage extends StatelessWidget {
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
      home: new EndConsultationPage1(),
    );
  }
}

class EndConsultationPage1 extends StatefulWidget {
  EndConsultationPage1();

  @override
  EndConsultationPageState createState() => new EndConsultationPageState();
}

class EndConsultationPageState extends State<EndConsultationPage1> {
  final graycolor = const Color(0xFFdededc);
  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new Scaffold(
        appBar: AppBar(
          title: Text(allTranslations.text("z66")),
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
                                    allTranslations.text("z67"),
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
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
