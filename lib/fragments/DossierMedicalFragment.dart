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

class DossierMedicalFragment extends StatefulWidget {
  DossierMedicalFragment();

  @override
  DossierMedicalFragmentState createState() =>
      new DossierMedicalFragmentState();
}

class DossierMedicalFragmentState extends State<DossierMedicalFragment> {
  DossierMedicalFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";
  bool enable1 = false;
  bool enable2 = false;
  bool enable3 = false;
  bool enable4 = false;
  bool enable5 = false;
  bool enable6 = false;
  bool tabac = false;
  bool sport = false;
  bool alcool = false;
  bool hta = false;
  bool diabete = false;
  bool dsylipedemie = false;
  bool asmathique = false;
  bool seropositif = false;
  bool autre = false;
  bool autre2 = false;
  int currentstatus = 0;
  List<String> sitmat = [];
  MyItems? situation;

  void _handleRadioValueSit(MyItems value) {
    setState(() {
      situation = value;
    });
  }

  final _decesController = TextEditingController();
  final _pathologieController = TextEditingController();
  final _recentController = TextEditingController();
  final _sportController = TextEditingController();
  final _urinoController = TextEditingController();
  final _chirigucauxController = TextEditingController();
  final _gynicoController = TextEditingController();
  final _professionController = TextEditingController();
  final _autreController = TextEditingController();
  final _autre2Controller = TextEditingController();
  final _allergie1Controller = TextEditingController();
  final _allergie2Controller = TextEditingController();
  final _allergie3Controller = TextEditingController();
  final _allergie4Controller = TextEditingController();
  final _enfantController = TextEditingController();

  bool _isChecked = true;
  bool _isSaving = true;
  Future<List<MyItems>>? sit;

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = [];

    MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Uri.parse(Setting.apiracine +
            "comptes/data?types=" +
            nature.toString() +
            "&language=" +
            mySingleton.getLangue.toString()),
        headers: {"Language": mySingleton.getLangue.toString(),});

    print("DATA2 :" + response.body.toString());

 
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
   
  }

  int _groupValue = -1;
  int _groupValue1 = -1;

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String currentpatient1 = (prefs.getString('currentpatient') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    var res = await http.get(
        Uri.parse(Setting.apiracine + "comptes/donnee2?patient=" + currentpatient1),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA5 :" + res.body.toString());

    sit = getElements("8");

    if (res.statusCode == 200) {
      var responseJson = json.decode(res.body);

      setState(() {
        setState(() {
          if (responseJson["deces"] == null)
            _decesController.text = "";
          else if (responseJson["deces"].toString() != "0") {
            _decesController.text = responseJson["deces"].toString();
          }

          if (responseJson["pathologie"] == null) {
            enable5 = false;
            _pathologieController.text = "";
          } else if (responseJson["pathologie"].toString() != "0") {
            enable5 = true;
            _pathologieController.text = responseJson["pathologie"].toString();
          }

          if (responseJson["recent"] == null) {
            enable6 = false;
            _recentController.text = "";
          } else if (responseJson["recent"].toString() != "0") {
            enable6 = true;
            _recentController.text = responseJson["recent"].toString();
          }

          if (responseJson["chirigucaux"] == null)
            _chirigucauxController.text = "";
          else if (responseJson["chirigucaux"].toString() != "0") {
            _chirigucauxController.text =
                responseJson["chirigucaux"].toString();
          }

          if (responseJson["gyneco"] == null)
            _gynicoController.text = "";
          else if (responseJson["gyneco"].toString() != "0") {
            _gynicoController.text = responseJson["gyneco"].toString();
          }

          if (responseJson["urino"] == null)
            _urinoController.text = "";
          else if (responseJson["urino"].toString() != "0") {
            _urinoController.text = responseJson["urino"].toString();
          }

          if (responseJson["profession"].toString() != "0") {
            _professionController.text = responseJson["profession"].toString();
          }

          if (responseJson["enfant"].toString() != "0") {
            _enfantController.text = responseJson["enfant"] == null
                ? "0"
                : responseJson["enfant"].toString();
          } else if (responseJson["enfant"].toString() == "0") {
            _enfantController.text = responseJson["enfant"] == null
                ? "0"
                : responseJson["enfant"].toString();
          }

          //if (responseJson["sitmat"] != null) {
          setState(() {
            //currentstatus = int.parse(responseJson["sitmat"].toString());
            situation = MyItems.fromJson(responseJson["sitmat"]);
            print("current : " + situation!.libelle.toString());
            _groupValue1 = situation!.id;
          });
          //}

          if (responseJson["tabac"].toString() != "0") {
            tabac = true;
          }

          if (responseJson["sport"].toString() != "0") {
            sport = true;
            _sportController.text = responseJson["sport"].toString();
          }

          if (responseJson["alcool"].toString() != "0") {
            alcool = true;
          }

          if (responseJson["hta"].toString() != "0") {
            hta = true;
          }

          if (responseJson["diabete"].toString() != "0") {
            diabete = true;
          }

          if (responseJson["dysledemie"].toString() != "0") {
            dsylipedemie = true;
          }

          if (responseJson["asmatique"].toString() != "0") {
            asmathique = true;
          }

          if (responseJson["seropositif"].toString() != "0") {
            seropositif = true;
          }

          if (responseJson["autre"].toString() != "0") {
            autre = true;
            _autreController.text = responseJson["autre"].toString();
          }

          if (responseJson["autre2"].toString() != "0") {
            autre2 = true;
            _autre2Controller.text = responseJson["autre2"].toString();
          }

          if (responseJson["alergiealiment"] == null) {
            enable1 = false;
            _allergie1Controller.text = "";
          } else if (responseJson["alergiealiment"].toString() != "0") {
            enable1 = true;
            _allergie1Controller.text =
                responseJson["alergiealiment"].toString();
          }

          if (responseJson["alergiealiment"] == null) {
            enable2 = false;
            _allergie2Controller.text = "";
          } else if (responseJson["alergiemedicament"].toString() != "0") {
            enable2 = true;
            _allergie2Controller.text =
                responseJson["alergiemedicament"].toString();
          }

          if (responseJson["alergiealiment"] == null) {
            enable3 = false;
            _allergie3Controller.text = "";
          } else if (responseJson["alergierespiratoire"].toString() != "0") {
            enable3 = true;
            _allergie3Controller.text =
                responseJson["alergierespiratoire"].toString();
          }

          if (responseJson["alergiealiment"] == null) {
            enable4 = false;
            _allergie4Controller.text = "";
          } else if (responseJson["alergiecutane"].toString() != "0") {
            enable4 = true;
            _allergie4Controller.text =
                responseJson["alergiecutane"].toString();
          }
        });
      });
    }
  }

  void initState() {
    super.initState();

    _loadUser();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _decesController.dispose();
    _pathologieController.dispose();
    _recentController.dispose();
    _sportController.dispose();
    _urinoController.dispose();
    _chirigucauxController.dispose();
    _gynicoController.dispose();
    _professionController.dispose();
    _autreController.dispose();
    _autre2Controller.dispose();
    _allergie1Controller.dispose();
    _allergie2Controller.dispose();
    _allergie3Controller.dispose();
    _allergie4Controller.dispose();
    _enfantController.dispose();
    super.dispose();
  }

  void _submitForms() async {
    String _profession = _professionController.text.toString();
    String _enfant = _enfantController.text.toString();
    String _sitmat = _groupValue1.toString();
    String _sport = sport ? _sportController.text.toString() : "0";

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
      'profession': _profession.isEmpty ? "0" : _profession,
      'enfant': _enfant.isEmpty ? "0" : _enfant,
      'sitmat': _sitmat.isEmpty ? "0" : _sitmat,
      'sport': _sport,
      'types': '1'
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String id = (prefs.getString('id') ?? '');
    String currentpatient1 = (prefs.getString('currentpatient') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    print("DATA5 :" + data.toString());

    var res = await http.put(
        Uri.parse(Setting.apiracine +
            "comptes/antecedent?patient=" +
            currentpatient1 +
            "&user=" +
            id),
        body: data,
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

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
                allTranslations.text('profession_title'),
                style: TextStyle(
                    color: color2,
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0),
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
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  controller: _professionController,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('sit_title'),
                style: TextStyle(
                    color: color2,
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: sit,
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
                          selected: snapshot.data![i].id == situation!.id
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
            CheckboxListTile(
              title: Text(allTranslations.text('sport_title')),
              value: sport,
              onChanged: (newValue) {
                if (newValue!)
                  setState(() {
                    sport = true;
                  });
                else
                  setState(() {
                    sport = false;
                  });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            sport
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                    child: Text(
                      allTranslations.text('precision_title'),
                      style: TextStyle(
                          color: color2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                      textAlign: TextAlign.left,
                    ),
                  )
                : Container(),
            sport
                ? Padding(
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
                        maxLines: null,
                        enabled: sport,
                        keyboardType: TextInputType.text,
                        controller: _sportController,
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('enfant'),
                style: TextStyle(
                    color: color2,
                    fontWeight: FontWeight.normal,
                    fontSize: 16.0),
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
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  controller: _enfantController,
                ),
              ),
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
