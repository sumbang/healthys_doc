import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/fragments/NewsFragment.dart';
import 'package:healthys_medecin/fragments/RendezVousFragment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'HomePageNew.dart';

class NewsPage extends StatelessWidget {
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
      home: new NewsPage1(),
    );
  }
}

class NewsPage1 extends StatefulWidget {
  NewsPage1();

  @override
  NewsPageState createState() => new NewsPageState();
}

class NewsPageState extends State<NewsPage1> {
  NewsPageState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

    String perso = "";

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      perso = (prefs.getString('currentperso') ?? "");
    });
  }
  
  void initState() {
    _loadUser();
    super.initState();
  }

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
              title: Text(allTranslations.text("z59")),
              backgroundColor: color,
              elevation: 0,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                 if(perso == "1") {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new HomePageNew()),
                  );
                  }else {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new HomePage()),
                  );
                  }
                },
              ),
            ),
            body: new NewsFragment()));
  }
}
