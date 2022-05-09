import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/forms/NewPassForm.dart';
import 'package:healthys_medecin/pages/ResetPage.dart';
import '../forms/LoginForm.dart';
import '../pages//HomePage.dart';
import 'LoginPage.dart';

class NewPassPage extends StatelessWidget {
  String user;

  NewPassPage(this.user);

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
      home: new NewPassPage1(this.user),
    );
  }
}

class NewPassPage1 extends StatefulWidget {
  String user;
  NewPassPage1(this.user);

  @override
  ResetPageState createState() => new ResetPageState(this.user);
}

class ResetPageState extends State<NewPassPage1> {
  final graycolor = const Color(0xFFdededc);
  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);
  String user;
  ResetPageState(this.user);

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

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
                new MaterialPageRoute(builder: (_) => new ResetPage()),
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
                                "",
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
                                allTranslations.text("z63"),
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
                              new NewPassForm(this.user),
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
