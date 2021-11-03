import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dropdown_formfield/dropdown_formfield.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'HomePage.dart';

class DetailConsultation extends StatelessWidget {
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
      home: new DetailConsultation1(),
    );
  }
}

class DetailConsultation1 extends StatefulWidget {
  DetailConsultation1();

  @override
  DetailConsultationState createState() => new DetailConsultationState();
}

class DetailConsultationState extends State<DetailConsultation1> {
  DetailConsultationState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";

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
              title: Text("Détail de la consultation"),
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
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new ExpansionTile(
                      title: new Text(
                        "PARAMETRES DE BASES",
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.black),
                      ),
                      children: <Widget>[
                        new Column(
                          children: [],
                        ),
                      ],
                    ),
                    new ExpansionTile(
                      title: new Text(
                        "MOTIF DE CONSULTATION",
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.black),
                      ),
                      children: <Widget>[
                        new Column(
                          children: [],
                        ),
                      ],
                    ),
                    new ExpansionTile(
                      title: new Text(
                        "DIAGNOSTIC",
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.black),
                      ),
                      children: <Widget>[
                        new Column(
                          children: [],
                        ),
                      ],
                    ),
                    new ExpansionTile(
                      title: new Text(
                        "ORDONNANCE",
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.black),
                      ),
                      children: <Widget>[
                        new Column(
                          children: [],
                        ),
                      ],
                    ),
                    new ExpansionTile(
                      title: new Text(
                        "RESULTATS ET TRAITEMENTS",
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            color: Colors.black),
                      ),
                      children: <Widget>[
                        new Column(
                          children: [],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))));
  }
}
