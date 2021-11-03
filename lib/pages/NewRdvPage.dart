import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/forms/RdvForm.dart';
import 'package:healthys_medecin/models/Medecin.dart';

import 'HomePage.dart';

class NewRdvPage extends StatelessWidget {
  Medecin med;

  NewRdvPage(this.med);

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
      home: new NewRdvPage1(this.med),
    );
  }
}

class NewRdvPage1 extends StatefulWidget {
  Medecin med;
  NewRdvPage1(this.med);

  @override
  NewRdvPageState createState() => new NewRdvPageState(this.med);
}

class NewRdvPageState extends State<NewRdvPage1> {
  Medecin med;
  NewRdvPageState(this.med);

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
            body: new SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: new RdvForm(this.med)))));
  }
}
