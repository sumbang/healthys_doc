import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/forms/NewVaccinForm.dart';
import 'package:healthys_medecin/pages/HomePage.dart';
import 'package:healthys_medecin/pages/HomePageNew.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'VaccinPage.dart';

class NewVaccinPage extends StatelessWidget {
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
      home: new NewVaccinPage1(),
    );
  }
}

class NewVaccinPage1 extends StatefulWidget {
  NewVaccinPage1();

  @override
  NewVaccinPageState createState() => new NewVaccinPageState();
}

class NewVaccinPageState extends State<NewVaccinPage1> {
  NewVaccinPageState();

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
              title: Text(allTranslations.text('v1')),
              backgroundColor: color,
              elevation: 0,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  /*Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new VaccinPage()),
                  );*/
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
            body: new SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: new NewVaccinForm()))));
  }
}
