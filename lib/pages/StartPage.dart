import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';

import 'LoginPage.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Healthys App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
      home: new Start1(title: 'Flutter Swiper'),
    );
  }
}

class Start1 extends StatefulWidget {
  Start1({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Start1State createState() => new _Start1State();
}

class _Start1State extends State<Start1> {
  SwiperController _controller;

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  @override
  void initState() {
    super.initState();
    _controller = new SwiperController();
  }

  List<Widget> _texte(String description) {
    List<String> tab = description.split(";");

    List<Widget> maliste = new List();

    for (int i = 0; i < tab.length; i++) {
      maliste.add(new Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
        child: new Text(
          tab[i].toString(),
          style: TextStyle(color: Colors.black, fontSize: 14.0),
          textAlign: TextAlign.left,
        ),
      ));
    }

    return maliste;
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    const List<String> images = [
      "img/doc1.jpeg",
      "img/doc3.jpeg"
    ];

    const List<String> images1 = [
      "img/doc2.jpeg",
      "img/doc4.jpeg"
    ];

    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Swiper(
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Divider(
                        height: 60.0,
                        color: Colors.transparent,
                      ),
                      /* new Padding(
                        padding: EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                        child: new Text(
                          titres[index],
                          style: TextStyle(
                              color: color2,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),*/
                      /*new Divider(
                        height: 10.0,
                        color: Colors.transparent,
                      ),
                       new Image.asset(
                        images[index],
                        height: 300,
                      ),
                      new Divider(
                        height: 5.0,
                        color: Colors.transparent,
                      ),
                      new Column(
                        children: _texte(description[index]),
                      ),*/
                      mySingleton.getLangue.toString() == "fr"
                          ? new Image.asset(
                              images[index],
                              height: 500,
                            )
                          : new Image.asset(
                              images1[index],
                              height: 500,
                            ),
                      new Divider(
                        height: 30.0,
                        color: Colors.transparent,
                      ),
                      new Center(
                        child: new Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: new GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) => new LoginPage()),
                                  );
                                },
                                child: new Text(
                                  allTranslations.text('connexion_title'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: color),
                                  textAlign: TextAlign.end,
                                ))),
                      ),
                      /* new Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Flexible(
                            child: new Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: new GestureDetector(
                                    onTap: () {
                                      _controller.previous(animation: true);
                                    },
                                    child: new Text(
                                      index != 0
                                          ? allTranslations
                                              .text('previous_title')
                                          : "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: color2),
                                      textAlign: TextAlign.start,
                                    ))),
                            flex: 1,
                          ),
                          new Flexible(
                            child: new Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: new GestureDetector(
                                    onTap: () {
                                      if (index == 1) {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (_) => new LoginPage()),
                                        );
                                      } else
                                        _controller.next(animation: true);
                                    },
                                    child: new Text(
                                      index == 1
                                          ? allTranslations
                                              .text('connexion_title')
                                          : allTranslations.text('next_title'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: color),
                                      textAlign: TextAlign.end,
                                    ))),
                            flex: 1,
                          ),
                        ],
                      ),*/
                    ],
                  )));
        },

        //indicatorLayout: PageIndicatorLayout.COLOR,
        autoplay: false,
        itemCount: images.length,
        loop: false,
        pagination: new SwiperPagination(
            margin: new EdgeInsets.all(10.0),
            builder: new DotSwiperPaginationBuilder(
                color: Colors.grey,
                activeColor: color2,
                size: 7.0,
                activeSize: 7.0)),
        // control: new SwiperControl(color: Colors.redAccent),
      ),
    );
  }
}
