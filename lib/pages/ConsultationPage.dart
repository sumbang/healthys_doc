import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Content.dart';
import 'package:healthys_medecin/pages/NewConsultationPage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import 'ConsultationPage2.dart';

class ConsultationPage extends StatelessWidget {
  String numero;

  ConsultationPage(this.numero);

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
      home: new ConsultationPage1(this.numero),
    );
  }
}

class ConsultationPage1 extends StatefulWidget {
  String numero;

  ConsultationPage1(this.numero);

  @override
  ConsultationPage1State createState() =>
      new ConsultationPage1State(this.numero);
}

class ConsultationPage1State extends State<ConsultationPage1> {
  String numero;
  ConsultationPage1State(this.numero);
  Future<List<Content>>? contenu;

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  void initState() {
    super.initState();
    contenu = _getContent();
  }

  Future<List<Content>> _getContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Uri.parse(Setting.apiracine +
            "consultations/patient?numero=" +
            this.numero.toString()),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA2 :" + response.body.toString());

    List<Content> maliste = [];

      final responseJson = json.decode(response.body);

      for (int i = 0; i < responseJson.length; i++) {
        maliste.add(Content.fromJson(responseJson[i]));
      }

      return maliste;
  
  }

  List<Widget> _buildExpandableContent(List<Content> items) {
    List<Widget> listElementWidgetList = <Widget>[];

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

    List<Widget> listElementWidgetList = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      texte += items[i].libelle.toString() + ", ";

      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Expanded(child : Padding(
              padding:
                  EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
              child: Text(items[i].libelle.toString() + " : "+ items[i].valeur.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black)),
           ))
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

  List<Widget> _buildExpandableContent2(List<Content> items) {
    String texte = "";

    List<Widget> listElementWidgetList = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      texte += items[i].libelle.toString() + ", ";
      print("lien : "+Setting.serveurimage1 + '' + items[i].valeur);  
      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child:  Center(child : (items[i].valeur.isNotEmpty)
                    ? Container(
                          width: 150,
                          height: 150,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new NetworkImage(
                                    Setting.serveurimage1 +
                                        '' +
                                        items[i].valeur.toString(),
                                  ))))
                    : Container(),)
      ));

      listElementWidgetList.add(Divider(
        height: 15.0,
        color: Colors.transparent,
      ));
    }
    return listElementWidgetList;
  }


  List<Widget> _buildList(String datas) {
    List<Widget> listElementWidgetList = <Widget>[];
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
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(allTranslations.text('scan2_title').toUpperCase()),
            backgroundColor: color,
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (_) => new NewConsultationPage()),
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
                      List<Content> identification = [];
                      List<Content> parametres = [];
                      List<Content> antecedents = [];
                      List<Content> antecedents1 = [];
                      List<Content> photos = [];

                      for (int i = 0; i < snapshot.data!.length; i++) {
                        if (snapshot.data![i].groupe == 1)
                          identification.add(snapshot.data![i]);
                        else if (snapshot.data![i].groupe == 2)
                          parametres.add(snapshot.data![i]);
                        else if (snapshot.data![i].groupe == 4)
                          photos.add(snapshot.data![i]);
                        else if (snapshot.data![i].groupe == 3) {
                          if (snapshot.data![i].famille == 1)
                            antecedents.add(snapshot.data![i]);
                          else
                            antecedents1.add(snapshot.data![i]);
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
                            
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Column(
                                  children:
                                      _buildExpandableContent2(photos),
                                ),
                              ],
                            ),
                            new Text(
                              allTranslations
                                  .text('consultation2_title')
                                  .toUpperCase(),
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
                                      child: Text(allTranslations.text("matricule")+" : ",
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
                            Center(
                              child: new InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) =>
                                            new ConsultationPage2(numero)),
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
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
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
