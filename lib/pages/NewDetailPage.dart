import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/SizeConfig.dart';
import 'package:healthys_medecin/models/News.dart';
import 'package:healthys_medecin/config/all_translations.dart';

import 'HomePage.dart';

class NewDetailPage extends StatelessWidget {
  News id;

  NewDetailPage(this.id);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: true,
              title: 'HomeScreen App',
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              // Tells the system which are the supported languages
              supportedLocales: allTranslations.supportedLocales(),
              home: NewDetailPage1(this.id),
            );
          },
        );
      },
    );
  }
}

class NewDetailPage1 extends StatefulWidget {
  News id;

  NewDetailPage1(this.id);

  @override
  NewDetailPage1State createState() => new NewDetailPage1State(this.id);
}

class NewDetailPage1State extends State<NewDetailPage1> {
  News id;
  NewDetailPage1State(this.id);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return Scaffold(
        backgroundColor: Color(0xffF8F8FA),
        body: new Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: NetworkImage(Setting.serveurimage + '' + id.image),
                  fit: BoxFit.cover,
                ),
              ),
              height: 25 * SizeConfig.heightMultiplier,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 8 * SizeConfig.heightMultiplier),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new IconButton(
                          icon: new Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (_) => new HomePage()),
                            );
                          },
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              id.titre,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20 * SizeConfig.heightMultiplier),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    )),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, top: 3 * SizeConfig.heightMultiplier),
                          child: Center(
                            child: Text(
                              id.contenu,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 2.2 * SizeConfig.textMultiplier),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
