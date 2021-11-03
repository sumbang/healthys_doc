import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/fragments/RendezVous2Fragment.dart';

import 'HomePage.dart';

class Rendezvous2Page extends StatelessWidget {
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
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return new WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(allTranslations.text('menu30_title')),
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
            body: new RendezVous2Fragment()));
  }
}
