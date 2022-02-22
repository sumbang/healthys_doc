import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/pages/LoginPage.dart';
import 'package:healthys_medecin/pages/StartPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:http/http.dart' as http;

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  final gris = const Color(0xFF373736);
  final rouge = const Color(0xFFe43420);
  final vert = const Color(0xFF2f5f2e);
    final color = const Color(0xFFcd005f);
  final claire = const Color(0xFFf4f4f4);
  final color2 = const Color(0xFF008dad);

  String token = "";
  String role = "";
  String pass_exist = "";
  bool _isSaving = true;
  bool visiblepassword = true;

  Future<void> _makeLogout() async {
    showDialog(
      context: context,
      barrierDismissible: _isSaving,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(allTranslations.text('progress_title')),
          content: new Center(
              child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          )),
        );
      },
    );

    setState(() {
      _isSaving = false;
    });

    Map data = {
      'TOKEN': token.toString(),
    };

    var res = await http.put(Setting.apiracine + "comptes/logout", body: data);

    final prefs = await SharedPreferences.getInstance();

    if (res.statusCode == 200) {
      setState(() {
        prefs.remove('token');
        prefs.remove('datemembre');
        prefs.remove('nom');
        prefs.remove('id');
        prefs.remove('role');
        prefs.remove('biometrie');
        prefs.remove('currentid');
        prefs.remove('currentpatient');
        prefs.remove('currentnom');
        prefs.remove('currentphoto');
        prefs.remove('currentpin');
        prefs.remove('ids');
        prefs.remove('noms');
        prefs.remove('patients');
        prefs.remove('pins');
        prefs.remove('currentpayer');
        prefs.remove('currentint');
      });

      Navigator.of(context, rootNavigator: true).pop('dialog');

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (_) => new MyApp()),
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');

      var responseJson = json.decode(res.body);

      Fluttertoast.showToast(
          msg: responseJson['message'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    }
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token = (prefs.getString("token") ?? "");
      role = (prefs.getString("role") ?? "");
      pass_exist = (prefs.getString("currentpin") ?? "");
    });

    if (token.isEmpty) {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (_) => new StartPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return Scaffold(
      backgroundColor: color,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
                child: new Image.asset(
              'img/doc.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              width: 200.0,
            )),
            SizedBox(
              height: 60,
            ),
            Center(
              child: Text("Session vérouillée, veuilez entrer votre code pin",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 20,
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
                            color: vert,
                          ),
                          labelText: "Pin de connexion",
                          labelStyle: TextStyle(
                              color: gris,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return allTranslations.text('requis_title');
                          }
                        },
                        keyboardType: TextInputType.number,
                        controller: this._textEditingController,
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
                            color: color2,
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
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: rouge,
                  child: Text("Déconnexion",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _makeLogout();
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  color: color2,
                  child: Text("Ouvrir",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    if (this._textEditingController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Veuillez saisir votre pin",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 5,
                          backgroundColor: rouge,
                          textColor: Colors.white);
                    } else if (this._textEditingController.text == pass_exist) {
                      AppLock.of(context).didUnlock('some data');
                    } else {
                      Fluttertoast.showToast(
                          msg: "Pin incorrect",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 5,
                          backgroundColor: rouge,
                          textColor: Colors.white);
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}