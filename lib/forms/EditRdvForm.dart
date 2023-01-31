import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Meeting.dart';
import 'package:healthys_medecin/pages/RdvPage.dart';
import 'package:healthys_medecin/pages/Rendezvous2Page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditRdvForm extends StatefulWidget {
  Meeting id;

  EditRdvForm(this.id);

  @override
  EditRdvFormState createState() => EditRdvFormState(this.id);
}

class EditRdvFormState extends State<EditRdvForm> {
  Meeting id;

  EditRdvFormState(this.id);

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isSaving = true;

  final _noteController = TextEditingController();
  final _dateController = TextEditingController();
  final _symptomeController = TextEditingController();
  DateTime? _dateTime;
  Meeting? meet;

  void initState() {
    super.initState();
    setState(() {
      _symptomeController.text = id.symptome;
      _dateController.text = id.datemeeting;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _noteController.dispose();
    _dateController.dispose();
    _symptomeController.dispose();
    super.dispose();
  }

  Future<void> _sentData() async {
    MySingleton mySingleton = new MySingleton();

    if (_noteController.text.isEmpty ||
        _symptomeController.text.isEmpty ||
        _dateController.text.isEmpty) {
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

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

      Map data = {
        "meeting": id.id.toString(),
        "commentaire": _noteController.text.toString(),
      };


      var res = await http
          .post(Uri.parse(Setting.apiracine + "meetings/confirm"), body: data, headers: {
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
          new MaterialPageRoute(builder: (_) => new RdvPage()),
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
              allTranslations.text('r2'),
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
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal),
              controller: _dateController,
              keyboardType: TextInputType.datetime,
              enabled: false,
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('r3'),
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
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal),
              controller: _symptomeController,
              keyboardType: TextInputType.multiline,
              enabled: false,
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('comment_title'),
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
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal),
              controller: _noteController,
              keyboardType: TextInputType.multiline,
            ),
            Divider(
              height: 30.0,
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
                          allTranslations.text('save1_title'),
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
