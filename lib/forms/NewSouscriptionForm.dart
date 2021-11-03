import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewSouscriptionForm extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<NewSouscriptionForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  final _codeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _pinController = TextEditingController();

  bool visible = false;
  String code = "";
  bool _isSaving = true;
  String currentpin = "";
  String currentpatient = "";
  bool isVisible = true;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _codeController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      currentpin = (prefs.getString('currentpin') ?? '');
      currentpatient = (prefs.getString('currentpatient') ?? '');
    });
  }

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = List();

    var response = await http.get(
        Setting.apiracine + "comptes/data?types=" + nature.toString(),
        headers: {"Language": allTranslations.currentLanguage.toString()});

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  _makeReset() async {
    String matricule = _numeroController.text.toString();
    String pin = _pinController.text.toString();
    String code1 = _codeController.text.toString();

    if (code1 != code) {
      Fluttertoast.showToast(
          msg: "Code de confirmation incorrect",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (pin != currentpin) {
      Fluttertoast.showToast(
          msg: "Pin d'authentification incorrect",
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

      setState(() {
        _isSaving = false;
      });

      // if (_imageFile == null) {
      Map data = {
        'parent': currentpatient.toString(),
        'fils': _numeroController.text.toString(),
        'photo': ''
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token1 = (prefs.getString('token') ?? '');

      String basicAuth = 'Bearer ' + token1;

      var res = await http
          .post(Setting.apiracine + "comptes/jointure", body: data, headers: {
        "Language": allTranslations.currentLanguage.toString(),
        "Authorization": basicAuth,
      });

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

      /* } 
      
      else {
        tmpFile = File(_imageFile.path);

        base64Image = base64Encode(tmpFile.readAsBytesSync());

        String fileName = tmpFile.path.split('/').last;

        String ext = lookupMimeType(tmpFile.path).split('/').last;

        Map data = {
          "image": base64Image,
          "name": ext,
        };

        var res1 =
            await http.post(Setting.apiracine + "comptes/uploader", body: data);

        print("retour : " + res1.body.toString());

        if (res1.statusCode == 200) {
          var response1Json = json.decode(res1.body);

          Map data = {
            'parent': currentpatient.toString(),
            'fils': _numeroController.text.toString(),
            'filiation': filiation.id.toString(),
            'photo': response1Json['path']
          };

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token1 = (prefs.getString('token') ?? '');

          String basicAuth = 'Bearer ' + token1;

          var res = await http.post(Setting.apiracine + "comptes/jointure",
              body: data,
              headers: {
                "Language": allTranslations.currentLanguage.toString(),
                "Authorization": basicAuth,
              });

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
              new MaterialPageRoute(builder: (_) => new HomePage(0)),
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
        } else {
          Navigator.of(context, rootNavigator: true).pop('dialog');

          Fluttertoast.showToast(
              msg: allTranslations.text('erreur_title'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 5,
              backgroundColor: Colors.orange,
              textColor: Colors.white);
        }
      } */
    }
  }

  _init() async {
    String matricule = _numeroController.text.toString();

    if (matricule.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');

      String basicAuth = 'Bearer ' + token1;

      var response = await http.get(
          Setting.apiracine + "comptes/check?matricule=" + matricule.toString(),
          headers: {
            "Language": allTranslations.currentLanguage.toString(),
            "Authorization": basicAuth,
          });

      print("retour : " + response.body.toString());

      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        var responseJson = json.decode(response.body);
        setState(() {
          visible = true;
          code = responseJson["code"].toString();
          Fluttertoast.showToast(
              msg: "Le code est : " + responseJson["code"].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 5,
              backgroundColor: Colors.blue,
              textColor: Colors.white);
        });
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        var responseJson = json.decode(response.body);

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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
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
                    labelText: allTranslations.text('matricule') + " *",
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
                  controller: _numeroController,
                  keyboardType: TextInputType.number,
                  enabled: visible ? false : true,
                ),
              ),
            ),
            Divider(
              height: 25.0,
              color: Colors.transparent,
            ),
            Padding(
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
                    labelText: "Code d'abonnement" + " *",
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
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Divider(
              height: 25.0,
              color: Colors.transparent,
            ),
            Padding(
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
                      Icons.security,
                      color: color,
                    ),
                    labelText: allTranslations.text('s2') + " *",
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
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Divider(
              height: 15.0,
              color: Colors.transparent,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new Center(
                  child: new InkWell(
                    onTap: () {},
                    child: new Container(
                      width: 300.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        color: color,
                        border: new Border.all(color: Colors.white, width: 2.0),
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: new Center(
                        child: new Text(
                          "Activer le cartnet",
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
          ],
        ),
      ),
    );
  }
}
