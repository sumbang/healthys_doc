import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:healthys_medecin/pages/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class ActivationForm extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<ActivationForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  final _codeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _pinController = TextEditingController();

  bool visible = true;
  String code = "";
  bool _isSaving = true;
  String currentpin = "";
  String currentpatient = "";
  bool isVisible = true;
  MyItems abonnement;
  Future<List<MyItems>> abonnements;
  MyItems mode;
  Future<List<MyItems>> modes;

  Future<List<MyItems>> getAbo() async {
    List<MyItems> liste = List();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response =
        await http.get(Setting.apiracine + "comptes/abonnements", headers: {
      "Language": allTranslations.currentLanguage.toString(),
      "Authorization": basicAuth,
    });

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  Future<List<MyItems>> getMode() async {
    List<MyItems> liste = List();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response =
        await http.get(Setting.apiracine + "comptes/modes", headers: {
      "Language": allTranslations.currentLanguage.toString(),
      "Authorization": basicAuth,
    });

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

  String _retrieveDataError;
  bool isVideo = false;

  final TextEditingController referenceController = TextEditingController();

  @override
  void initState() {
    requestPersmission();
    super.initState();
    _loadUser();
    abonnements = getAbo();
    modes = getMode();
  }

  _makeReset() async {
    String matricule = _numeroController.text.toString();
    String pin = _pinController.text.toString();
    String reference = referenceController.text.toString();

    if (matricule.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text("z1"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (abonnement == null) {
      Fluttertoast.showToast(
          msg: allTranslations.text("z2"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (mode == null) {
      Fluttertoast.showToast(
          msg: allTranslations.text("z3"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if ((mode.id == 2) && (reference.isEmpty)) {
      Fluttertoast.showToast(
          msg: allTranslations.text("z4"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (pin.toString().isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text("z5"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else if (pin != currentpin) {
      Fluttertoast.showToast(
          msg: allTranslations.text("z6"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } else {
      showDialog(
        context: context,
        barrierDismissible: _isSaving,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            allTranslations.text('progress_title'),
                            style: TextStyle(
                                color: color2, fontWeight: FontWeight.bold),
                          ),
                        )),
                    flex: 8,
                  ),
                  Flexible(
                      child: Container(
                          margin: EdgeInsets.only(top: 0.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              },
                              icon: Icon(
                                Icons.close,
                                color: color,
                              ),
                              iconSize: 30.0,
                            ),
                          )),
                      flex: 1),
                ],
              ),
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
        'matricule': matricule.toString(),
        'abonnement': abonnement.id.toString(),
        'mode': mode.id.toString(),
        'reference': reference.toString()
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token1 = (prefs.getString('token') ?? '');

      String basicAuth = 'Bearer ' + token1;

      var res = await http
          .post(Setting.apiracine + "comptes/abonner", body: data, headers: {
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
            backgroundColor: Colors.green,
            textColor: Colors.white);

        Navigator.push(
          context,
          new MaterialPageRoute(builder: (_) => new HomePage()),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        var responseJson = json.decode(res.body);

        print("retour:" + res.body.toString());

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

  Future _scan() async {
 /*   String barcode = await scanner.scan();

    _numeroController.text = barcode;*/
  }

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }

  Future _scan1() async {
    //await Permission.camera.request();
  /*  String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      //this._outputController.text = barcode;
      _numeroController.text = barcode;
    }*/
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
            Row(
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
                          if (value.isEmpty) {
                            return allTranslations.text("requis_title");
                          }
                        },
                        controller: _numeroController,
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
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 20.0, bottom: 8.0),
              child: Text(
                allTranslations.text("z7")+" *",
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.normal,
                    fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: abonnements,
                  builder: (context, snapshot) {
                    print(snapshot.toString());

                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      List<DropdownMenuItem<MyItems>> items = List();

                      for (int i = 0; i < snapshot.data.length; i++) {
                        items.add(
                          DropdownMenuItem(
                              child: Text(snapshot.data[i].libelle),
                              value: snapshot.data[i]),
                        );
                      }

                      return Container(
                          width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: new Border.all(color: Colors.black38),
                          ),
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, top: 5.0, bottom: 4.0),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<MyItems>(
                                  isExpanded: true,
                                  value: abonnement,
                                  items: items,
                                  onChanged: (value) {
                                    setState(() {
                                      abonnement = value;
                                    });
                                  })));
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Divider(
              height: 0.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 20.0, bottom: 8.0),
              child: Text(
                allTranslations.text("z8")+" *",
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.normal,
                    fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: modes,
                  builder: (context, snapshot) {
                    print(snapshot.toString());

                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      List<DropdownMenuItem<MyItems>> items = List();

                      for (int i = 0; i < snapshot.data.length; i++) {
                        items.add(
                          DropdownMenuItem(
                              child: Text(snapshot.data[i].libelle),
                              value: snapshot.data[i]),
                        );
                      }

                      return Container(
                          width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: new Border.all(color: Colors.black38),
                          ),
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, top: 5.0, bottom: 4.0),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<MyItems>(
                                  isExpanded: true,
                                  value: mode,
                                  items: items,
                                  onChanged: (value) {
                                    setState(() {
                                      mode = value;
                                    });
                                  })));
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
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
                      Icons.money,
                      color: color,
                    ),
                    labelText: allTranslations.text("z9")+" *",
                    labelStyle: TextStyle(
                        color: color,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                         return allTranslations.text("requis_title");
                    }
                  },
                  controller: referenceController,
                  keyboardType: TextInputType.text,
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
                    labelText: allTranslations.text("z10")+" *",
                    labelStyle: TextStyle(
                        color: color,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                         return allTranslations.text("requis_title");
                    }
                  },
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            visible
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: new Center(
                      child: new InkWell(
                        onTap: _makeReset,
                        child: new Container(
                          width: 300.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            color: color,
                            border:
                                new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          child: new Center(
                            child: new Text(
                              allTranslations.text('save_title'),
                              style: new TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
