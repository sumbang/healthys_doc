import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:healthys_medecin/pages/VaccinPage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:fluttertoast/fluttertoast.dart';

class NewVaccinForm extends StatefulWidget {
  @override
  NewVaccinFormState createState() => NewVaccinFormState();
}

class NewVaccinFormState extends State<NewVaccinForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  final _nomController = TextEditingController();
  final _importanceController = TextEditingController();
  final _dateController = TextEditingController();
  final _periodeController = TextEditingController();
  final _priseController = TextEditingController();
  final _numeroController = TextEditingController();
  Future<List<MyItems>> period;

  MyItems c_exist;

  DateTime _dateTime;
  int periode = -1;
  bool _isSaving = true;

  void initState() {
    requestPersmission();
    super.initState();
    period = getElements();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _nomController.dispose();
    _dateController.dispose();
    _importanceController.dispose();
    _periodeController.dispose();
    _priseController.dispose();
    super.dispose();
  }

  Widget _buildPeriode(List<MyItems> list) {
    List<Widget> mList = new List();

    for (int b = 0; b < list.length; b++) {
      MyItems cmap = list[b];

      mList.add(RadioListTile(
          value: cmap.id,
          groupValue: periode,
          title: Text(
            cmap.libelle.toString(),
            style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          onChanged: (newValue) => setState(() => periode = newValue),
          activeColor: color));
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: mList,
    );
  }

  Future _scan() async {
   /* String barcode = await scanner.scan();

    _numeroController.text = barcode;*/
  }

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }

  Future _scan1() async {
    //await Permission.camera.request();
   /* String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      //this._outputController.text = barcode;
      _numeroController.text = barcode;
    }*/
  }

  Future<List<MyItems>> getElements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;
    List<MyItems> liste = List();

    var response = await http.get(Setting.apiracine + "vaccins/item", headers: {
      "Authorization": basicAuth,
      "Language": allTranslations.currentLanguage.toString()
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
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20.0),
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
                            return allTranslations.text('requis_title');
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
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v2'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  controller: _nomController,
                ),
              ),
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v3'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                height: 100,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _importanceController,
                ),
              ),
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v4'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: new Border.all(color: Colors.black38),
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal),
                            contentPadding: const EdgeInsets.all(15.0)),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _dateController,
                      ),
                    ),
                  ),
                  flex: 2,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: new IconButton(
                      icon: new Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: _dateTime == null
                                    ? DateTime.now()
                                    : _dateTime,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030))
                            .then((date) {
                          setState(() {
                            _dateTime = date;
                            String vj = "";
                            String vm = "";
                            var date1 = DateTime.parse(_dateTime.toString());
                            var j = date1.day;
                            var m = date1.month;
                            if (j < 10)
                              vj = "0" + j.toString();
                            else
                              vj = j.toString();
                            if (m < 10)
                              vm = "0" + m.toString();
                            else
                              vm = m.toString();
                            var formattedDate = "${date1.year}-${vm}-${vj}";
                            _dateController.text = formattedDate;
                          });
                        });
                      },
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v5'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: period,
                  builder: (context, snapshot) {
                    print(snapshot.toString());

                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      return _buildPeriode(snapshot.data);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v6'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  controller: _priseController,
                ),
              ),
            ),
            Divider(
              height: 15.0,
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

  Future<void> _sentData() async {
    Locale myLocale = Localizations.localeOf(context);

    if (_nomController.text.isEmpty ||
        _importanceController.text.isEmpty ||
        _priseController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _numeroController.text.isEmpty ||
        (periode == -1)) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
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
      String id = (prefs.getString('currentid') ?? '');

      String basicAuth = 'Bearer ' + token1;

      Map data = {
        "nom": _nomController.text.toString(),
        "importance": _importanceController.text.toString(),
        "date": _dateController.text.toString(),
        "periode": periode.toString(),
        "prise": _priseController.text.toString(),
        "profil": _numeroController.text.toString(),
        "id": id
      };

      var res =
          await http.post(Setting.apiracine + "vaccins", body: data, headers: {
        "Authorization": basicAuth,
        "Language": allTranslations.currentLanguage.toString()
      });

      if (res.statusCode == 200) {
        var responseJson = json.decode(res.body);

        Navigator.of(context, rootNavigator: true).pop('dialog');

        Fluttertoast.showToast(
            msg: responseJson["message"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);

        Navigator.push(
          context,
          new MaterialPageRoute(builder: (_) => new VaccinPage()),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        var responseJson = json.decode(res.body);

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
}
