import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ParametreFragment extends StatefulWidget {
  ParametreFragment();

  @override
  ParametreFragmentState createState() => new ParametreFragmentState();
}

class ParametreFragmentState extends State<ParametreFragment> {
  ParametreFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  MyItems? rhesus;
  MyItems? sanguin;
  MyItems? electro;

  final _poidsController = TextEditingController();
  final _tailleController = TextEditingController();
  final _tensionController = TextEditingController();

  String currentpatient = "";
  String token = "";
  String rhesus1 = "";
  String electro1 = "";
  String groupe1 = "";

  bool _isChecked = true;
  bool _isSaving = true;

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = [];

    var response = await http
        .get(Uri.parse(Setting.apiracine + "comptes/data?types=" + nature.toString()));

    print("DATA :" + response.body.toString());

      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
  
  }

  int _groupValue1 = -1;
  int _groupValue2 = -1;

  Future<List<MyItems>>? emato;
  Future<List<MyItems>>? groupe;

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String currentpatient1 = (prefs.getString('currentpatient') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    emato = getElements("6");
    groupe = getElements("4");

    var res = await http.get(
        Uri.parse(Setting.apiracine + "comptes/donnee?patient=" + currentpatient1),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA5 :" + res.body.toString());

    if (res.statusCode == 200) {
      var responseJson = json.decode(res.body);

      setState(() {
        setState(() {
          _poidsController.text = responseJson["poids"].toString();
          _tailleController.text = responseJson["taille"].toString();
          _tensionController.text = responseJson["tension"] == null
              ? ""
              : responseJson["tension"].toString();
          rhesus1 = responseJson["rhesus"].toString();
          groupe1 = responseJson["groupe"].toString();
          electro1 = responseJson["electro"].toString();
          _groupValue1 = int.tryParse(responseJson["groupe"].toString())!;
          _groupValue2 = int.tryParse(responseJson["electro"].toString())!;
        });
      });
    }
  }

  void initState() {
    super.initState();

    _loadUser();
  }

  void _submitForms() async {
    if (_tailleController.text.isEmpty || _poidsController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else {
      showDialog(
        context: context,
        barrierDismissible: _isSaving,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(allTranslations.text('progress_title')),
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

      Map data = {
        'rhesus': "",
        'electro': _groupValue2.toString(),
        'groupe': _groupValue1.toString(),
        'poids': _poidsController.text.toString(),
        'taille': _tailleController.text.toString(),
        'tension': _tensionController.text.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');
      String id = (prefs.getString('id') ?? '');

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

      var res = await http.put(
          Uri.parse(Setting.apiracine +
              "comptes/para?patient=" +
              currentpatient1 +
              "&user=" +
              id),
          body: data,
          headers: {
            "Authorization": basicAuth,
            "Language": mySingleton.getLangue.toString(),
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
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        var responseJson = json.decode(res.body);

        Fluttertoast.showToast(
            msg: responseJson["message"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    // TODO: implement build
    return SingleChildScrollView(
        child: ConstrainedBox(
      constraints: BoxConstraints(),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('poids_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  keyboardType: TextInputType.number,
                  controller: _poidsController,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('taille_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  keyboardType: TextInputType.number,
                  controller: _tailleController,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('tension_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  keyboardType: TextInputType.text,
                  controller: _tensionController,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('electro_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: emato,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      List<Widget> civ = [];

                      for (int i = 0; i < snapshot.data!.length; i++) {
                        Widget radio = new RadioListTile(
                          value: snapshot.data![i].id,
                          groupValue: _groupValue2,
                          title: Text(
                            snapshot.data![i].libelle.toString(),
                            style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onChanged: (newValue) =>
                              setState(() => _groupValue2 = newValue),
                          activeColor: color,
                          selected: snapshot.data![i].id == _groupValue2
                              ? true
                              : false,
                        );

                        civ.add(radio);
                        //civ.add(pad);
                      }

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: civ);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: Text(
                          allTranslations.text('groupe_title'),
                          style: TextStyle(
                              color: color2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                        child: FutureBuilder<List<MyItems>>(
                            future: groupe,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return new Container();
                              } else if (snapshot.hasData) {
                                List<Widget> civ = [];

                                for (int i = 0; i < snapshot.data!.length; i++) {
                                  Widget radio = new RadioListTile(
                                    value: snapshot.data![i].id,
                                    groupValue: _groupValue1,
                                    title: Text(
                                      snapshot.data![i].libelle.toString(),
                                      style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onChanged: (newValue) =>
                                        setState(() => _groupValue1 = newValue),
                                    activeColor: color,
                                    selected:
                                        snapshot.data![i].id == _groupValue1
                                            ? true
                                            : false,
                                  );

                                  civ.add(radio);
                                  //civ.add(pad);
                                }

                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: civ);
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                      ),
                    ],
                  ),
                  flex: 1,
                ),
              ],
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new Center(
                  child: new InkWell(
                    onTap: _submitForms,
                    child: new Container(
                      width: 350.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        color: color,
                        border: new Border.all(color: Colors.white, width: 2.0),
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: new Center(
                        child: new Text(
                          allTranslations.text('save_title'),
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
          ]),
    ));
  }
}
