import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Meeting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewRdvForm extends StatefulWidget {
  Meeting id;

  ViewRdvForm(this.id);

  @override
  EditRdvFormState createState() => EditRdvFormState(this.id);
}

class EditRdvFormState extends State<ViewRdvForm> {
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
  final _medecinController = TextEditingController();
  final _hopitalController = TextEditingController();

  DateTime _dateTime;
  Meeting meet;

  void initState() {
    super.initState();
    setState(() {
      _symptomeController.text = id.symptome;
      _dateController.text = id.datemeeting;
      _medecinController.text = id.docname;
      _noteController.text = id.notes;
      _hopitalController.text = id.idcentresoins.toString();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _noteController.dispose();
    _dateController.dispose();
    _symptomeController.dispose();
    _medecinController.dispose();
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              allTranslations.text('r1'),
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
              controller: _medecinController,
              keyboardType: TextInputType.text,
              enabled: false,
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('hopital_title'),
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
              controller: _hopitalController,
              keyboardType: TextInputType.datetime,
              enabled: false,
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
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
              enabled: false,
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
