import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/models/Content.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import 'Consultation1.dart';
import 'HomePage.dart';

class Consultation4 extends StatelessWidget {
  String numero;

  Consultation4(this.numero);

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
      home: new Consultation_4(this.numero),
    );
  }
}

class Consultation_4 extends StatefulWidget {
  String numero;

  Consultation_4(this.numero);

  @override
  ConsultationPageState createState() => new ConsultationPageState(this.numero);
}

class ConsultationPageState extends State<Consultation_4> {
  String numero;
  ConsultationPageState(this.numero);
  Future<List<Content>> contenu;

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  void initState() {
    super.initState();
    contenu = _getContent();
  }

  Future<List<Content>> _getContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Setting.apiracine +
            "consultations/patient?numero=" +
            this.numero.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA2 :" + response.body.toString());

    List<Content> maliste = List();

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      for (int i = 0; i < responseJson.length; i++) {
        maliste.add(Content.fromJson(responseJson[i]));
      }

      return maliste;
    }

    return null;
  }

  List<Widget> _buildExpandableContent(List<Content> items) {
    List<Widget> listElementWidgetList = new List<Widget>();

    for (int i = 0; i < items.length; i++) {
      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                child: Text(items[i].libelle.toString() + " : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: Colors.black)),
              ),
              flex: 1,
            ),
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                child: Text(items[i].valeur.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.5,
                        color: Colors.black)),
              ),
              flex: 1,
            )
          ],
        ),
      ));
    }

    return listElementWidgetList;
  }

  List<Widget> _buildExpandableContent1(List<Content> items) {
    String texte = "";

    List<Widget> listElementWidgetList = new List<Widget>();

    for (int i = 0; i < items.length; i++) {
      texte += items[i].libelle.toString() + ", ";

      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
              child: Text(items[i].libelle.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black)),
            )
          ],
        ),
      ));

      listElementWidgetList.add(Divider(
        height: 5.0,
        color: Colors.grey,
      ));
    }

    /*Padding content = new Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
      child: Text(texte,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.5,
              color: Colors.black)),
    );

    return content; */

    return listElementWidgetList;
  }

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
            Padding(
              padding:
                  EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
              child: Text(items[i].toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black)),
            )
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
            title: Text(allTranslations.text('scan2_title')),
            backgroundColor: color,
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
            child: FutureBuilder<List<Content>>(
                future: contenu,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  if (snapshot.hasData) {
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
                            Text(allTranslations.text('erreur_title'),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18.0,
                                    color: Colors.black)),
                          ],
                        )),
                      );
                    } else if (snapshot.data
                        .toString()
                        .contains("PHP Notice")) {
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
                      List<Content> identification = new List();
                      List<Content> parametres = new List();
                      List<Content> antecedents = new List();
                      List<Content> antecedents1 = new List();

                      for (int i = 0; i < snapshot.data.length; i++) {
                        if (snapshot.data[i].groupe == 1)
                          identification.add(snapshot.data[i]);
                        else if (snapshot.data[i].groupe == 2)
                          parametres.add(snapshot.data[i]);
                        else if (snapshot.data[i].groupe == 3) {
                          if (snapshot.data[i].famille == 1)
                            antecedents.add(snapshot.data[i]);
                          else
                            antecedents1.add(snapshot.data[i]);
                        }
                      }

                      return new Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Divider(
                              height: 8.0,
                              color: Colors.transparent,
                            ),
                            new Text(
                              allTranslations.text('consultation2_title'),
                              textAlign: TextAlign.left,
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: color),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.0,
                                          right: 0.0,
                                          top: 5.0,
                                          bottom: 5.0),
                                      child: Text("Numéro patient : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.5,
                                              color: Colors.black)),
                                    ),
                                    flex: 1,
                                  ),
                                  new Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.0,
                                          right: 0.0,
                                          top: 5.0,
                                          bottom: 5.0),
                                      child: Text(this.numero,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14.5,
                                              color: Colors.black)),
                                    ),
                                    flex: 1,
                                  )
                                ],
                              ),
                            ),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Column(
                                  children:
                                      _buildExpandableContent(identification),
                                ),
                              ],
                            ),
                            Divider(
                              height: 8.0,
                              color: Colors.transparent,
                            ),
                            parametres.length != 0
                                ? new Text(
                                    allTranslations.text('para3_title'),
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: color),
                                  )
                                : Container(),
                            parametres.length != 0
                                ? new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Column(
                                        children:
                                            _buildExpandableContent(parametres),
                                      ),
                                    ],
                                  )
                                : Container(),
                            Divider(
                              height: 8.0,
                              color: Colors.transparent,
                            ),
                            ((antecedents.length != 0) ||
                                    (antecedents1.length != 0))
                                ? new Text(
                                    allTranslations.text('antecedent0_title'),
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: color),
                                  )
                                : Container(),
                            SizedBox(height: 10.0),
                            antecedents.length != 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 30.0),
                                    child: Center(
                                      child: Text(
                                        allTranslations.text('toxico_title'),
                                        style: TextStyle(
                                            color: color2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ))
                                : Container(),
                            antecedents.length != 0
                                ? SizedBox(height: 10.0)
                                : Container(),
                            Container(
                              child: Column(
                                  children:
                                      _buildExpandableContent1(antecedents)),
                            ),
                            SizedBox(height: 10),
                            antecedents1.length != 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 30.0),
                                    child: Center(
                                      child: Text(
                                        allTranslations
                                            .text('antecedent6_title'),
                                        style: TextStyle(
                                            color: color2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ))
                                : Container(),
                            antecedents1.length != 0
                                ? SizedBox(height: 15.0)
                                : Container(),
                            Container(
                              child: Column(
                                  children:
                                      _buildExpandableContent1(antecedents1)),
                            ),
                            SizedBox(height: 25),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (_) => new HomePage()),
                                    );
                                  },
                                  child: new Container(
                                    width: 120.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                      color: color,
                                      border: new Border.all(
                                          color: Colors.white, width: 2.0),
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: new Center(
                                      child: new Text(
                                        allTranslations.text('cancel_title'),
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                new InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (_) =>
                                              new Consultation1(numero)),
                                    );
                                  },
                                  child: new Container(
                                    width: 240.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                      color: color2,
                                      border: new Border.all(
                                          color: Colors.white, width: 2.0),
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: new Center(
                                      child: new Text(
                                        allTranslations
                                            .text('consultation4_title'),
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  }
                }),
          )),
        ));
  }
}
