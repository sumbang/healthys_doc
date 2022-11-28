import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MaCarteFragment extends StatefulWidget {
  MaCarteFragment();

  @override
  MaCarteFragmentState createState() => new MaCarteFragmentState();
}

class MaCarteFragmentState extends State<MaCarteFragment> {
  MaCarteFragmentState();

  String codeuser = "";
  String roleuser = "";
  String nomuser = "";
  String token = "";
  bool _isSaving = true;
  List<String>? ids;
  List<String>? noms;
  List<String>? patients;
  List<String>? numeros;
  String currentid = "1";
  String currentpatient = "";
  String currentacces = "";
  String username = "";
  String currentnom = "";
  String currentnumero = "";
  String currentprofession = "";

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      ids = (prefs.getStringList('ids') ?? []);
      noms = (prefs.getStringList('noms') ?? []);
      patients = (prefs.getStringList('patients') ?? []);
      numeros = (prefs.getStringList('numeros') ?? []);

      codeuser = (prefs.getString('currentid') ?? '');
      currentacces = (prefs.getString('role') ?? '');
      currentnom = (prefs.getString('currentnom') ?? '');
      username = (prefs.getString('nom') ?? '');
      currentpatient = (prefs.getString('currentpatient') ?? '');
      currentnumero = (prefs.getString('currentnumero') ?? '');
      currentprofession = (prefs.getString('specialite') ?? '');

      token = (prefs.getString('token') ?? '');
    });
  }

  void initState() {
    super.initState();

    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    String qrstring = currentnumero.toString();

    /* String qrstring = "INFORMATIONS PERSONNELLES \n\nNUMERO PATIENT : 12295860998 \nNOM : ATANGANA \nPRENOM : Paul \nDATE DE NAISSANCE : 24/03/1980 \nPAYS DE RESIDENCE : Cameroun \nVILLE DE RESIDENCE : Douala \n\nCONTACTS D'URGENCE \n\nNOM : TAMBA Jacqueline \nPHONE : 67164658\n\nMEDECIN TRAITANT\n\nNOM : TCHINDA Paul \nPHONE : Paul\n\nANTECEDENTS MEDICALS \n\nTabac : non\nVIH : non\nAlcool : oui";

    */

    // TODO: implement build
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 100.0,
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: color,
          ),
          margin: EdgeInsets.all(10.0),
          child: Text(
            allTranslations.text('qr_title'),
            style: TextStyle(color: Colors.white, fontSize: 16.0, height: 1.5),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: Text(
            allTranslations.text('login_title1').toUpperCase() + " : " + qrstring,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Center(
          child: Text(
            "SPECIALITE : " + currentprofession,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        Divider(
          height: 20.0,
          color: Colors.transparent,
        ),
        Center(
            child: QrImage(
          data: qrstring,
          version: QrVersions.auto,
          size: 400,
          gapless: false,
        ))
      ],
    );
  }
}
