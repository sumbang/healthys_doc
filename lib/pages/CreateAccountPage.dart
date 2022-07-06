import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';

import 'LoginPage.dart';
import 'SignupPage.dart';
import 'SignupPage2.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage();

  final color = const Color(0xFF206201);
  final color2 = const Color(0xFF008dad);

  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new Main2Page(),
    );
  }
}

class Main2Page extends StatefulWidget {
  @override
  Main2PageState createState() => new Main2PageState();
}

class Main2PageState extends State<Main2Page> {
  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<bool> _currenSession() async {
    final prefs = await SharedPreferences.getInstance();

    final iduser = prefs.getInt('iduser') ?? 0;

    if (iduser == 0)
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(allTranslations.text('chooseprofil')),
          backgroundColor: color,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (_) => new LoginPage()),
              );
            },
          ),
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (_) => new SignupPage()),
                        );
                      },
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          color: color2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.person,
                                  size: 200.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Center(
                                child: Text(allTranslations.text('type1_title'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (_) => new SignupPage2()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        color: color2,
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            color: color,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.add_box,
                                    size: 200.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Center(
                                  child:
                                      Text(allTranslations.text('type2_title'),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25.0,
                                          )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
