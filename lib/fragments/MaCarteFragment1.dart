import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MaCarteFragment1 extends StatefulWidget {
  MaCarteFragment1();

  @override
  MaCarteFragment1State createState() => new MaCarteFragment1State();
}

class MaCarteFragment1State extends State<MaCarteFragment1> {
  MaCarteFragment1State();

  String codeuser = "";
  String roleuser = "";
  String nomuser = "";
  String token = "";
  bool _isSaving = true;
  List<String> ids;
  List<String> noms;
  List<String> patients;
  List<String> numeros;
  String currentid = "1";
  String currentpatient = "";
  String currentacces = "";
  String username = "";
  String currentnom = "";
  String currentnumero = "";

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

      token = (prefs.getString('token') ?? '');

      print("numero : " + currentpatient.toString());
    });
  }

  void initState() {
    super.initState();

    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

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
            allTranslations.text('qr_title1'),
            style: TextStyle(color: Colors.white, fontSize: 16.0, height: 1.5),
          ),
        ),
        Divider(
          height: 10.0,
          color: Colors.transparent,
        ),
        Center(
          child: Text(
            allTranslations.text('ordre_title1') + " : " + qrstring,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        Divider(
          height: 10.0,
          color: Colors.transparent,
        ),
        Center(
            child: QrImage(
          data: qrstring,
          version: QrVersions.auto,
          size: 400,
          gapless: false,
        )),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
