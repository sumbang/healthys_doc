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
import 'package:shared_preferences/shared_preferences.dart';

class EvolutionPage extends StatefulWidget {
  String consultation;
  EvolutionPage(this.consultation);

  @override
  EvolutionPage1 createState() => EvolutionPage1(this.consultation);
}

class EvolutionPage1 extends State<EvolutionPage> {
  String consultation;
  EvolutionPage1(this.consultation);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";

  bool _isChecked = true;
  bool _isSaving = true;
  Future<String> data;

  List<Widget> _buildList(String datas) {
    List<Widget> listElementWidgetList = new List<Widget>();
    List<String> items = datas.split(";");

    for (int i = 0; i < items.length; i++) {
      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text(items[i].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black))))
          ],
        ),
      ));

      listElementWidgetList.add(Divider(
        height: 5.0,
        color: Colors.grey,
      ));
    }

    return listElementWidgetList;
  }

  List<Widget> _buildList2(String datas) {
    List<Widget> listElementWidgetList = new List<Widget>();
    List<String> items = datas.split("|");

    for (int i = 0; i < items.length; i++) {
      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text(items[i].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black))))
          ],
        ),
      ));

      listElementWidgetList.add(Divider(
        height: 5.0,
        color: Colors.grey,
      ));
    }

    return listElementWidgetList;
  }

  List<Widget> _buildImage(String datas) {
    List<Widget> listElementWidgetList = new List<Widget>();
    List<String> items = datas.split("|");
    
    for (int i = 0; i < items.length; i++) {
      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Image.network( 
        Setting.serveurimage1 +''+ items[i], fit: BoxFit.fill),
      ));

      listElementWidgetList.add(Divider(
        height: 5.0,
        color: Colors.grey,
      ));
    }

    return listElementWidgetList;

    

  }

  Future<String> getElements() async {
    Locale myLocale = Localizations.localeOf(context);
    print("debut");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Setting.apiracine +
            "consultations/view3?id=" +
            consultation.toString() +
            "&language=" +
            myLocale.languageCode.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA :" + response.body.toString());

    if (response.statusCode == 200) {
      return response.body.toString();
    }

    return null;
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      data = getElements();
    });
           
       super.initState();
    // Future.delayed(Duration.zero, () {
  // });
   
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white.withOpacity(1.0),
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Builder(builder: (BuildContext context) {
                    return FutureBuilder<String>(
                        future: getElements(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return new Container(
                                child: new Center(
                                  child: new CircularProgressIndicator(),
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Container(
                                  child: Center(
                                      child: Column(
                                    children: <Widget>[
                                      Divider(
                                        color: Colors.transparent,
                                        height: 100.0,
                                      ),
                                      Icon(
                                        Icons.error,
                                        size: 120.0,
                                      ),
                                      Divider(
                                        color: Colors.transparent,
                                        height: 5.0,
                                      ),
                                      Text(allTranslations.text('erreur_title'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18.0,
                                              color: Colors.black)),
                                    ],
                                  )),
                                );
                              } else {
                                if (snapshot.data == null) {
                                  return Container(
                                    child: Center(
                                        child: Column(
                                      children: <Widget>[
                                        Divider(
                                          color: Colors.transparent,
                                          height: 100.0,
                                        ),
                                        Icon(
                                          Icons.error,
                                          size: 120.0,
                                        ),
                                        Divider(
                                          color: Colors.transparent,
                                          height: 5.0,
                                        ),
                                        Text(
                                            allTranslations
                                                .text('erreur_title'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18.0,
                                                color: Colors.black)),
                                      ],
                                    )),
                                  );
                                } else {
                                  print("json : " + snapshot.data.toString());

                                  final responseJson =
                                      json.decode(snapshot.data.toString());

                                  List<Widget> listElementWidgetList =
                                      new List<Widget>();

                                  for (int i = 0;
                                      i < responseJson.length;
                                      i++) {
                                    List<Widget> liste = new List<Widget>();
                                    liste.add(new Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 5.0,
                                            bottom: 5.0),
                                        child: Center(
                                            child: Text(
                                                responseJson[i]["date"]
                                                    .toString(),
                                                style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                )))));
                                    liste.add(SizedBox(height: 10));
                                    liste.add(Text(
                                      allTranslations.text("titre5_title"),
                                      style: TextStyle(color: color, fontSize: 17.0),
                                    ));
                                    liste.add(SizedBox(height: 10));
                                    liste.add(Text(
                                      responseJson[i]["cmt"],
                                      style: TextStyle(
                                          height: 1.2, color: Colors.black, fontSize: 15.0),
                                    ));
                                    liste.add(SizedBox(height: 10));

                                   /* if (responseJson[i]["diagnostic"]
                                        .toString()
                                        .isNotEmpty) {
                                      liste.add(Text(allTranslations.text("z78"),
                                          style: TextStyle(color: color2)));
                                      liste.add(Column(
                                        children: _buildList2(responseJson[i]
                                                ["diagnostic"]
                                            .toString()),
                                      ));
                                      liste.add(SizedBox(height: 10));
                                    }*/

                                    if(responseJson[i]["scan1"] != null && responseJson[i]["scan"].toString().isNotEmpty) {
                                       liste.add( Text(allTranslations.text('cmt_title'),
                                          style: TextStyle(
                                              color: color, fontSize: 17.0)),);
                                       liste.add(SizedBox(height: 20));
                                       liste.add(Column(
                                        children: _buildList(responseJson[i]
                                                ["resultat"]
                                            .toString()),
                                      ));
                                       liste.add(SizedBox(height: 20));
                                       liste.add(Image.network(
                                              Setting.serveurimage1 +
                                                  '' +
                                                  responseJson[i]["scan1"],
                                              fit: BoxFit.fill));

                                      liste.add(SizedBox(height: 20));
                                    }

                                  if (responseJson[i]["resultat1"]
                                        .toString()
                                        .isNotEmpty) {
                                      liste.add(Text(allTranslations.text("z70"),
                                          style: TextStyle(color: color, fontSize: 17.0)));
                                      liste.add(Column(
                                        children: _buildImage(responseJson[i]
                                                ["resultat1"]
                                            .toString()),
                                      ));

                                      liste.add(SizedBox(height: 15));
                                    }


                                  if (responseJson[i]["diagnostic1"]
                                        .toString()
                                        .isNotEmpty) {
                                      liste.add(Text(allTranslations.text("z72"),
                                          style: TextStyle(color: color, fontSize: 17.0)));
                                      liste.add(Column(
                                        children: _buildList(responseJson[i]
                                                ["diagnostic1"]
                                            .toString()),
                                      ));

                                      liste.add(SizedBox(height: 15));
                                    }


                                  if (responseJson[i]["mise1"]
                                        .toString()
                                        .isNotEmpty) {
                                      liste.add(Text(allTranslations.text("z73"),
                                          style: TextStyle(color: color, fontSize: 17.0)));
                                      liste.add(Column(
                                        children: _buildList(responseJson[i]
                                                ["mise1"]
                                            .toString()),
                                      ));

                                      liste.add(SizedBox(height: 15));
                                    }

                                    
                                    if (responseJson[i]["ordonnance"]
                                        .toString()
                                        .isNotEmpty) {
                                      liste.add(Text(allTranslations.text("z79"),
                                          style: TextStyle(color: color,  fontSize: 17.0)));
                                      liste.add(Column(
                                        children: _buildList(responseJson[i]
                                                ["ordonnance"]
                                            .toString()),
                                      ));
                                      liste.add(SizedBox(height: 10));
                                    }


                                    if(responseJson[i]["scan2"] != null && responseJson[i]["scan2"].toString().isNotEmpty ) {
                                       liste.add(SizedBox(height: 20));
                                       liste.add(Image.network(
                                              Setting.serveurimage1 +
                                                  '' +
                                                  responseJson[i]["scan2"],
                                              fit: BoxFit.fill));

                                      liste.add(SizedBox(height: 20));
                                    }

                                    listElementWidgetList.add(Column(
                                      children: liste,
                                    ));
                                  }

                                  // TODO: implement build
                                  return SingleChildScrollView(
                                      child: ConstrainedBox(
                                    constraints: BoxConstraints(),
                                    child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Divider(
                                            height: 100,
                                            color: Colors.transparent,
                                          ),
                                          Column(
                                            children: listElementWidgetList,
                                          )
                                        ]),
                                  ));
                                }
                              }
                          }
                        });
                  }),
                ),
                Positioned(
                    top: 20,
                    left: 20,
                    //height: 75,
                    child: new IconButton(
                      icon: new Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {Navigator.of(context).pop();}
                    )),
              ],
            )));
  }
}
