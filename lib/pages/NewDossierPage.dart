import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/forms/DossierForm.dart';
import 'package:healthys_medecin/pages/DossierMedicalPage2.dart';

import 'HomePage.dart';

class NewDossierPage extends StatelessWidget {
  String patient;

  NewDossierPage(this.patient);

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
      home: new NewDossierPage1(this.patient),
    );
  }
}

class NewDossierPage1 extends StatefulWidget {
  String patient;
  NewDossierPage1(this.patient);

  @override
  NewDossierPageState createState() => new NewDossierPageState(this.patient);
}

class NewDossierPageState extends State<NewDossierPage1> {
  String patient;
  NewDossierPageState(this.patient);

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
              title: Text("Ajouter un historique"),
              backgroundColor: color,
              elevation: 0,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new DossierMedicalPage2(this.patient)),
                  );
                },
              ),
            ),
            body: new SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: new DossierForm(this.patient)))));
  }
}
