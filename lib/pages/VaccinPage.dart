import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/fragments/VaccinationFragment.dart';

import 'HomePage.dart';

class VaccinPage extends StatelessWidget {
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
      home: new VaccinPage1(),
    );
  }
}

class VaccinPage1 extends StatefulWidget {
  VaccinPage1();

  @override
  VaccinPage1State createState() => new VaccinPage1State();
}

class VaccinPage1State extends State<VaccinPage1> {
  VaccinPage1State();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  void initState() {
    super.initState();
  }

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
              title: Text(allTranslations
                  .text('vaccin_title')
                  .toString()
                  .toUpperCase()),
              backgroundColor: color,
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
            body: new VaccinationFragment()));
  }
}
