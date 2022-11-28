import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:healthys_medecin/pages/DossierMedicalPage2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';

class AntecedentPatient extends StatefulWidget {
  String patient;
  AntecedentPatient(this.patient);

  @override
  AntecedentPatient1 createState() => AntecedentPatient1(this.patient);
}

class AntecedentPatient1 extends State<AntecedentPatient> {
  String patient;
  AntecedentPatient1(this.patient);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String decesfamille = "";
  String pathofamille = "";
  String decesrecent = "";
  String medicalist = "";
  String profession = "";
  String famillesituation = "";
  String sportdetails = "";
  String surgical = "";
  String obstetric = "";
  String urino = "";
  String allergies = "";
  String medication = "";
  String respiratoire = "";
  String skin = "";
  String toxico = "";
  String sexe = "";

  String currentpatient = "";
  String token = "";

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = [];

    MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Setting.apiracine +
            "comptes/data?types=" +
            nature.toString() +
            "&language=" +
            mySingleton.getLangue.toString(),
        headers: {"Language": mySingleton.getLangue.toString(),});

    print("DATA :" + response.body.toString());

      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
  
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    print("id : " + this.patient.toString());

    var res = await http.get(
        Setting.apiracine + "comptes/donnee2?patient=" + this.patient,
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA6 :" + res.body.toString());

    if (res.statusCode == 200) {
      var responseJson = json.decode(res.body);

      setState(() {
        setState(() {
          if (responseJson["deces"] == null)
            decesfamille = "";
          else if (responseJson["deces"].toString() != "0") {
            decesfamille = responseJson["deces"].toString();
          }

          if (responseJson["profession"] == null)
            profession = "";
          else if (responseJson["profession"].toString() != "0") {
            profession = responseJson["profession"].toString();
          }

          if (responseJson["pathologie"] == null) {
            pathofamille = "";
          } else if (responseJson["pathologie"].toString() != "0") {
            pathofamille = responseJson["pathologie"].toString();
          }

          if (responseJson["recent"] == null) {
            decesrecent = "";
          } else if (responseJson["recent"].toString() != "0") {
            decesrecent = responseJson["recent"].toString();
          }

          if (responseJson["chirigucaux"] == null)
            surgical = "";
          else if (responseJson["chirigucaux"].toString() != "0") {
            surgical = responseJson["chirigucaux"].toString();
          }

          if (responseJson["gyneco"] == null)
            obstetric = "";
          else if (responseJson["gyneco"].toString() != "0") {
            obstetric = responseJson["gyneco"].toString();
          }

          if (responseJson["urino"] == null)
            urino = "";
          else if (responseJson["urino"].toString() != "0") {
            urino = responseJson["urino"].toString();
          }

          if (responseJson["tabac"] == null) {
          } else if (responseJson["tabac"].toString() != "0") {
            toxico += "Tabac : "+responseJson["tabac"].toString()+", ";
          }

          if (responseJson["alcool"] == null) {
          } else if (responseJson["alcool"].toString() != "0") {
            toxico += "Alcool : "+responseJson["alcool"].toString() +", ";
          }

          if (responseJson["hta"] == null) {
          } else if (responseJson["hta"].toString() != "0") {
            medicalist += "HTA (Hypertension Arterielle) : "+responseJson["hta"].toString()+", ";
          }

          if (responseJson["diabete"] == null) {
          } else if (responseJson["diabete"].toString() != "0") {
            medicalist += "Diabète : "+responseJson["diabete"].toString() +", ";
          }

          if (responseJson["dysledemie"] == null) {
          } else if (responseJson["dysledemie"].toString() != "0") {
            medicalist += "Dyslipidémie : "+responseJson["dysledemie"].toString()+", ";
          }

          if (responseJson["asmatique"] == null) {
          } else if (responseJson["asmatique"].toString() != "0") {
            medicalist += "Asméthique : "+responseJson["asmatique"].toString()+", ";
          }

          if (responseJson["seropositif"] == null) {
          } else if (responseJson["seropositif"].toString() != "0") {
            medicalist += "Séropositif : "+responseJson["seropositif"].toString()+", ";
          }

          if (responseJson["autre"] == null) {
          } else if (responseJson["autre"].toString() != "0") {
            medicalist += responseJson["autre"].toString() + ", ";
          }

          if (responseJson["autre2"] == null) {
          } else if (responseJson["autre2"].toString() != "0") {
            toxico += responseJson["autre2"].toString();
          }

          if (responseJson["alergiealiment"] == null) {
          } else if (responseJson["alergiealiment"].toString() != "0") {
            allergies = responseJson["alergiealiment"].toString();
          }

          if (responseJson["alergiemedicament"] == null) {
          } else if (responseJson["alergiemedicament"].toString() != "0") {
            medication = responseJson["alergiemedicament"].toString();
          }

          if (responseJson["alergierespiratoire"] == null) {
          } else if (responseJson["alergierespiratoire"].toString() != "0") {
            respiratoire = responseJson["alergierespiratoire"].toString();
          }

          if (responseJson["alergiecutane"] == null) {
          } else if (responseJson["alergiecutane"].toString() != "0") {
            skin = responseJson["alergiecutane"].toString();
          }

          if (responseJson["sitmat"] == null) {}
          {
            sexe = responseJson["sitmat"]["libelle"].toString();
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(allTranslations.text("z41")),
              backgroundColor: color,
              elevation: 0,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new DossierMedicalPage2(this.patient)),
                  );
                },
              ),
            ),
            backgroundColor: Colors.white.withOpacity(1.0),
            body: SingleChildScrollView(
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
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent2_title').toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: Divider(
                          height: 1.0,
                          color: Colors.blueGrey,
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          decesfamille,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent4_title'),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          decesrecent,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent5_title'),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          decesrecent,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Divider(
                      height: 20.0,
                      color: Colors.transparent,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent_title').toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: Divider(
                          height: 1.0,
                          color: Colors.blueGrey,
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        "Précisions",
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          medicalist,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('vie_title'),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: Divider(
                          height: 1.0,
                          color: Colors.blueGrey,
                        )),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          profession,
                          style: TextStyle(color: Colors.black),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          sexe,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('sport_title'),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          sportdetails,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent7_title').toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          surgical,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent8_title').toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        width: double.infinity,
                        child: Text(
                          obstetric,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent9_title').toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          urino,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent10_title').toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent11_title'),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          allergies,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent12_title'),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          medication,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent13_title'),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          respiratoire,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('antecedent14_title'),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          skin,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        allTranslations.text('toxico_title').toUpperCase(),
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: double.infinity,
                        child: Text(
                          toxico,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Divider(
                      height: 80.0,
                      color: Colors.transparent,
                    ),
                  ]),
            ))));
  }
}
