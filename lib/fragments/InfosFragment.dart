import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InfosFragment extends StatefulWidget {
  InfosFragment();

  @override
  InfosFragmentState createState() => new InfosFragmentState();
}

class InfosFragmentState extends State<InfosFragment> {
  InfosFragmentState();

  MyItems? civilite;
  MyItems? pays;
  MyItems? sexe;
  DateTime? _datenaiss;
  String civ = "";
  String pay = "";

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _datnaissController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _villeController = TextEditingController();
  final _adresseController = TextEditingController();
  final _emailController = TextEditingController();
  final _cnicontroller = TextEditingController();

  String currentpatient = "";
  String token = "";

  bool _isChecked = true;
  bool _isSaving = true;

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = [];

    var response = await http
        .get(Uri.parse(Setting.apiracine + "comptes/data?types=" + nature.toString()));

    print("DATA :" + response.body.toString());

  
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
   
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String currentpatient1 = (prefs.getString('currentpatient') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    sit = getElements("2");

    var res = await http
        .get(Uri.parse(Setting.apiracine + "comptes/" + currentpatient1), headers: {
      "Authorization": basicAuth,
      "Language": mySingleton.getLangue.toString(),
    });

    if (res.statusCode == 200) {
      var responseJson = json.decode(res.body);

      print("DATA5 :" + res.body.toString());

      setState(() {
        _nomController.text = responseJson["nom"].toString();
        _prenomController.text = responseJson["prenom"].toString();
        _datnaissController.text = responseJson["datnaiss"].toString();
        _villeController.text = responseJson["ville"].toString();
        _adresseController.text = responseJson["quartier"].toString();
        _phone1Controller.text = responseJson["phone1"].toString();
        _phone2Controller.text = responseJson["phone2"].toString();
        _emailController.text = responseJson["email"].toString();
        _cnicontroller.text =
            responseJson["cni"] == null ? "" : responseJson["cni"].toString();
        pay = responseJson["pays"].toString();
        civ = responseJson["civilite"].toString();
        _groupValue1 = responseJson["civilite"];
      });
    }
  }

  int _groupValue1 = -1;
  Future<List<MyItems>>? sit;
  List<String> sitmat = [];
  MyItems? situation;

  void _handleRadioValueSit(MyItems value) {
    setState(() {
      situation = value;
    });
  }

  void initState() {
    super.initState();

    _loadUser();
  }

  void _submitForms() async {
    if (_nomController.text.isEmpty ||
        _datnaissController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _phone1Controller.text.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis_title'),
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

      Map data = {
        'civilite': _groupValue1.toString(),
        'nom': _nomController.text.toString(),
        'prenom': _prenomController.text.toString(),
        'datnaiss': _datnaissController.text.toString(),
        'pays': "",
        'ville': _villeController.text.toString(),
        'adresse': _adresseController.text.toString(),
        'phone1': _phone1Controller.text.toString(),
        'phone2': "",
        'email': _emailController.text.toString(),
        'cni': _cnicontroller.text.toString(),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

      print("DATA5 :" + Setting.apiracine + "comptes/" + currentpatient1);

      var res = await http.put(Uri.parse(Setting.apiracine + "comptes/" + currentpatient1),
          body: data,
          headers: {
            "Authorization": basicAuth,
            "Language": mySingleton.getLangue.toString(),
          });

      print("DATA5 :" + res.body.toString());

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
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _datnaissController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _villeController.dispose();
    _adresseController.dispose();
    _emailController.dispose();
    _cnicontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    // TODO: implement build
    return SingleChildScrollView(
        child: ConstrainedBox(
      constraints: BoxConstraints(),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('civ_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: sit,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      List<Widget> civ = [];

                      for (int i = 0; i < snapshot.data!.length; i++) {
                        Widget radio = new RadioListTile(
                          value: snapshot.data![i].id,
                          groupValue: _groupValue1,
                          title: Text(
                            snapshot.data![i].libelle.toString(),
                            style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          onChanged: (newValue) =>
                              setState(() => _groupValue1 = newValue),
                          activeColor: color,
                          selected: snapshot.data![i].id == _groupValue1
                              ? true
                              : false,
                        );

                        civ.add(radio);
                        //civ.add(pad);
                      }

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: civ);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('nom_title') + " *",
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      hintText: allTranslations.text('hint1_title'),
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  keyboardType: TextInputType.text,
                  controller: _nomController,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('prenom_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      hintText: allTranslations.text('hint2_title'),
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  keyboardType: TextInputType.text,
                  controller: _prenomController,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('datnaiss_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      controller: _datnaissController,
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
                        showDatePicker(
                                context: context,
                                initialDate: _datenaiss == null
                                    ? DateTime.now()
                                    : _datenaiss!,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now())
                            .then((date) {
                          setState(() {
                            _datenaiss = date!;
                            String vj = "";
                            String vm = "";
                            var date1 = DateTime.parse(_datenaiss.toString());
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
                            _datnaissController.text = formattedDate;
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
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('ville_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: allTranslations.text('hint4_title')),
                  keyboardType: TextInputType.text,
                  controller: _villeController,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('adresse_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: allTranslations.text('hint3_title')),
                  keyboardType: TextInputType.text,
                  controller: _adresseController,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('phone1_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: allTranslations.text('hint5_title')),
                  keyboardType: TextInputType.phone,
                  controller: _phone1Controller,
                  enabled: false,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('email_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: allTranslations.text('hint7_title')),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Text(
                allTranslations.text('cni_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      contentPadding: const EdgeInsets.all(15.0),
                      hintText: allTranslations.text('hint8_title')),
                  keyboardType: TextInputType.text,
                  controller: _cnicontroller,
                ),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new Center(
                  child: new InkWell(
                    onTap: _submitForms,
                    child: new Container(
                      width: 350.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        color: color,
                        border: new Border.all(color: Colors.white, width: 2.0),
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
                )),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
          ]),
    ));
  }
}
