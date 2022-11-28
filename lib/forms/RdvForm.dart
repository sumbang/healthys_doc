import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Employe.dart';
import 'package:healthys_medecin/models/Medecin.dart';
import 'package:healthys_medecin/pages/RdvPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class RdvForm extends StatefulWidget {
  Medecin med;

  RdvForm(this.med);

  @override
  RdvFormState createState() => RdvFormState(this.med);
}

class RdvFormState extends State<RdvForm> {
  Medecin med;
  RdvFormState(this.med);

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isSaving = true;

  final _medecinController = TextEditingController();
  final _dateController = TextEditingController();
  final _symptomeController = TextEditingController();
  final _heureController = TextEditingController();
  final _securityController = TextEditingController();
  DateTime? _dateTime;
  int hopital = -1;

  void initState() {
    super.initState();
    _medecinController.text =
        this.med.nom.toString() + " (" + this.med.specialite.toString() + ")";
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _medecinController.dispose();
    _dateController.dispose();
    _symptomeController.dispose();
    _heureController.dispose();
    super.dispose();
  }

  Widget _buildHospi(List<Employe> list) {
    List<Widget> mList = [];

    for (int b = 0; b < list.length; b++) {
      Employe cmap = list[b];

      mList.add(RadioListTile(
          value: cmap.idhospi,
          groupValue: hopital,
          title: Text(
            cmap.hopital.toString(),
            style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          onChanged: (newValue) => setState(() => hopital = newValue),
          activeColor: color));
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: mList,
    );
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
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (_medecinController.text.isEmpty ||
        _symptomeController.text.isEmpty ||
        _dateController.text.isEmpty ||
        (hopital == -1)) {
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

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

      Map data = {
        "medecin": this.med.id.toString(),
        "hopital": hopital.toString(),
        "symptome": _symptomeController.text.toString(),
        "datemeet": _dateController.text.toString(),
        "profil": currentpatient1.toString(),
        "heure": _heureController.text.toString()
      };

      var res =
          await http.post(Setting.apiracine + "meetings", body: data, headers: {
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
            timeInSecForIos: 5,
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
            timeInSecForIos: 5,
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
              allTranslations.text('r1') + " *",
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
                enabled: false,
                keyboardType: TextInputType.multiline),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('r2') + " *",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      obscureText: false,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      controller: _dateController,
                      keyboardType: TextInputType.text,
                      enabled: false,
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
                        /* DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2018, 3, 5),
                            //maxTime: DateTime(2019, 6, 7),
                            theme: DatePickerTheme(
                                headerColor: Colors.white,
                                backgroundColor: Colors.white,
                                itemStyle: TextStyle(
                                    color: color2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                doneStyle:
                                    TextStyle(color: color, fontSize: 16)),
                            onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(() {
                            _dateController.text = date.year.toString() +
                                "-" +
                                date.month.toString() +
                                "-" +
                                date.day.toString();
                          });
                        },
                            currentTime: DateTime.now(),
                            locale: allTranslations.currentLanguage
                                        .toString() ==
                                    "fr"
                                ? LocaleType.fr
                                : mySingleton.getLangue.toString(), ==
                                        "es"
                                    ? LocaleType.es
                                    : LocaleType.en); */

                        showDatePicker(
                                context: context,
                                initialDate: _dateTime == null
                                    ? DateTime.now()
                                    : _dateTime!,
                                firstDate: DateTime(2010),
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
              allTranslations.text('r7') + " *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            _buildHospi(med.emplois),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('r6') + " *",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      obscureText: false,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      controller: _heureController,
                      keyboardType: TextInputType.text,
                      enabled: false,
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
                        DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(
                                headerColor: Colors.white,
                                backgroundColor: Colors.white,
                                itemStyle: TextStyle(
                                    color: color2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                                doneStyle:
                                    TextStyle(color: color, fontSize: 16)),
                            onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(() {
                            _heureController.text = date.hour.toString() +
                                ":" +
                                date.minute.toString() +
                                ":" +
                                date.second.toString();
                          });
                        },
                            currentTime: DateTime.now(),
                            locale: allTranslations.currentLanguage
                                        .toString() ==
                                    "fr"
                                ? LocaleType.fr
                                : mySingleton.getLangue.toString() ==
                                        "es"
                                    ? LocaleType.es
                                    : LocaleType.en);
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
              allTranslations.text('r3') + " *",
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
            ),
            Divider(
              height: 30.0,
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
