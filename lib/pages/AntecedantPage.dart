import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/fragments/DossierMedicalFragment.dart';

import 'HomePage.dart';

class AntecedantPage extends StatelessWidget {
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
      home: new AntecedantPage2(),
    );
  }
}

class AntecedantPage2 extends StatefulWidget {
  AntecedantPage2();

  @override
  AntecedantPageState createState() => new AntecedantPageState();
}

class AntecedantPageState extends State<AntecedantPage2> {
  AntecedantPageState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(allTranslations.text('vie_title')),
              backgroundColor: color2,
              elevation: 0,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new HomePage()),
                  );
                },
              ),
            ),
            body: new DossierMedicalFragment()));
  }
}
