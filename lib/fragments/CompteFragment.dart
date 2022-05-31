import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/Compte.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class CompteFragment extends StatefulWidget {
  CompteFragment();

  @override
  CompteFragmentState createState() => new CompteFragmentState();
}

class CompteFragmentState extends State<CompteFragment> {
  CompteFragmentState();

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
  bool _isChecked = false;
  bool isSwitched = false;

  Future<Compte> getCompte() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String compte = (prefs.getString('id') ?? '');
    String profil = (prefs.getString('currentid') ?? '');
    String role = (prefs.getString('role') ?? '');

    String basicAuth = 'Bearer ' + token1;

    Locale myLocale = Localizations.localeOf(context);

    print("profil : " + profil + ", compte : " + compte);

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
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA4 :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      setState(() {
        _loginController.text = responseJson["login"].toString();
        _pwdController.text = "********";
        _pinController.text = responseJson["profil"]["pin"].toString();
        _nameController.text = responseJson["nom"].toString();
        _countryController.text = responseJson["paysnom"].toString();
        _villeController.text = responseJson["ville"].toString();
        _addressController.text = responseJson["quartier"].toString();

        if (responseJson["biometrie"] == "0") {
          isSwitched = false;
        } else {
          isSwitched = true;
        }
      });

      return Compte.fromJson(responseJson);
    }

    return null;
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
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return FutureBuilder<Compte>(
        future: profil, //new
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                  var d = snapshot.data.date.toString().split("-");
                  String truedate = d[2].toString() +
                      "-" +
                      d[1].toString() +
                      "-" +
                      d[0].toString();

                  return new Stack(
                    children: [
                      Container(
                        color: color,
                        height: 140,
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
                                            image: NetworkImage(Setting
                                                    .serveurimage +
                                                '' +
                                                snapshot.data.profil.photo))),
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
                                        snapshot.data.nom,
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
                                        allTranslations.text("z35")+" " + truedate,
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
                                        allTranslations.text("z36")+" : " + snapshot.data.sexenom,
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
                            top: 100,
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
                                        allTranslations.text('menu25_title'),
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                    )),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 5.0,
                                        top: 3.0,
                                        bottom: 3.0),
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border:
                                          new Border.all(color: Colors.black38),
                                    ),
                                    child: TextFormField(
                                      obscureText: false,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: new Icon(
                                          Icons.card_membership,
                                          color: color,
                                        ),
                                        labelText:
                                            allTranslations.text('login_title'),
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return allTranslations.text("requis_title");
                                        }
                                      },
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _loginController,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 5.0,
                                        top: 3.0,
                                        bottom: 3.0),
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border:
                                          new Border.all(color: Colors.black38),
                                    ),
                                    child: TextFormField(
                                      obscureText: false,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: new Icon(
                                          Icons.security,
                                          color: color,
                                        ),
                                        labelText: allTranslations.text('s2'),
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return allTranslations.text("requis_title");
                                        }
                                      },
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _pinController,
                                    ),
                                  ),
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                          child: Switch(
                                        value: isSwitched,
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitched = value;
                                          });
                                        },
                                        activeTrackColor: Colors.grey,
                                        activeColor: color,
                                      )),
                                      Flexible(
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 14.0),
                                              child: Text(
                                                  allTranslations
                                                      .text('biometrique'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                      color: color2))))
                                    ]),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: new Center(
                                          child: new InkWell(
                                            onTap: () {},
                                            child: new Container(
                                              width: 250.0,
                                              height: 50.0,
                                              decoration: new BoxDecoration(
                                                color: color,
                                                border: new Border.all(
                                                    color: Colors.white,
                                                    width: 2.0),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                              child: new Center(
                                                child: new Text(
                                                  allTranslations.text('pass'),
                                                  style: new TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: new Center(
                                          child: new InkWell(
                                            onTap: () {},
                                            child: new Container(
                                              width: 130.0,
                                              height: 50.0,
                                              decoration: new BoxDecoration(
                                                color: color2,
                                                border: new Border.all(
                                                    color: Colors.white,
                                                    width: 2.0),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                              child: new Center(
                                                child: new Text(
                                                  allTranslations.text('edit'),
                                                  style: new TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 15.0, top: 30),
                                    child: Center(
                                      child: Text(
                                        allTranslations.text('menu4_title'),
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 5.0,
                                        top: 3.0,
                                        bottom: 3.0),
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border:
                                          new Border.all(color: Colors.black38),
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
                                        labelText:
                                            allTranslations.text('nom_title') +
                                                " *",
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return allTranslations.text("requis_title");
                                        }
                                      },
                                      enabled: _isChecked,
                                      keyboardType: TextInputType.text,
                                      controller: _nameController,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 5.0,
                                        top: 3.0,
                                        bottom: 3.0),
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border:
                                          new Border.all(color: Colors.black38),
                                    ),
                                    child: TextFormField(
                                      obscureText: false,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: new Icon(
                                          Icons.map,
                                          color: color,
                                        ),
                                        labelText:
                                            allTranslations.text('ville_title'),
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return allTranslations.text("requis_title");
                                        }
                                      },
                                      enabled: _isChecked,
                                      keyboardType: TextInputType.text,
                                      controller: _villeController,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 5.0,
                                        top: 3.0,
                                        bottom: 3.0),
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border:
                                          new Border.all(color: Colors.black38),
                                    ),
                                    child: TextFormField(
                                      obscureText: false,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: new Icon(
                                          Icons.place,
                                          color: color,
                                        ),
                                        labelText: allTranslations
                                            .text('adresse_title'),
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return allTranslations.text("requis_title");
                                        }
                                      },
                                      enabled: _isChecked,
                                      keyboardType: TextInputType.text,
                                      controller: _addressController,
                                    ),
                                  ),
                                ),
                                CheckboxListTile(
                                  title: Text(allTranslations.text('edit1'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: color2)),
                                  value: _isChecked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _isChecked = newValue;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: new Center(
                                      child: new InkWell(
                                        onTap: () {},
                                        child: new Container(
                                          width: 250.0,
                                          height: 50.0,
                                          decoration: new BoxDecoration(
                                            color: color,
                                            border: new Border.all(
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          child: new Center(
                                            child: new Text(
                                              allTranslations
                                                  .text('save_title'),
                                              style: new TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
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
