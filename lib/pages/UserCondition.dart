import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCondition extends StatefulWidget {
  UserCondition();

  @override
  AntecedentPage1 createState() => AntecedentPage1();
}

class AntecedentPage1 extends State<UserCondition> {
  AntecedentPage1();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isChecked = true;
  bool _isSaving = true;

  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _submitForms() async {}

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());
    String url = "";

    url = Setting.serveurracine + "site/condition";

    return new WillPopScope(
      onWillPop: () async => false,
      child: new WebviewScaffold(
          url: url,
          appBar: new AppBar(
            title: new Text("Conditions générales d'utilisations"),
            backgroundColor: color,
            leading: new IconButton(
              icon: new Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          withZoom: true,
          withLocalStorage: true,
          hidden: true,
          initialChild: Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'Chargement.....',
                style: TextStyle(color: Colors.black),
              ),
            ),
          )),
    );

    /* return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white.withOpacity(1.0),
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Builder(builder: (BuildContext context) {
                    // TODO: implement build
                    return SingleChildScrollView(
                        child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Divider(
                              height: 100,
                              color: Colors.transparent,
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: new Center(
                                  child: Container(),
                                )),
                            Divider(
                              height: 10.0,
                              color: Colors.transparent,
                            ),
                          ]),
                    ));
                  }),
                ),
                Positioned(
                    top: 50,
                    left: 20,
                    //height: 75,
                    child: new IconButton(
                      icon: new Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
              ],
            ))); */
  }
}
