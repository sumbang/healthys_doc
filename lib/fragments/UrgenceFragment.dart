import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/Contact.dart';
import 'package:healthys_medecin/pages/HomePage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UrgenceFragment extends StatefulWidget {
  UrgenceFragment();

  @override
  UrgenceFragmentState createState() => new UrgenceFragmentState();
}

class UrgenceFragmentState extends State<UrgenceFragment> {
  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  final _nom1Controller = TextEditingController();
  final _numero1Controller = TextEditingController();
  final _nom2Controller = TextEditingController();
  final _numero2Controller = TextEditingController();
  String codepays2 = "";
  String codepays1 = "";
  String pays1 = "";
  String pays2 = "";
  bool urgence = false;
  Future<List<Contact>> urgent;

  Future<List<Contact>> getUrgence() async {
    List<Contact> liste = List();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String currentpatient1 = (prefs.getString('currentpatient') ?? '');

    String basicAuth = 'Bearer ' + token1;

    print("DATA5 :" + "comptes/urgence?patient=" + currentpatient1);

    var response = await http.get(
        Setting.apiracine + "comptes/urgence?patient=" + currentpatient1,
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA5 :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Contact.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  bool _isChecked = true;
  bool _isSaving = true;

  void _submitForms() async {
    if (_nom1Controller.text.isEmpty || _numero1Controller.text.isEmpty) {
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
        'nom1': _nom1Controller.text.toString(),
        'phone1': _numero1Controller.text.toString(),
        'pays1': pays1,
        'codepays1': codepays1,
        'nom2': _nom2Controller.text.toString(),
        'phone2': _numero2Controller.text.toString(),
        'pays2': pays2,
        'codepays2': codepays2,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');

      String basicAuth = 'Bearer ' + token1;

      var res = await http.put(
          Setting.apiracine + "comptes/urgence1?patient=" + currentpatient1,
          body: data,
          headers: {
            "Authorization": basicAuth,
            "Language": allTranslations.currentLanguage.toString()
          });

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
          new MaterialPageRoute(builder: (_) => new HomePage()),
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

  void initState() {
    super.initState();

    urgent = getUrgence();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return FutureBuilder<List<Contact>>(
        future: urgent,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Container();
          } else if (snapshot.hasData) {
            _nom1Controller.text = snapshot.data[0].nom;
            pays1 = snapshot.data[0].pays;
            _numero1Controller.text = snapshot.data[0].phone;

            if (snapshot.data.length > 1) {
              _nom2Controller.text = snapshot.data[1].nom;
              pays2 = snapshot.data[1].pays;
              _numero2Controller.text = snapshot.data[1].phone;
            } else {
              _nom2Controller.text = "";
              pays2 = "CM";
              _numero2Controller.text = "";
            }

            List<Widget> liste = new List();

            liste.add(new Divider(
              height: 15.0,
              color: Colors.transparent,
            ));

            liste.add(new Text(
              allTranslations.text('urgence_title'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ));

            liste.add(new Divider(
              height: 15.0,
              color: Colors.transparent,
            ));

            liste.add(new Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  obscureText: false,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: new Icon(
                      Icons.person,
                      color: color,
                    ),
                    labelText: allTranslations.text('fullname') + " *",
                    labelStyle: TextStyle(
                        color: color,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    }
                  },
                  keyboardType: TextInputType.text,
                  controller: _nom1Controller,
                ),
              ),
            ));

            liste.add(new SizedBox(
              height: 20.0,
            ));

            liste.add(IntlPhoneField(
              decoration: InputDecoration(
                labelText: allTranslations.text('phone_title') + " *",
                labelStyle: TextStyle(
                    color: color,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
                prefixIcon: new Icon(
                  Icons.phone,
                  color: color,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: pays1,
              controller: _numero1Controller,
              onChanged: (phone) {
                print(phone.completeNumber);
                if (mounted) {
                  _numero1Controller.text = phone.completeNumber.toString();
                  pays1 = phone.countryISOCode.toString();
                  codepays1 = phone.countryCode.toString();
                }
              },
            ));

            liste.add(Divider(
              height: 30.0,
              color: Colors.transparent,
            ));

            liste.add(new Text(
              allTranslations.text('medecin_title'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ));

            liste.add(Divider(
              height: 15.0,
              color: Colors.transparent,
            ));

            liste.add(Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  obscureText: false,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: new Icon(
                      Icons.person,
                      color: color,
                    ),
                    labelText: allTranslations.text('fullname'),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    }
                  },
                  keyboardType: TextInputType.text,
                  controller: _nom2Controller,
                ),
              ),
            ));

            liste.add(SizedBox(
              height: 20.0,
            ));

            liste.add(IntlPhoneField(
              decoration: InputDecoration(
                labelText: allTranslations.text('phone_title'),
                labelStyle: TextStyle(
                    color: color,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
                prefixIcon: new Icon(
                  Icons.phone,
                  color: color,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: pays2,
              controller: _numero2Controller,
              onChanged: (phone) {
                print(phone.completeNumber);
                if (mounted) {
                  _numero2Controller.text = phone.completeNumber.toString();
                  pays2 = phone.countryISOCode.toString();
                  codepays2 = phone.countryCode.toString();
                }
              },
            ));

            liste.add(Divider(
              height: 10.0,
              color: Colors.transparent,
            ));

            liste.add(Padding(
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
                )));

            liste.add(Divider(
              height: 10.0,
              color: Colors.transparent,
            ));

            return new SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: liste,
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
