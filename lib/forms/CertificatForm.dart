import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/config/singleton.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CertificatForm extends StatefulWidget {
  String consultation;

  CertificatForm(this.consultation);

  @override
  CertificatFormState createState() => CertificatFormState(this.consultation);
}

class CertificatFormState extends State<CertificatForm> {
  String consultation;
  CertificatFormState(this.consultation);

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isSaving = true;

  final _raisonController = TextEditingController();
  final _securityController = TextEditingController();
  DateTime? _dateTime;
  int hopital = -1;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _raisonController.dispose();
    _securityController.dispose();
    super.dispose();
  }

  Future<void> _sentData() async {
    MySingleton mySingleton = new MySingleton();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _security = _securityController.text.toString();
    String currentpin = (prefs.getString('currentpin') ?? '');

    // print("hopital : " + hopital.toString());

    if ((_security != currentpin) || (_security.isEmpty)) {
      Fluttertoast.showToast(
          msg: allTranslations.text('s5'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (_raisonController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
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

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

      Map data = {
        "id": this.consultation.toString(),
        "description": _raisonController.text.toString()
      };

      var res = await http.post(Uri.parse(Setting.apiracine + "consultation/certificat"),
          body: data,
          headers: {
            "Authorization": basicAuth,
            "Language":  mySingleton.getLangue.toString()
          });

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
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              allTranslations.text("z11")+" *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 3.0,
              color: Colors.transparent,
            ),
            TextFormField(
                obscureText: false,
                maxLines: 5,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                controller: _raisonController,
                keyboardType: TextInputType.multiline),
            Divider(
              height: 5.0,
              color: Colors.transparent,
            ),
            TextFormField(
              obscureText: false,
              controller: _securityController,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: new Icon(
                  Icons.security,
                  color: color,
                ),
                labelText: allTranslations.text('s2'),
                labelStyle: TextStyle(
                    color: color2,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return allTranslations.text('requis_title');
                }
              },
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new Center(
                  child: new InkWell(
                    onTap: _sentData,
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
                          allTranslations.text("z12"),
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
}
