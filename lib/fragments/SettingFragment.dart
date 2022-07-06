import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Compte.dart';
import 'package:healthys_medecin/models/Souscription.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class SettingFragment extends StatefulWidget {
  SettingFragment();

  @override
  SettingFragmentState createState() => new SettingFragmentState();
}

class SettingFragmentState extends State<SettingFragment> {
  SettingFragmentState();

  String codeuser = "";
  String roleuser = "";
  String nomuser = "";
  String token = "";
  bool _isSaving = true;
  List<String> ids;
  List<String> noms;
  List<String> patients;
  String currentid = "1";
  String currentpatient = "";
  String currentacces = "";
  String username = "";
  String currentnom = "";
  String currentpin = "";
  String currentphoto = "";
  Future<Compte> profil;
  Future<List<Souscription>> souscriptions;

  Future<Compte> getCompte() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String compte = (prefs.getString('id') ?? '');
    String profil = (prefs.getString('currentid') ?? '');
    String role = (prefs.getString('role') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Setting.apiracine +
            "comptes/profil?compte=" +
            compte +
            "&profil=" +
            profil +
            "&role=" +
            role,
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      setState(() {
        _loginController.text = responseJson["login"].toString();
        _pwdController.text = "********";
        _pinController.text = "****";
        _nameController.text = responseJson["nom"].toString();
        _countryController.text = responseJson["paysnom"].toString();
        _villeController.text = responseJson["ville"].toString();
        _addressController.text = responseJson["quartier"].toString();
      });
      return Compte.fromJson(responseJson);
    }

    return null;
  }

  Future<List<Souscription>> getSouscriptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    var response =
        await http.get(Setting.apiracine + "comptes/souscription", headers: {
      "Authorization": basicAuth,
      "Language": mySingleton.getLangue.toString(),
    });

    print("DATA : " + response.body.toString());
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      return List<Souscription>.from(
          responseJson.map((x) => Souscription.fromJson(x)));
    }

    return null;
  }

  List<Widget> SouscriptionItem(
      List<Souscription> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = new List<Widget>();

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Souscription item = maliste[i];

        var listItem = new Container(
          padding: EdgeInsets.all(0.0),
          width: double.infinity,
          margin: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                Setting.serveurimage + '' + item.photo))),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(item.nom.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: color2)),
                      ),
                      Divider(
                        height: 1.0,
                        color: Colors.transparent,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0, top: 2.0),
                        child: Text("Matricule : " + item.numero,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.black)),
                      ),
                      Divider(
                        height: 1.0,
                        color: Colors.transparent,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0, top: 2.0),
                        child: Text("Abonnement : " + item.libelle,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.black)),
                      ),
                      Divider(
                        height: 1.0,
                        color: Colors.transparent,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0, top: 2.0),
                        child: Text("Début : " + item.debut,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.black)),
                      ),
                      Divider(
                        height: 1.0,
                        color: Colors.transparent,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0, top: 2.0),
                        child: Text("Fin : " + item.fin,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.black)),
                      ),
                      Divider(
                        height: 1.0,
                        color: Colors.transparent,
                      ),
                      item.statut.toString() == "0"
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: new Center(
                                child: new InkWell(
                                  onTap: () {},
                                  child: new Container(
                                    width: 250.0,
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
                                        allTranslations.text('sous'),
                                        style: new TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          : Container()
                    ],
                  ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Divider(height: 5.0, color: color2),
              )
            ],
          ),
        );

        listElementWidgetList.add(listItem);
      }
    }

    return listElementWidgetList;
  }

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);
  final _loginController = TextEditingController();
  final _pwdController = TextEditingController();
  final _pinController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _villeController = TextEditingController();
  final _addressController = TextEditingController();

  void initState() {
    super.initState();
    profil = getCompte();
    souscriptions = getSouscriptions();
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return FutureBuilder(
        future: Future.wait([profil, souscriptions]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                        Text(allTranslations.text('erreur_title'),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.black)),
                      ],
                    )),
                  );
                } else {
                  return new Stack(
                    children: [
                      Container(
                        color: color,
                        height: 190,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 10.0, right: 10.0, top: 15),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                Setting.serveurimage +
                                                    '' +
                                                    snapshot.data[0].profil
                                                        .photo))),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        snapshot.data[0].nom,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Membre depuis le " +
                                            snapshot.data[0].date,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Sexe : " + snapshot.data[0].sexenom,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            top: 150,
                          ),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    topLeft: Radius.circular(30.0),
                                  )),
                              child: SingleChildScrollView(
                                  child: Column(children: <Widget>[
                                SizedBox(
                                  height: 5.0,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15.0, top: 10),
                                    child: Center(
                                      child: Text(
                                        allTranslations.text('souscription'),
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                    )),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15.0, top: 10),
                                    child: Column(
                                        children: SouscriptionItem(
                                            snapshot.data[1], context))),
                              ]))))
                    ],
                  );
                }
              }

              return Text('Result1: ${snapshot.data}');
            // You can reach your snapshot.data['url'] in here
          }

          return null;
        });
  }
}
