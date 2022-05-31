import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/Docteur.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import 'ConsultationPage.dart';
import 'EndConsultationPage.dart';
import 'NewConsultationPage.dart';

class ConsultationPage2 extends StatelessWidget {
  String numero;
  ConsultationPage2(this.numero);

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
      home: new ConsultationPage21(this.numero),
    );
  }
}

class ConsultationPage21 extends StatefulWidget {
  String numero;

  ConsultationPage21(this.numero);

  @override
  ConsultationPage2State createState() =>
      new ConsultationPage2State(this.numero);
}

class ConsultationPage2State extends State<ConsultationPage21> {
  String numero;
  ConsultationPage2State(this.numero);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isSaving = true;

  MyItems specialite;
  Future<List<MyItems>> special;
  Future<List<Docteur>> docteur;
  bool _isShow = false;

  Uint8List bytes = Uint8List(0);
  TextEditingController numeroController = TextEditingController();
  TextEditingController motifController = TextEditingController();
  TextEditingController poidsController = TextEditingController();
  TextEditingController tailleController = TextEditingController();
  TextEditingController tensionController = TextEditingController();
  TextEditingController tension1Controller = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController suggestionController = TextEditingController();
  Docteur _docteur;

  var _listPara1 = List<Widget>();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController valeurController = TextEditingController();
  List<String> para = new List();
  bool _isdoctor = false;

  void initState() {
    super.initState();
    this.numeroController.text = numero.toString();
    special = getElements("7");
  }

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = List();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String user = (prefs.getString('currentid') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Setting.apiracine + "comptes/data1?types=" + nature.toString(),
        headers: {
          "Language": allTranslations.currentLanguage.toString(),
          "Authorization": basicAuth,
        });

    print("DATA :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  Future<List<Docteur>> getDocteur(String specialite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    List<Docteur> liste = List();

    print("DATA :" + specialite.toString());

    var response = await http.get(
        Setting.apiracine +
            "consultations/medecin?specialite=" +
            specialite.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Docteur.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  void _submitForms() async {
    if (motifController.text.isEmpty ||
        poidsController.text.isEmpty ||
        tailleController.text.isEmpty ||
        tensionController.text.isEmpty ||
        tension1Controller.text.isEmpty ||
        temperatureController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            allTranslations.text('progress_title'),
                            style: TextStyle(
                                color: color2, fontWeight: FontWeight.bold),
                          ),
                        )),
                    flex: 8,
                  ),
                  Flexible(
                      child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              },
                              icon: Icon(
                                Icons.close,
                                color: color,
                              ),
                              iconSize: 30.0,
                            ),
                          )),
                      flex: 1),
                ],
              ),
              content: new Container(
                  height: 100.0,
                  child: new Center(
                      child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ))));
        },
      );

      // start the modal progress HUD
      setState(() {
        _isSaving = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');
      String user = (prefs.getString('currentid') ?? '');
      String id = (prefs.getString('id') ?? '');

      String basicAuth = 'Bearer ' + token1;

      String _para = '[';
      for (int i = 0; i < para.length; i++) {
        if (i == 0)
          _para += para[i];
        else
          _para += "," + para[i];
      }
      _para += ']';

      String tension = tensionController.text.toString() +
          "|" +
          tension1Controller.text.toString();

      Map data = {
        'patient': numeroController.text.toString(),
        'medecin': "0",
        'motif': motifController.text.toString(),
        'poids': poidsController.text.toString(),
        'taille': tailleController.text.toString(),
        'tension': tension,
        'temperature': temperatureController.text.toString(),
        'user': user,
        'para': _para,
      };

      var res = await http.post(Setting.apiracine + "consultations/create1",
          body: data,
          headers: {
            "Authorization": basicAuth,
            "Language": allTranslations.currentLanguage.toString()
          });

      print("DATA5 :" + token1);

      print("DATA5 :" + res.body.toString());

      if (res.statusCode == 200) {
        var responseJson = json.decode(res.body);

        Navigator.of(context, rootNavigator: true).pop('dialog');

        Fluttertoast.showToast(
            msg: responseJson["message"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);

        Navigator.push(
          context,
          new MaterialPageRoute(builder: (_) => new EndConsultationPage()),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        var responseJson = json.decode(res.body);

        Fluttertoast.showToast(
            msg: responseJson["message"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
      }
    }
  }

  void _removePara(int pos) {
    setState(() {
      _listPara1 = List.from(_listPara1)..removeAt(pos);

      para = List.from(para)..removeAt(pos);
    });
  }

  _addPara() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            allTranslations.text("z46"),
                            style: TextStyle(
                                color: color2, fontWeight: FontWeight.bold),
                          ),
                        )),
                    flex: 8,
                  ),
                  Flexible(
                      child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              },
                              icon: Icon(
                                Icons.close,
                                color: color,
                              ),
                              iconSize: 30.0,
                            ),
                          )),
                      flex: 1),
                ],
              ),
              content: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Container(
                          height: 320.0,
                          width: 300.0, // Change as per your requirement
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(allTranslations.text("z47")+" *"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: new BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1.0)),
                                    border:
                                        new Border.all(color: Colors.black38),
                                  ),
                                  child: TextFormField(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        hintText: allTranslations.text("z48"),
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      controller: libelleController,
                                      keyboardType: TextInputType.text),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(allTranslations.text("z49")+" *"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: new BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1.0)),
                                    border:
                                        new Border.all(color: Colors.black38),
                                  ),
                                  child: TextFormField(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      controller: valeurController,
                                      keyboardType: TextInputType.text),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: new Center(
                                    child: new InkWell(
                                      onTap: () {
                                        if (libelleController.text
                                                .toString()
                                                .isEmpty ||
                                            valeurController.text
                                                .toString()
                                                .isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: allTranslations
                                                  .text('requis1_title'),
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIos: 5,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white);
                                        } else {
                                          String json = '{"libelle":"' +
                                              libelleController.text
                                                  .toString() +
                                              '","valeur":"' +
                                              valeurController.text.toString() +
                                              '"}';

                                          para.add(json);

                                          int pos = para.length - 1;

                                          _listPara1.add(Column(children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 15.0,
                                                    top: 0,
                                                    bottom: 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17.0),
                                                          child: new Text(
                                                              libelleController
                                                                      .text
                                                                      .toString() +
                                                                  " : " +
                                                                  valeurController
                                                                      .text
                                                                      .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ))),
                                                    ),
                                                    new IconButton(
                                                        icon: new Icon(
                                                          Icons.delete,
                                                          color: color,
                                                        ),
                                                        onPressed: () {
                                                          _removePara(pos);
                                                        }),
                                                  ],
                                                )),
                                            Divider(
                                                height: 5, color: Colors.grey)
                                          ]));

                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');

                                          setState(() {
                                            libelleController.text = "";
                                            valeurController.text = "";
                                          });
                                        }
                                      },
                                      child: new Container(
                                        width: 200.0,
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
                                            allTranslations.text("z28"),
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          )))));
        });
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
            title:
                Text(allTranslations.text('consultation1_title').toUpperCase()),
            backgroundColor: color,
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (_) => new ConsultationPage(this.numero)),
                );
              },
            ),
            actions: <Widget>[],
          ),
          body: Builder(
            builder: (BuildContext context) {
              return ListView(
                children: <Widget>[
                  //   _qrCodeWidget(this.bytes, context),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: new Text(
                                allTranslations.text('consultation2_title'),
                                style: TextStyle(
                                    color: color,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        SizedBox(height: 20),
                        Text(allTranslations.text('consultation3_title')),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: new Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              obscureText: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: new Icon(
                                  Icons.person,
                                  color: color,
                                ),
                              ),
                              enabled: false,
                              controller: numeroController,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          allTranslations.text('consultation5_title'),
                          style: TextStyle(
                              color: color,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: new Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              obscureText: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: new Icon(
                                  Icons.message,
                                  color: color,
                                ),
                              ),
                              controller: motifController,
                              maxLines: 3,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: new Text(
                                allTranslations.text('consultation4_title'),
                                style: TextStyle(
                                    color: color,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        SizedBox(height: 20),
                        Text(allTranslations.text('poids_title') + ' *'),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: new Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              obscureText: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: new Icon(
                                  Icons.info,
                                  color: color,
                                ),
                              ),
                              maxLines: 1,
                              controller: poidsController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(allTranslations.text('taille_title') + ' *'),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: new Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              obscureText: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: new Icon(
                                  Icons.info,
                                  color: color,
                                ),
                              ),
                              maxLines: 1,
                              controller: tailleController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                            allTranslations.text('consultation6_title') + ' *'),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: new Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              obscureText: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: new Icon(
                                  Icons.info,
                                  color: color,
                                ),
                              ),
                              maxLines: 1,
                              controller: temperatureController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(allTranslations.text('tension_title') + ' *'),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: new Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              obscureText: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                hintText: allTranslations.text('gauche'),
                                border: InputBorder.none,
                                icon: new Icon(
                                  Icons.info,
                                  color: color,
                                ),
                              ),
                              maxLines: 1,
                              controller: tensionController,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: new Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              obscureText: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                hintText: allTranslations.text('droit'),
                                border: InputBorder.none,
                                icon: new Icon(
                                  Icons.info,
                                  color: color,
                                ),
                              ),
                              maxLines: 1,
                              controller: tension1Controller,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _addPara();
                          },
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Image.asset("img/download.png",
                                      width: 25.0,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.centerLeft),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 5.0, top: 15),
                                    child: Center(
                                      child: Text(
                                        allTranslations.text('para1'),
                                        style: TextStyle(
                                            color: color2,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ))
                              ]),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                            child: Column(
                          children: this._listPara1,
                        )),
                        SizedBox(height: 20),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (_) =>
                                              new NewConsultationPage()),
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
                                        allTranslations.text('annul_title'),
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                new InkWell(
                                  onTap: () {
                                    _submitForms();
                                  },
                                  child: new Container(
                                    width: 200.0,
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
                                        allTranslations.text('save1_title'),
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 30.0)
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
