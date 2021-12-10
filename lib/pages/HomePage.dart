import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/SizeConfig.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/main.dart';
import 'package:healthys_medecin/models/Menu.dart';
import 'package:healthys_medecin/pages/ActivationPage.dart';
import 'package:healthys_medecin/pages/ChooseProfile.dart';
import 'package:healthys_medecin/pages/ComptePage.dart';
import 'package:healthys_medecin/pages/ConfidentialitePage.dart';
import 'package:healthys_medecin/pages/Consultation2.dart';
import 'package:healthys_medecin/pages/DocumentPage.dart';
import 'package:healthys_medecin/pages/DossierMedicalPage2.dart';
import 'package:healthys_medecin/pages/MaCartePage.dart';
import 'package:healthys_medecin/pages/MedicalReportPage.dart';
import 'package:healthys_medecin/pages/NewPatientPag.dart';
import 'package:healthys_medecin/pages/NewVaccinPage.dart';
import 'package:healthys_medecin/pages/NewsPage.dart';
import 'package:healthys_medecin/pages/RdvPage.dart';
import 'package:healthys_medecin/pages/VaccinPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:unicorndial/unicorndial.dart';
import 'LoginPage.dart';
import 'NewPatientPage.dart';

class HomePage extends StatelessWidget {
  HomePage();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: true,
              title: 'HomeScreen App',
              home: HomePage1(),
            );
          },
        );
      },
    );
  }
}

class HomePage1 extends StatefulWidget {
  HomePage1();

  @override
  HomePage1State createState() => new HomePage1State();
}

class DrawerItem {
  String title;
  IconData icon;
  int position;
  DrawerItem(this.title, this.icon, this.position);
}

class HomePage1State extends State<HomePage1> {
  HomePage1State();

  final graycolor = const Color(0xFFdededc);
  String plat_nb = "";
  String cmd_nb = "";
  String recette = "";

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
  String currentid = "1";
  String currentpatient = "";
  String currentacces = "";
  String username = "";
  String currentnom = "";
  String currentpin = "";
  String enregistrer = "";
  String abonner = "";
  String consulter = "";
  String voir = "";
  String currentphoto = "";
  String currentpayer = "";
  String currentint = "";
  var currentMeneu = <Widget>[];
  var _fabMiniMenuItemList;

  final color = const Color(0xFF8f0c6f);
  final color2 = const Color(0xFF000000);
  final color3 = const Color(0xFFcd005f);
  final color4 = const Color(0xFF19467d);

  final _formAutoKey = GlobalKey<FormState>();

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      ids = (prefs.getStringList('ids') ?? []);
      noms = (prefs.getStringList('noms') ?? []);
      patients = (prefs.getStringList('patients') ?? []);
      pins = (prefs.getStringList('pins') ?? []);
      numeros = (prefs.getStringList('numeros') ?? []);
      photos = (prefs.getStringList('photos') ?? []);

      codeuser = (prefs.getString('currentid') ?? '');
      currentacces = (prefs.getString('role') ?? '');
      currentnom = (prefs.getString('currentnom') ?? '');
      nomuser = (prefs.getString('nom') ?? '');
      currentphoto = (prefs.getString('currentphoto') ?? '');
      username = (prefs.getString('nom') ?? '');
      currentpatient = (prefs.getString('currentpatient') ?? '');
      currentpin = (prefs.getString('currentpin') ?? '');

      token = (prefs.getString('token') ?? '');
      datemembre = (prefs.getString('datemembre') ?? '');

      enregistrer = (prefs.getString('enregistrer') ?? '');
      abonner = (prefs.getString('abonner') ?? '');
      voir = (prefs.getString('voir') ?? '');
      consulter = (prefs.getString('consulter') ?? '');
      currentpayer = (prefs.getString('currentpayer') ?? '');
      currentint = (prefs.getString('currentint') ?? '');
    });
  }

  void initState() {
    _loadUser();
    print("debut1 : " +
        currentphoto +
        " - " +
        enregistrer +
        " - " +
        currentnom +
        " - " +
        currentpayer);
    super.initState();
  }

  refresh() async {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token1 = (prefs.getString('token') ?? '');
    String role = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var res = await http.get(
        Setting.apiracine +
            "comptes/indicateur?role=" +
            currentacces.toString(),
        headers: {
          "Language": allTranslations.currentLanguage.toString(),
          "Authorization": basicAuth,
        });

    if (res.statusCode == 200) {
      var responseJson = json.decode(res.body);

      String enregistrer = responseJson['enregistrement'].toString();
      String abonner = responseJson['abonner'].toString();
      String voir = responseJson['voir'].toString();
      String consulter = responseJson['consulter'].toString();

      final prefs = await SharedPreferences.getInstance();

      print("photo : " + photos[0].toString());

      setState(() {
        prefs.setString('enregistrer', enregistrer);
        prefs.setString('abonner', abonner);
        prefs.setString('voir', voir);
        prefs.setString('consulter', consulter);
      });

      Navigator.of(context, rootNavigator: true).pop('dialog');

      Fluttertoast.showToast(
          msg: "Chargement des indicateurs",
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

      Fluttertoast.showToast(
          msg: responseJson["message"].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    }
  }

  _about() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('A propos de l\'application'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
                new Text(
                  "Version",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),
                new Text(
                  "Version 1.0",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.left,
                ),
                new Divider(
                  height: 20.0,
                  color: Colors.transparent,
                ),
                new Text(
                  "Copyright",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                new Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),
                new Text(
                  "© 2021 HEALTH'YS MEDECIN",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          );
        });
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

  _deconnexion(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(allTranslations.text('logout3')),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text(allTranslations.text('logout2')),
      onPressed: () {
        _makeLogout();

        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(allTranslations.text('logout1')),
      content: Text(allTranslations.text('logout')),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _optionmenu() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('OPTIONS DE MENU'),
            content: setupMenuDialog(),
          );
        });
  }

  Widget setupMenuDialog() {
    List<Widget> maliste1 = new List();

    /*  maliste1.add(new ListTile(
      leading: Icon(Icons.refresh),
      title: Text("Actualiser"),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        refresh();
      },
    )); */

    maliste1.add(new ListTile(
      leading: Icon(Icons.person),
      title: Text("Mon compte"),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _SecurityBox(new ComptePage());
      },
    ));

    maliste1.add(new ListTile(
      leading: Icon(Icons.help),
      title: Text("A propos de l'application"),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _about();
      },
    ));

    maliste1.add(new ListTile(
      leading: Icon(Icons.person_add),
      title: Text("Changer de profil"),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _SecurityBox(new ChooseProfilePage());
      },
    ));

   /* maliste1.add(new ListTile(
      leading: Icon(Icons.security),
      title: Text("Confidentialité"),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        Navigator.push(
          context,
          new MaterialPageRoute(builder: (_) => new ConfidentialitePage()),
        );
      },
    ));*/

    maliste1.add(new ListTile(
      leading: Icon(Icons.arrow_back),
      title: Text("Déconnexion"),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _deconnexion(context);
      },
    ));

    Widget maliste = ListView(
      children:
          ListTile.divideTiles(context: context, tiles: maliste1).toList(),
    );

    return Container(
        height: 300, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: maliste);
  }

  TextEditingController _securityController = TextEditingController();

  _SecurityBox(Widget route) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (_) => route),
    );

    /* showDialog(
        context: context,
        barrierDismissible: false,
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
                          allTranslations.text('s3'),
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
                              _securityController.text = "";
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
            content: Container(
                height: 125.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        allTranslations.text('s1'),
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            height: 2.0,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
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
                          if (value.isEmpty) {
                            return allTranslations.text('requis_title');
                          }
                        },
                      ),
                    )
                  ],
                )),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, top: 2.0),
                  child: new Center(
                    child: new InkWell(
                      onTap: () {
                        // verification du pin de connexion

                        String _security = _securityController.text.toString();

                        if ((_security != currentpin.toString()) ||
                            (_security.isEmpty)) {
                          Fluttertoast.showToast(
                              msg: allTranslations.text('s5'),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 5,
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                        } else {
                          _securityController.text = "";

                          Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (_) => route),
                          );
                        }
                      },
                      child: new Container(
                        width: 300.0,
                        height: 50.0,
                        decoration: new BoxDecoration(
                          color: color3,
                          border:
                              new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: new Center(
                          child: new Text(
                            allTranslations.text('s4'),
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          );
        }); */
  }

  _OpenBox() {
    showDialog(
        context: context,
        barrierDismissible: false,
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
                          allTranslations.text('at'),
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
            content: Container(
                height: 145.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Expanded(child: Text(
                        allTranslations.text('at1'),
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            height: 2.0,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      )),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                )),
            actions: <Widget>[
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 5.0, top: 2.0, left: 5.0),
                  child: new Center(
                    child: new InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                      child: new Container(
                        width: 100.0,
                        height: 50.0,
                        decoration: new BoxDecoration(
                          color: color,
                          border:
                              new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: new Center(
                          child: new Text(
                            "OK",
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          );
        });
  }

  List<Card> getStructuredGridCell(List<Menu> menu) {
    List<Card> list = new List();

    for (int i = 0; i < menu.length; i++) {
      list.add(new Card(
          elevation: 1.5,
          child: new GestureDetector(
              onTap: () {
                if (i == 0) {
                  _SecurityBox(new MaCartePage());
                } else if (i == 1) {
                  currentpayer == "0"
                      ? _OpenBox()
                      : _SecurityBox(new Consultation2());
                } /* else if (i == 2) {
                  currentpayer == "0"
                      ? _OpenBox()
                      : _SecurityBox(new MedicalReportPage());
                } */
                else if (i == 2) {
                  currentpayer == "0"
                      ? _OpenBox()
                      : _SecurityBox(new RdvPage());
                } /* else if (i == 4) {
                  currentpayer == "0"
                      ? _OpenBox()
                      : _SecurityBox(new DocumentPage());
                }*/
                else if (i == 3) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new MedicalReportPage()),
                  );
                }
                 else if (i == 4) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new NewsPage()),
                  );
                }
                /*else if (i == 7) {
                  currentpayer == "0"
                      ? _OpenBox()
                      : _SecurityBox(new VaccinPage());
                }*/
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Divider(
                    height: 20.0,
                    color: Colors.transparent,
                  ),
                  new Image.asset(
                    menu[i].icone,
                    alignment: Alignment.center,
                    height: 100.0,
                  ),
                  new Divider(
                    height: 5.0,
                    color: Colors.transparent,
                  ),
                  new Center(
                      child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: new Text(
                      menu[i].libelle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ],
              ))));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    Widget setup1AlertDialoadContainer1() {
      List<Widget> maliste = new List();

      maliste.add(new ListTile(
        leading: Icon(Icons.person_pin),
        title: Text(
          "PATIENT AVEC MATRICULE SANTÉ",
          style: TextStyle(fontSize: 16),
        ),
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (_) => new NewPatientPage()),
          );
        },
      ));

      maliste.add(new ListTile(
        leading: Icon(Icons.person_pin),
        title: Text(
          "PATIENT SANS MATRICULE SANTÉ",
          style: TextStyle(fontSize: 16),
        ),
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (_) => new NewPatientPag()),
          );
        },
      ));

      return Container(
          // height: double.parse(largeur.toString()), // Change as per your requirement
          height: 140.0,
          width: 300.0, // Change as per your requirement
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: maliste,
          ));
    }

    void _addconsultation() {
      if (currentpayer == "0")
        _OpenBox();
      else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(allTranslations.text('nc').toUpperCase()),
                content: setup1AlertDialoadContainer1(),
              );
            });
      }
    }

    void _addVaccin() {
      if (currentpayer == "0")
        _OpenBox();
      else {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (_) => new NewVaccinPage()),
        );
      }
    }

    var _option3 = [
      new FabMiniMenuItem.withText(
          new Icon(Icons.person_add),
          Colors.blue,
          4.0,
          "nc",
          _addconsultation,
          allTranslations.text('nc'),
          color,
          Colors.white,
          true),
      /* new FabMiniMenuItem.withText(new Icon(Icons.person_add), Colors.blue, 4.0,
          "nc", _addVaccin, "Nouveau vaccin", Colors.green, Colors.white, true), */
    ];

    List<Menu> menus = new List();
    Menu menu = new Menu(1, "CARTE DIGITALE PRO", 'img/carte-digitale.png');
    menus.add(menu);

    Menu menu0 = new Menu(2, "MES CONSULTATIONS", 'img/historique-soins.png');
    menus.add(menu0);

    Menu menu7 = new Menu(4, "MES RENDEZ-VOUS", 'img/prise-rdv2.png');
    menus.add(menu7);
    
    Menu menu3 =
        new Menu(5, "DOSSIERS MEDICAUX", 'img/antecedents-medicaux.png');
     menus.add(menu3);

    Menu menu4 = new Menu(4, "MES DOCUMENTS", 'img/identifiants-connexion.png');
    // menus.add(menu4);

    Menu menu2 = new Menu(4, "ACTIVER UN COMPTE", 'img/activation.png');
    // menus.add(menu2);

    Menu menu5 = new Menu(4, "HEALTH NEWS", 'img/news.png');
    menus.add(menu5);

    Menu menu8 = new Menu(8, "CARNET DE VACCINATION", 'img/vaccin.png');
    //menus.add(menu8);

    return new WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
          backgroundColor: Color(0xffF8F8FA),
          body: new Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                color: color3,
                height: 30 * SizeConfig.heightMultiplier,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 6 * SizeConfig.heightMultiplier),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (currentphoto.toString().isNotEmpty)
                              ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      Setting.serveurimage1 +
                                          '' +
                                          currentphoto.toString()),
                                )
                              : Container(),
                          SizedBox(
                            width: 15.0,
                          ),
                          Flexible(
                              child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(currentnom.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                          SizedBox(
                            width: 15.0,
                          ),
                          new Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                  onTap: _optionmenu,
                                  child: new Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                  )))
                        ],
                      ),
                      SizedBox(
                        height: 0.0,
                      ),
                      /* Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ACTIVATIONS",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 5.0,
                                  width: 50.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  abonner.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            flex: 1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "CONSULTATIONS",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 5.0,
                                  width: 50.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  consulter.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            flex: 1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "RENDEZ-VOUS",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 5.0,
                                  width: 50.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  voir.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            flex: 1,
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 13 * SizeConfig.heightMultiplier),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(0.0),
                        topLeft: Radius.circular(0.0),
                      )),
                  child: GridView.count(
                      primary: true,
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      children: getStructuredGridCell(menus)),
                ),
              )
            ],
          ),
          /* floatingActionButton: new Visibility(
            child: FabDialer(_option3, Colors.orange, new Icon(Icons.add)),
          ),*/
        ));
  }
}
