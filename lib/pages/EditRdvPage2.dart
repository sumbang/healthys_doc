import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/forms/EditRdvForm2.dart';
import 'package:healthys_medecin/models/Meeting.dart';
import 'package:healthys_medecin/pages/RdvPage.dart';

import 'Rendezvous2Page.dart';

class EditRdvPage2 extends StatelessWidget {
  Meeting med;

  EditRdvPage2(this.med);

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
      home: new EditRdvPage1(this.med),
    );
  }
}

class EditRdvPage1 extends StatefulWidget {
  Meeting med;
  EditRdvPage1(this.med);

  @override
  EditRdvPageState createState() => new EditRdvPageState(this.med);
}

class EditRdvPageState extends State<EditRdvPage1> {
  Meeting med;
  EditRdvPageState(this.med);

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
              title: Text(allTranslations.text('t1')),
              backgroundColor: color,
              elevation: 0,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new RdvPage()),
                  );
                },
              ),
            ),
            body: new SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: new EditRdvForm2(this.med)))));
  }
}
