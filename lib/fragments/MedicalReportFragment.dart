import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/pages/DossierMedicalPage2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

class MedicalReportFragment extends StatefulWidget {
  MedicalReportFragment();

  @override
  MedicalReportFragmentState createState() => MedicalReportFragmentState();
}

class MedicalReportFragmentState extends State<MedicalReportFragment> {
  MedicalReportFragmentState();

  final _formKey = GlobalKey<FormState>();

  final _matricule = TextEditingController();
  final _pincode = TextEditingController();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isSaving = true;

  String currentpin = "";

  final _searchController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _searchController.dispose();
    _matricule.dispose();
    _pincode.dispose();
    super.dispose();
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      currentpin = (prefs.getString('currentpin') ?? '');
    });
  }

  void initState() {
    requestPersmission();
    super.initState();
    _loadUser();
  }

  void _sentData() async {
    MySingleton mySingleton = new MySingleton();

    String matricule = _matricule.text.toString();
    String pin = _pincode.text.toString();

    if (matricule.isEmpty) {
      Fluttertoast.showToast(
          msg: "Veuillez renseigner un matricule santé",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (pin != currentpin) {
      Fluttertoast.showToast(
          msg: "Pin d'authentification incorrect",
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

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

      Map data = {
        "search": matricule,
      };

      var res = await http
          .put(Uri.parse(Setting.apiracine + "comptes/search"), body: data, headers: {
        "Authorization": basicAuth,
        "Language": mySingleton.getLangue.toString(),
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
          new MaterialPageRoute(
              builder: (_) => new DossierMedicalPage2(matricule)),
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
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    // TODO: implement build
    return new Center(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(allTranslations.text("z118"),
            style: TextStyle(fontSize: 16.0, color: Colors.black, height: 1.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
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
                        if (value!.isEmpty) {
                          return allTranslations.text("requis_title");
                        }
                      },
                      controller: _matricule,
                      keyboardType: TextInputType.number,
                      // enabled: visible ? false : true,
                    ),
                  ),
                ),
                flex: 5,
              ),
              Flexible(
                  child: IconButton(
                    onPressed: () {
                      // You enter here what you want the button to do once the user interacts with it
                      _scan1();
                    },
                    icon: Icon(
                      Icons.qr_code,
                      color: color,
                    ),
                    iconSize: 40.0,
                  ),
                  flex: 1)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
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
                if (value!.isEmpty) {
                  return allTranslations.text("requis_title");
                }
              },
              controller: _pincode,
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: new Center(
              child: new InkWell(
                onTap: _sentData,
                child: new Container(
                  width: 200.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: color,
                    border: new Border.all(color: color, width: 2.0),
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  child: new Center(
                    child: new Text(
                      allTranslations.text("titre3_title"),
                      style: new TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),
        SizedBox(
          height: 20,
        ),
      ],
    ));
  }

  Future _scan() async {
  /*  String barcode = await scanner.scan();
    _matricule.text = barcode;*/
  }

  void requestPersmission() async {
    //await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }

  Future _scan1() async {
    //await Permission.camera.request();
   /* String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      //this._outputController.text = barcode;
      _matricule.text = barcode;
    }*/
  }
}
