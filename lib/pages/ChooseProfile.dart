import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/pages/HomePageNew.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'HomePage.dart';

class ChooseProfilePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
      home: new ChooseProfilePage1(),
    );
  }
}

class ChooseProfilePage1 extends StatefulWidget {
  ChooseProfilePage1();

  @override
  ChooseProfilePageState createState() => new ChooseProfilePageState();
}

class ChooseProfilePageState extends State<ChooseProfilePage1> {
  ChooseProfilePageState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);
  String codeuser = "";
  String roleuser = "";
  String nomuser = "";
  String token = "";
  String datemembre = "";
  bool _isSaving = true;
  List<String> ids;
  List<String> noms;
  List<String> patients;
  List<String> pins;
  List<String> numeros;
  List<String> photos;
  List<String> payer;
  List<String> integral;
  List<String> perso;
  String currentid = "1";
  String currentpatient = "";
  String currentacces = "";
  String username = "";
  String currentnom = "";
  String currentpin = "";
  String currentphoto = "";
  String currentpayer = "";
  String currentint = "";
  String currentperso = "";
  var currentMeneu = <Widget>[];

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      ids = (prefs.getStringList('ids') ?? []);
      noms = (prefs.getStringList('noms') ?? []);
      patients = (prefs.getStringList('patients') ?? []);
      pins = (prefs.getStringList('pins') ?? []);
      numeros = (prefs.getStringList('numeros') ?? []);
      photos = (prefs.getStringList('photos') ?? []);
      payer = (prefs.getStringList('payer') ?? []);
      integral = (prefs.getStringList('integral') ?? []);
      perso = (prefs.getStringList('perso') ?? []);
      token = (prefs.getString('token') ?? '');
    });

    print("taille : " + photos.length.toString());
  }

  void initState() {
    _loadUser();
    super.initState();
  }

  Future<void> _makeLogout() async {
    showDialog(
      context: context,
      barrierDismissible: _isSaving,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(allTranslations.text('progress_title')),
          content: new Center(
              child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          )),
        );
      },
    );

    setState(() {
      _isSaving = false;
    });

    Map data = {
      'TOKEN': token.toString(),
    };

    var res = await http.put(Setting.apiracine + "comptes/logout", body: data);

    final prefs = await SharedPreferences.getInstance();

    if (res.statusCode == 200) {
      setState(() {
        prefs.remove('token');
        prefs.remove('datemembre');
        prefs.remove('nom');
        prefs.remove('id');
        prefs.remove('role');
        prefs.remove('biometrie');
        prefs.remove('currentid');
        prefs.remove('currentpatient');
        prefs.remove('currentnom');
        prefs.remove('currentphoto');
        prefs.remove('currentpin');
        prefs.remove('ids');
        prefs.remove('noms');
        prefs.remove('patients');
        prefs.remove('pins');
        prefs.remove('currentpayer');
        prefs.remove('currentint');
      });

      Navigator.of(context, rootNavigator: true).pop('dialog');

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (_) => new MyApp()),
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');

      var responseJson = json.decode(res.body);

      Fluttertoast.showToast(
          msg: responseJson['message'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    }
  }



  _setCurrentuser(int pos) async {
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
    String role = (prefs.getString('role') ?? '');
    String user = (prefs.getString('currentid') ?? '');
    String profil = (prefs.getString('currentpatient') ?? '');
    String basicAuth = 'Bearer ' + token1;

    print("DOC :" + ids[pos].toString());

    var response = await http.get(
        Setting.apiracine + "comptes/check1?medecin=" + ids[pos].toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA4 :" + response.body.toString());

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      Navigator.of(context, rootNavigator: true).pop('dialog');

      Fluttertoast.showToast(
          msg: "Profil chargé",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white);

      prefs.setString('currentid', ids[pos].toString());
      prefs.setString('currentpatient', patients[pos].toString());
      prefs.setString('currentnom', noms[pos].toString());
      prefs.setString('currentnumero', numeros[pos].toString());
      prefs.setString('currentphoto', photos[pos].toString());
      prefs.setString('currentpin', pins[pos].toString());
      prefs.setString('currentperso', perso[pos].toString());
      prefs.setString('currentpayer', responseJson["payer"].toString());
      prefs.setString('currentint', responseJson["integral"].toString());

      if(perso[pos].toString() == "1") {

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (_) => new HomePageNew()),
      );
      }
      else {

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (_) => new HomePage()),
      );
      }

    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');

      Fluttertoast.showToast(
          msg: allTranslations.text("z44"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    }
  }

  List<Widget> _buildProfile(BuildContext) {
    List<Widget> listElement = [];

    print("taille : " + patients.length.toString());

    for (int i = 0; i < photos.length; i++) {

         listElement.add(new GestureDetector(
          onTap: () {
            _setCurrentuser(i);
          },
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                      child: Container(
                          width: 100,
                          height: 100,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new NetworkImage(
                                    Setting.serveurimage1 +
                                        '' +
                                        photos[i].toString(),
                                  )))),
                    ),
                    flex: 1,
                  ),
                  SizedBox(width: 20),
                  new Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                      child: Text(noms[i].toString().toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 19,
                              color: Colors.black)),
                    ),
                    flex: 4,
                  )
                ],
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.grey,
            ),
          ])));
    }
         
         listElement.add(new   Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new Center(
                  child: new InkWell(
                    onTap: _makeLogout,
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
                          allTranslations.text('menu27_title'),
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )));

    return listElement;
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return new WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(allTranslations.text("z43")),
              backgroundColor: color,
              elevation: 0,
              leading: null,
            ),
            body: (patients != null)
                ? new Column(
                    children: _buildProfile(context),
                  )
                : Container()));
  }
}
