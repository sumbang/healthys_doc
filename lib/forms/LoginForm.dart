import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:healthys_medecin/models/Profil.dart';
import 'package:healthys_medecin/pages/ChooseProfile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  final _loginController = TextEditingController();
  final _pwdController = TextEditingController();

  bool visiblepassword = true;
  bool _isSaving = true;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _loginController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white,
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
                      Icons.email,
                      color: color,
                    ),
                    labelText: allTranslations.text('email_title') + " *",
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return allTranslations.text('requis_title');
                    }
                  },
                  keyboardType: TextInputType.text,
                  controller: _loginController,
                ),
              ),
            ),
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        obscureText: visiblepassword,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: new Icon(
                            Icons.lock_open,
                            color: color,
                          ),
                          labelText: allTranslations.text('password_title'),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return allTranslations.text('requis_title');
                          }
                        },
                        controller: _pwdController,
                      ),
                      flex: 7,
                    ),
                    new Expanded(
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (visiblepassword)
                                visiblepassword = false;
                              else
                                visiblepassword = true;
                            });
                          },
                          child: new Icon(
                            Icons.remove_red_eye,
                            color: color,
                          ),
                        ),
                        margin: const EdgeInsets.only(
                            left: 0.0, right: 0.0, bottom: 0.0, top: 15.0),
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new Center(
                  child: new InkWell(
                    onTap: _makeLogin,
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
                          allTranslations.text('connect_title'),
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _makeLogin() async {
    MySingleton mySingleton = new MySingleton();

    if (_formKey.currentState!.validate()) {
      // If the form is valid, we want to show a Snackbar

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

      _formKey.currentState!.save();

      // dismiss keyboard during async call
      FocusScope.of(context).requestFocus(new FocusNode());

      // start the modal progress HUD
      setState(() {
        _isSaving = false;
      });

      String _login = _loginController.text.toString();
      String _pwd = _pwdController.text.toString();

      Map data = {'login': _login, 'password': _pwd};

      print("DATA :" + data.toString());

      MySingleton mySingleton = new MySingleton();

      var res = await http.post(Uri.parse(Setting.apiracine + "compte/login"),
          body: data,
          headers: {
            "Language": mySingleton.getLangue.toString(),
            "plateforme": "medecin"
          });

      print("DATA :" + res.body.toString());

      if (res.statusCode == 200) {
        var responseJson = json.decode(res.body);

        Navigator.of(context, rootNavigator: true).pop('dialog');

        String id = responseJson['id'].toString();
        String nom = responseJson['nom'];
        String apitoken = responseJson['apitoken'];
        String datemembre = responseJson['datecreate'];
        String role = responseJson['role'].toString();
        String biometrie = responseJson['biometrie'].toString();
        String enregistrer = responseJson['enregistrement'].toString();
        String abonner = responseJson['abonner'].toString();
        String voir = responseJson['voir'].toString();
        String consulter = responseJson['consulter'].toString();

        List<String> ids = [];
        List<String> patients = [];
        List<String> noms = [];
        List<String> numeros = [];
        List<String> photos = [];
        List<String> pins = [];
        List<String> payer = [];
        List<String> integral =  [];
        List<String> perso = [];

        String res1 = res.body.toString();

        var tagObjsJson = jsonDecode(res1)['profil'] as List;

        List<Profil> tagObjs =
            tagObjsJson.map((tagJson) => Profil.fromJson(tagJson)).toList();

        MyItems specialite = MyItems.fromJson(responseJson["specialite"]);

        for (int j = 0; j < tagObjs.length; j++) {
          ids.add(tagObjs[j].id.toString());
          patients.add(tagObjs[j].patient.toString());
          noms.add(tagObjs[j].nom.toString());
          numeros.add(tagObjs[j].numero.toString());
          photos.add(tagObjs[j].photo.toString());
          pins.add(tagObjs[j].pin.toString());
          payer.add(tagObjs[j].payer.toString());
          integral.add(tagObjs[j].integral.toString());
          perso.add(tagObjs[j].perso.toString());
        }

        // SharedPreferences.setMockInitialValues({});

        final prefs = await SharedPreferences.getInstance();

        print("photo : " + photos[0].toString());

        setState(() {
          prefs.setString('token', apitoken);
          prefs.setString('datemembre', datemembre);
          prefs.setString('nom', nom);
          prefs.setString('biometrie', biometrie);
          prefs.setString('id', id.toString());
          prefs.setString('role', role.toString());
          prefs.setStringList('ids', ids);
          prefs.setStringList('noms', noms);
          prefs.setString('enregistrer', enregistrer);
          prefs.setString('abonner', abonner);
          prefs.setString('voir', voir);
          prefs.setString('consulter', consulter);
          prefs.setString('idspecialite', specialite.id.toString());
          prefs.setString('specialite', specialite.libelle.toString());
          prefs.setStringList('patients', patients);
          prefs.setStringList('numeros', numeros);
          prefs.setStringList('photos', photos);
          prefs.setStringList('pins', pins);
          prefs.setStringList('payer', payer);
          prefs.setStringList('integral', integral);
          prefs.setStringList('perso', perso);
        });

        print("taille : " + photos.length.toString());

        Navigator.push(
          context,
          new MaterialPageRoute(builder: (_) => new ChooseProfilePage()),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        var responseJson = json.decode(res.body);

        Fluttertoast.showToast(
            msg: responseJson['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
      }
    }
  }
}
