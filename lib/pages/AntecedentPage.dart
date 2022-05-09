import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/models/Items.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AntecedentPage extends StatefulWidget {
  String patient;
  AntecedentPage(this.patient);

  @override
  AntecedentPage1 createState() => AntecedentPage1(this.patient);
}

class AntecedentPage1 extends State<AntecedentPage> {
  String patient;
  AntecedentPage1(this.patient);

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
  String currentstatus;
  List<String> sitmat = new List();
  MyItems situation;
  String masituation;

  final _diabeteController = TextEditingController();
  final _htaController = TextEditingController();
  final _dsylipedmieController = TextEditingController();
  final _asmeController = TextEditingController();
  final _vihController = TextEditingController();
  final _tabacController = TextEditingController();
  final _alcoolController = TextEditingController();

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

  bool _isChecked = true;
  bool _isSaving = true;

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = List();

    Locale myLocale = Localizations.localeOf(context);

    var response = await http.get(
        Setting.apiracine +
            "comptes/data?types=" +
            nature.toString() +
            "&language=" +
            myLocale.languageCode.toString(),
        headers: {"Language": allTranslations.currentLanguage.toString()});

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

  _loadUser() async {


      Fluttertoast.showToast(
          msg: "Chargeement des donnees...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white);

    sitmat.add("Marié(e)");
    sitmat.add("Célibaraire");
    sitmat.add("Divorcé(e)");
    sitmat.add("Veuf/Veuve");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    print("patient : "+this.patient.toString());

    var res = await http.get(
        Setting.apiracine + "comptes/donnee2?patient=" + this.patient,
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA5 :" + res.body.toString());

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
          } else {
            enable5 = false;
            _pathologieController.text = "";
          }

          if (responseJson["recent"] == null) {
            enable6 = false;
            _recentController.text = "";
          } else if (responseJson["recent"].toString() != "0") {
            enable6 = true;
            _recentController.text = responseJson["recent"].toString();
          } else {
            enable6 = false;
            _recentController.text = "";
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

          if (responseJson["tabac"] == null) {
            tabac = false;
            _tabacController.text = "";
          } else if (responseJson["tabac"].toString() != "0") {
            tabac = true;
            _tabacController.text = responseJson["tabac"].toString();
          } else {
            tabac = false;
            _tabacController.text = "";
          }

          if (responseJson["alcool"] == null) {
            alcool = false;
            _alcoolController.text = "";
          } else if (responseJson["alcool"].toString() != "0") {
            alcool = true;
            _alcoolController.text = responseJson["alcool"].toString();
          } else {
            alcool = false;
            _alcoolController.text = "";
          }

          if (responseJson["hta"] == null) {
            hta = false;
            _htaController.text = "";
          } else if (responseJson["hta"].toString() != "0") {
            hta = true;
            _htaController.text = responseJson["hta"].toString();
          } else {
            hta = false;
            _htaController.text = "";
          }

          if (responseJson["diabete"] == null) {
            diabete = false;
            _diabeteController.text = "";
          } else if (responseJson["diabete"].toString() != "0") {
            diabete = true;
            _diabeteController.text = responseJson["diabete"].toString();
          } else {
            diabete = false;
            _diabeteController.text = "";
          }

          if (responseJson["dysledemie"] == null) {
            dsylipedemie = false;
            _dsylipedmieController.text = "";
          } else if (responseJson["dysledemie"].toString() != "0") {
            dsylipedemie = true;
            _dsylipedmieController.text = responseJson["dysledemie"].toString();
          } else {
            dsylipedemie = false;
            _dsylipedmieController.text = "";
          }

          if (responseJson["asmatique"] == null) {
            asmathique = false;
            _asmeController.text = "";
          } else if (responseJson["asmatique"].toString() != "0") {
            asmathique = true;
            _asmeController.text = responseJson["asmatique"].toString();
          } else {
            asmathique = false;
            _asmeController.text = "";
          }

          if (responseJson["seropositif"] == null) {
            seropositif = false;
            _vihController.text = "";
          } else if (responseJson["seropositif"].toString() != "0") {
            seropositif = true;
            _vihController.text = responseJson["seropositif"].toString();
          } else {
            seropositif = false;
            _vihController.text = "";
          }

          if (responseJson["autre"] == null) {
            autre = false;
            _autreController.text = "";
          } else if (responseJson["autre"].toString() != "0") {
            autre = true;
            _autreController.text = responseJson["autre"].toString();
          } else {
            autre = false;
            _autreController.text = "";
          }

          if (responseJson["autre2"] == null) {
            autre2 = false;
            _autre2Controller.text = "";
          } else if (responseJson["autre2"].toString() != "0") {
            autre2 = true;
            _autre2Controller.text = responseJson["autre2"].toString();
          } else {
            autre2 = false;
            _autre2Controller.text = "";
          }

          if (responseJson["alergiealiment"] == null) {
            enable1 = false;
            _allergie1Controller.text = "";
          } else if (responseJson["alergiealiment"].toString() != "0") {
            enable1 = true;
            _allergie1Controller.text =
                responseJson["alergiealiment"].toString();
          } else {
            enable1 = false;
            _allergie1Controller.text = "";
          }

          if (responseJson["alergiealiment"] == null) {
            enable2 = false;
            _allergie2Controller.text = "";
          } else if (responseJson["alergiemedicament"].toString() != "0") {
            enable2 = true;
            _allergie2Controller.text =
                responseJson["alergiemedicament"].toString();
          } else {
            enable2 = false;
            _allergie2Controller.text = "";
          }

          if (responseJson["alergiealiment"] == null) {
            enable3 = false;
            _allergie3Controller.text = "";
          } else if (responseJson["alergierespiratoire"].toString() != "0") {
            enable3 = true;
            _allergie3Controller.text =
                responseJson["alergierespiratoire"].toString();
          } else {
            enable3 = false;
            _allergie3Controller.text = "";
          }

          if (responseJson["alergiealiment"] == null) {
            enable4 = false;
            _allergie4Controller.text = "";
          } else if (responseJson["alergiecutane"].toString() != "0") {
            enable4 = true;
            _allergie4Controller.text =
                responseJson["alergiecutane"].toString();
          } else {
            enable4 = false;
            _allergie4Controller.text = "";
          }
        });
      });
    }

         Fluttertoast.showToast(
          msg: allTranslations.text("z39"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white);

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
    _diabeteController.dispose();
    _htaController.dispose();
    _dsylipedmieController.dispose();
    _asmeController.dispose();
    _vihController.dispose();
    _tabacController.dispose();
    _alcoolController.dispose();

    super.dispose();
  }

  void _submitForms() async {
    String _deces = _decesController.text.toString();
    String _pathologie = enable5 ? _pathologieController.text.toString() : "0";
    String _recent = enable6 ? _recentController.text.toString() : "0";
    String _urino = _urinoController.text.toString();
    String _chirigucaux = _chirigucauxController.text.toString();
    String _gynico = _gynicoController.text.toString();
    //String _profession = _professionController.text.toString();
    // String _sitmat = situation.id.toString();
    String _tabac = tabac ? _tabacController.text.toString() : "0";
    String _alcool = alcool ? _alcoolController.text.toString() : "0";
    String _hta = hta ? _htaController.text.toString() : "0";
    String _diabete = diabete ? _diabeteController.text.toString() : "0";
    String _dsylipedemie =
        dsylipedemie ? _dsylipedmieController.text.toString() : "0";
    String _asmathique = asmathique ? _asmeController.text.toString() : "0";
    String _seroposifit = seropositif ? _vihController.text.toString() : "0";
    String _autre = autre ? _autreController.text.toString() : "0";
    String _autre2 = autre2 ? _autre2Controller.text.toString() : "0";
    //String _sport = sport? _sportController.text.toString():"0";
    String _alergie1 = enable1 ? _allergie1Controller.text.toString() : "0";
    String _alergie2 = enable2 ? _allergie2Controller.text.toString() : "0";
    String _alergie3 = enable3 ? _allergie3Controller.text.toString() : "0";
    String _alergie4 = enable4 ? _allergie4Controller.text.toString() : "0";

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
      'deces': _deces.isEmpty ? "0" : _deces,
      'pathologie': _pathologie.isEmpty ? "0" : _pathologie,
      'recent': _recent.isEmpty ? "0" : _recent,
      'urino': _urino.isEmpty ? "0" : _urino,
      'chirigucaux': _chirigucaux.isEmpty ? "0" : _chirigucaux,
      'gyneco': _gynico.isEmpty ? "0" : _gynico,
      // 'profession': _profession.isEmpty?"0":_profession,
      //  'sitmat': _sitmat.isEmpty?"0":_sitmat,
      'tabac': _tabac.isEmpty ? "0" : _tabac,
      // 'sport': _sport,
      'alcool': _alcool.isEmpty ? "0" : _alcool,
      'hta': _hta.isEmpty ? "0" : _hta,
      'diabete': _diabete.isEmpty ? "0" : _diabete,
      'dysledemie': _dsylipedemie.isEmpty ? "0" : _dsylipedemie,
      'asmatique': _asmathique.isEmpty ? "0" : _asmathique,
      'seropositif': _seroposifit.isEmpty ? "0" : _seroposifit,
      'autre': _autre.isEmpty ? "0" : _autre,
      'alergiealiment': _alergie1.isEmpty ? "0" : _alergie1,
      'alergiemedicament': _alergie2.isEmpty ? "0" : _alergie2,
      'alergierespiratoire': _alergie3.isEmpty ? "0" : _alergie3,
      'alergiecutane': _alergie4.isEmpty ? "0" : _alergie4,
      'autre2': _autre2.isEmpty ? "0" : _autre2,
      'types': '2',
      'patient': this.patient
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    print("DATA4 :" + data.toString());

    var res = await http.put(Setting.apiracine + "comptes/antecedent",
        body: data, headers: {"Authorization": basicAuth});

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
                    // TODO: implement build
                    return SingleChildScrollView(
                        child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Divider(
                              height: 40,
                              color: Colors.transparent,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('antecedent2_title'),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20.0,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                child: Divider(
                                  height: 1.0,
                                  color: Colors.blueGrey,
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('antecedent3_title'),
                                style: TextStyle(
                                    color: color2,
                                    fontWeight: FontWeight.bold,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
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
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  controller: _decesController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                allTranslations.text('antecedent4_title'),
                                style: TextStyle(color: color),
                              ),
                              value: enable5,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    enable5 = true;
                                  });
                                else
                                  setState(() {
                                    enable5 = false;
                                    _pathologieController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: "Précision",
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: enable5,
                                  controller: _pathologieController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                allTranslations.text('antecedent5_title'),
                                style: TextStyle(color: color),
                              ),
                              value: enable6,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    enable6 = true;
                                  });
                                else
                                  setState(() {
                                    enable6 = false;
                                    _recentController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: "Précision",
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: enable6,
                                  controller: _recentController,
                                ),
                              ),
                            ),
                            Divider(
                              height: 20.0,
                              color: Colors.transparent,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('antecedent_title'),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20.0,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                child: Divider(
                                  height: 1.0,
                                  color: Colors.blueGrey,
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('antecedent6_title'),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico6_title')),
                              value: hta,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    hta = true;
                                  });
                                else
                                  setState(() {
                                    hta = false;
                                    _htaController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: "Précision",
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: hta,
                                  controller: _htaController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico7_title')),
                              value: diabete,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    diabete = true;
                                  });
                                else
                                  setState(() {
                                    diabete = false;
                                    _diabeteController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: "Précision",
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: diabete,
                                  controller: _diabeteController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico8_title')),
                              value: dsylipedemie,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    dsylipedemie = true;
                                  });
                                else
                                  setState(() {
                                    dsylipedemie = false;
                                    _dsylipedmieController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: "Précision",
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: dsylipedemie,
                                  controller: _dsylipedmieController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico9_title')),
                              value: asmathique,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    asmathique = true;
                                  });
                                else
                                  setState(() {
                                    asmathique = false;
                                    _asmeController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: "Précision",
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: asmathique,
                                  controller: _asmeController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico10_title')),
                              value: seropositif,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    seropositif = true;
                                  });
                                else
                                  setState(() {
                                    seropositif = false;
                                    _vihController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: "Précision",
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: seropositif,
                                  controller: _vihController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico3_title')),
                              value: autre,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    autre = true;
                                  });
                                else
                                  setState(() {
                                    autre = false;
                                    _autreController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: "Précision",
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: autre,
                                  controller: _autreController,
                                ),
                              ),
                            ),

                            /*   Padding(
                                  padding: EdgeInsets.only(left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                                  child: Text(allTranslations.text('vie_title'), style: TextStyle(color: color, fontWeight: FontWeight.normal, fontSize: 16.0), textAlign: TextAlign.left,),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                                  child: Text(allTranslations.text('profession_title'), style: TextStyle(color: color2, fontWeight: FontWeight.normal, fontSize: 16.0), textAlign: TextAlign.left,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(3.0),
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius:BorderRadius.all(Radius.circular(10.0)),
                                      border: new Border.all(color: Colors.black38),

                                    ),
                                    child:  TextFormField(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal
                                      ),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.normal),
                                          contentPadding: const EdgeInsets.all(15.0)
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.text,
                                      controller: _professionController,
                                    ),
                                  ),

                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                                  child: Text(allTranslations.text('sit_title'), style: TextStyle(color: color2, fontWeight: FontWeight.normal, fontSize: 16.0), textAlign: TextAlign.left,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                                  child: FutureBuilder<List<MyItems>>(
                                      future: getElements("8"),
                                      builder: (context, snapshot) {

                                        print(snapshot.toString());

                                        if (snapshot.hasError) {

                                          return new Container();

                                        } else if (snapshot.hasData) {

                                          if(situation == null) {
                                            situation = snapshot.data.elementAt(0);
                                          }

                                          /* for(int i = 0; i < snapshot.data.length; i++) {
                            if((snapshot.data.elementAt(i).id.toString() == currentstatus) ) situation = snapshot.data.elementAt(i);
                          }*/

                                          return Container(
                                            padding: const EdgeInsets.all(12.0),
                                            width: double.infinity,
                                            child: DropdownButton<MyItems>(
                                              value: snapshot.data.firstWhere((e) => e.id == situation.id ,
                                                  orElse: () => snapshot.data.first),
                                              onChanged: (MyItems value) => setState(() {
                                                situation = value;
                                              }),
                                              items: snapshot.data
                                                  .map((designation) => DropdownMenuItem<MyItems>(
                                                child: Text(designation.libelle),
                                                value: designation,
                                              )) .toList(),

                                            ),

                                          );


                                        }

                                        else {
                                          return CircularProgressIndicator();
                                        }
                                      }
                                  ),
                                ),
                                CheckboxListTile(
                                  title: Text(allTranslations.text('sport_title')),
                                  value: sport,
                                  onChanged: (newValue) {
                                    if(newValue) setState(() {
                                      sport = true;
                                    });

                                    else setState(() {
                                      sport = false;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                                  child: Text(allTranslations.text('precision_title'), style: TextStyle(color: color2, fontWeight: FontWeight.bold, fontSize: 16.0), textAlign: TextAlign.left,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(3.0),
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius:BorderRadius.all(Radius.circular(10.0)),
                                      border: new Border.all(color: Colors.black38),

                                    ),
                                    child:  TextFormField(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal
                                      ),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0, fontWeight: FontWeight.normal),
                                          contentPadding: const EdgeInsets.all(15.0)
                                      ),
                                      maxLines: null,
                                      enabled: sport,
                                      keyboardType: TextInputType.text,
                                      controller: _sportController,
                                    ),
                                  ),

                                ), */
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('antecedent7_title'),
                                style: TextStyle(
                                    color: color,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
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
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  controller: _chirigucauxController,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('antecedent8_title'),
                                style: TextStyle(
                                    color: color,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
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
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  controller: _gynicoController,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('antecedent9_title'),
                                style: TextStyle(
                                    color: color,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
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
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  controller: _urinoController,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('antecedent10_title'),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                  allTranslations.text('antecedent11_title')),
                              value: enable1,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    enable1 = true;
                                  });
                                else
                                  setState(() {
                                    enable1 = false;
                                    _allergie1Controller.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: allTranslations.text("z40"),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: enable1,
                                  controller: _allergie1Controller,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                  allTranslations.text('antecedent12_title')),
                              value: enable2,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    enable2 = true;
                                  });
                                else
                                  setState(() {
                                    enable2 = false;
                                    _allergie2Controller.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText:allTranslations.text("z40"),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: enable2,
                                  controller: _allergie2Controller,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                  allTranslations.text('antecedent13_title')),
                              value: enable3,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    enable3 = true;
                                  });
                                else
                                  setState(() {
                                    enable3 = false;
                                    _allergie3Controller.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText:allTranslations.text("z40"),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: enable3,
                                  controller: _allergie3Controller,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                  allTranslations.text('antecedent14_title')),
                              value: enable4,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    enable4 = true;
                                  });
                                else
                                  setState(() {
                                    enable4 = false;
                                    _allergie4Controller.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: allTranslations.text("z40"),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: enable4,
                                  controller: _allergie4Controller,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 8.0,
                                  top: 8.0,
                                  bottom: 8.0),
                              child: Text(
                                allTranslations.text('toxico_title'),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico1_title')),
                              value: tabac,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    tabac = true;
                                  });
                                else
                                  setState(() {
                                    tabac = false;
                                    _tabacController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: allTranslations.text("z40"),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: tabac,
                                  controller: _tabacController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico2_title')),
                              value: alcool,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    alcool = true;
                                  });
                                else
                                  setState(() {
                                    alcool = false;
                                    _alcoolController.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: allTranslations.text("z40"),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: alcool,
                                  controller: _alcoolController,
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              title:
                                  Text(allTranslations.text('toxico3_title')),
                              value: autre2,
                              onChanged: (newValue) {
                                if (newValue)
                                  setState(() {
                                    autre2 = true;
                                  });
                                else
                                  setState(() {
                                    autre2 = false;
                                    _autre2Controller.text = "";
                                  });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(3.0),
                                width: double.infinity,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  decoration: InputDecoration(
                                      labelText: allTranslations.text("z40"),
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                      contentPadding:
                                          const EdgeInsets.all(15.0)),
                                  maxLines: null,
                                  keyboardType: TextInputType.text,
                                  enabled: autre2,
                                  controller: _autre2Controller,
                                ),
                              ),
                            ),
                            Divider(
                              height: 80.0,
                              color: Colors.transparent,
                            ),
                          ]),
                    ));
                  }),
                ),
                Positioned(
                    bottom: 20,
                    left: 20,
                    //height: 75,
                    /*child: new IconButton(
                      icon: new Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ) */
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: new Container(
                            width: 170.0,
                            height: 50.0,
                            decoration: new BoxDecoration(
                              color: color2,
                              border: new Border.all(
                                  color: Colors.white, width: 2.0),
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            child: new Center(
                              child: new Text(
                                'FERMER',
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        new InkWell(
                          onTap: _submitForms,
                          child: new Container(
                            width: 170.0,
                            height: 50.0,
                            decoration: new BoxDecoration(
                              color: color,
                              border: new Border.all(
                                  color: Colors.white, width: 2.0),
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            child: new Center(
                              child: new Text(
                                allTranslations
                                    .text('save_title')
                                    .toUpperCase(),
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            )));
  }
}
