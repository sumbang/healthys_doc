import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Employe.dart';
import 'package:healthys_medecin/models/Medecin.dart';
import 'package:healthys_medecin/pages/AskPaiement.dart';
import 'package:healthys_medecin/pages/RdvPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PaiementForm extends StatefulWidget {

  PaiementForm();

  @override
  PaiementFormState createState() => PaiementFormState();
}

class PaiementFormState extends State<PaiementForm> {
 
  PaiementFormState();

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String selectedValue = "62402";

  List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("ORANGE MONEY"),value: "62402"),
    DropdownMenuItem(child: Text("MTN MOBILE MONEY"),value: "62401"),
  ];
  return menuItems;
}

static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  bool _isSaving = true;

  final _phoneController = TextEditingController();
  final _montantController = TextEditingController();
  final _modeController = TextEditingController();
  DateTime? _dateTime;
  int hopital = -1;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _phoneController.dispose();
    _modeController.dispose();
    _montantController.dispose();
    super.dispose();
  }


  Future<void> _sentData() async {
    MySingleton mySingleton = new MySingleton();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _phone = _phoneController.text.toString();
    String _montant = _montantController.text.toString();
   
    if (_phoneController.text.isEmpty ||
        _montantController.text.isEmpty ) {
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
      String token2 = 'api_live.tGXUD5WTjMvb0u6X++DgCkz2C7j5xpAwVo8kEBNBhpSLzBobapC0xUHG71qJF6BH';

      String basicAuth = 'Bearer ' + token2; MySingleton mySingleton = new MySingleton();

      Map data = {
        "accountIdentifier": "237"+_phone,
        "amount": _montant,
        "providerIdentifier": selectedValue,
        "referenceOrder": "REF"+getRandomString(5),
      };

      var res =
          await http.post(Uri.parse("https://core.diool.com/core/dioolapi/v1/payment"), body: json.encode(data), headers: {
        "Authorization": basicAuth,
        "Content-Type":"application/json"
      });

      print("retour : "+res.body.toString() );

      if (res.statusCode == 200) {
        var responseJson = json.decode(res.body);

        Navigator.of(context, rootNavigator: true).pop('dialog');

        Fluttertoast.showToast(
            msg: allTranslations.text("da6"),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);

        Navigator.push(
          context,
          new MaterialPageRoute(builder: (_) => new AskPaiement()),
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
              allTranslations.text('da2') + " *",
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
                controller: _phoneController,
                keyboardType: TextInputType.phone),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('da3') + " *",
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
                controller: _montantController,
                keyboardType: TextInputType.number),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('da7') + " *",
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
            DropdownButton(
            value: selectedValue,
            onChanged: (String? newValue){
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: dropdownItems
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
                      width: 250.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        color: color,
                        border: new Border.all(color: Colors.white, width: 2.0),
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: new Center(
                        child: new Text(
                          allTranslations.text('da4'),
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
