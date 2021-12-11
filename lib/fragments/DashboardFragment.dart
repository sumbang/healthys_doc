import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/Indice.dart';
import 'package:healthys_medecin/models/Menu.dart';
import 'package:healthys_medecin/pages/AnnuairePage.dart';
import 'package:healthys_medecin/pages/AntecedantPage.dart';
import 'package:healthys_medecin/pages/AssurancePage.dart';
import 'package:healthys_medecin/pages/CarteDigitalePage.dart';
import 'package:healthys_medecin/pages/Consultation2.dart';
import 'package:healthys_medecin/pages/Consultation4.dart';
import 'package:healthys_medecin/pages/ConsultationPage.dart';
import 'package:healthys_medecin/pages/DocumentPage.dart';
import 'package:healthys_medecin/pages/DossierMedicalPage2.dart';
import 'package:healthys_medecin/pages/MaCarteProPage.dart';
import 'package:healthys_medecin/pages/MedicalReportPage.dart';
import 'package:healthys_medecin/pages/RdvPage.dart';
import 'package:healthys_medecin/pages/Rendezvous2Page.dart';
import 'package:healthys_medecin/pages/SouscriptionMatriculePage.dart';
import 'package:healthys_medecin/pages/VaccinPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

import 'AssuranceFragment.dart';
import 'AutoDepistageFragment.dart';
import 'CompteFragment.dart';
import 'ConsultationFragment.dart';
import 'DossierMedicalFragment.dart';
import 'InfosFragment.dart';
import 'MaCarteFragment.dart';
import 'MedecinFragment.dart';
import 'ParametreFragment.dart';
import 'RendezVousFragment.dart';
import 'SettingFragment.dart';
import 'UrgenceFragment.dart';

class DashboardFragment extends StatefulWidget {
  DashboardFragment();

  @override
  DashboardFragmentState createState() => new DashboardFragmentState();
}

class DashboardFragmentState extends State<DashboardFragment> {
  DashboardFragmentState();

  String currentrole = "";
  String currentpatient = "";
  String currentnumero = "";
  String currentpin = "";
  String currentacces = "";
  String token = "";
  Future<List<Indice>> indicateurs;
  TextEditingController _outputController;
  TextEditingController _securityController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _securityController.dispose();
    super.dispose();
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      currentrole = (prefs.getString('role') ?? '');
      currentpatient = (prefs.getString('currentpatient') ?? '');
      currentnumero = (prefs.getString('currentnumero') ?? '');
      currentpin = (prefs.getString('currentpin') ?? '');
      token = (prefs.getString('token') ?? '');
      currentacces = (prefs.getString('role') ?? '');

      indicateurs = getIndicateurs();
    });
  }

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  Future<List<Indice>> getIndicateurs() async {
    String credential = token + ":" + '';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$credential'));

    var response = await http.get(
        Setting.apiracine + "comptes/indicateur?role=" + currentrole,
        headers: {"Authorization": basicAuth});

    print("DATA1 :" + response.body.toString());

    List<Indice> maliste = List();

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      for (int i = 0; i < responseJson.length; i++) {
        maliste.add(Indice.fromJson(responseJson[i]));
      }

      return maliste;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    _loadUser();

    this._outputController = new TextEditingController();
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashboardFragment();
      case 1:
        return new AutoDepistageFragment();
      case 2:
        return new ConsultationFragment();
      case 3:
        return new DossierMedicalFragment();
      case 4:
        return new InfosFragment();
      case 5:
        return new MedecinFragment();
      case 6:
        return new ParametreFragment();
      case 7:
        return new RendezVousFragment();
      case 8:
        return new SettingFragment();
      case 9:
        return new MaCarteFragment();
      case 10:
        return new AssuranceFragment();
      case 11:
        return new UrgenceFragment();
      case 12:
        return new CompteFragment();

      default:
        return new Text("Error");
    }
  }

  _SecurityBox(Widget route) {
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
                              backgroundColor: Colors.blue,
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
                          color: color,
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
        });
  }

  Widget setup1AlertDialoadContainer() {
    List<Widget> maliste = new List();

    maliste.add(new ListTile(
      leading: Icon(Icons.person_pin),
      title: Text(
        "PATIENT AVEC MATRICULE SANTÉ",
        style: TextStyle(fontSize: 10),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (_) => new SouscriptionMatriculePage()),
        );
      },
    ));

    maliste.add(new ListTile(
      leading: Icon(Icons.person_pin),
      title: Text(
        "PATIENT SANS MATRICULE SANTÉ",
        style: TextStyle(fontSize: 10),
      ),
      onTap: () {},
    ));

    return Container(
        // height: double.parse(largeur.toString()), // Change as per your requirement
        height: 180.0,
        width: 300.0, // Change as per your requirement
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: maliste,
        ));
  }

  _redirect(int position) {
    if (position == 9) {
      _SecurityBox(new CarteDigitalePage());
    } else if (position == 2) {
      _SecurityBox(new ConsultationPage());
    } else if (position == 3) {
      _SecurityBox(new AntecedantPage());
    } else if (position == 10) {
      _SecurityBox(new AssurancePage());
    } else if (position == 7) {
      _SecurityBox(new RdvPage());
    } else if (position == 5) {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (_) => new AnnuairePage()),
      );
    } else if (position == 11) {
      _SecurityBox(new Consultation2());
    } else if (position == 12) {
      //_scan();
      _SecurityBox(new DocumentPage());
    } else if (position == 0) {
    } else if (position == 13) {
      _SecurityBox(new VaccinPage());
    } else if (position == 14) {
      _SecurityBox(new MaCarteProPage());
    } else if (position == 15) {
      _SecurityBox(new MedicalReportPage());
    } else if (position == 16) {
      _SecurityBox(new Rendezvous2Page());
    } else if (position == 17) {
      _SecurityBox(new DossierMedicalPage2(currentnumero));
    } else if (position == 18) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(allTranslations.text('adp1')),
              content: setup1AlertDialoadContainer(),
            );
          });
      //_SecurityBox(new DossierMedicalPage2(currentnumero));
    }
  }

  List<Card> getStructuredGridCell(List<Menu> menu) {
    List<Card> list = new List();

    for (int i = 0; i < menu.length; i++) {
      list.add(new Card(
          elevation: 1.5,
          child: new GestureDetector(
              onTap: () {
                _redirect(menu[i].id);
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
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
                          color: color2,
                          fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                  )),
                  new Divider(
                    height: 5.0,
                    color: Colors.transparent,
                  ),
                  new Image.asset(
                    menu[i].icone,
                    alignment: Alignment.center,
                    height: 100.0,
                  )
                ],
              ))));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    List<Menu> menus = new List();
    Menu menu1 = new Menu(
        9, allTranslations.text('macarte_title'), 'img/carte-digitale.png');
    menus.add(menu1);

    Menu menu2 = new Menu(2, allTranslations.text('mconsultation_title'),
        'img/historique-soins.png');
    menus.add(menu2);

    Menu menu3 = new Menu(3, allTranslations.text('menu31_title'),
        'img/antecedents-medicaux.png');
    menus.add(menu3);

    Menu menu4 = new Menu(10, allTranslations.text('assurance_title'),
        'img/assurance-maladie.png');
    menus.add(menu4);

    Menu menu5 =
        new Menu(7, allTranslations.text('prise_title'), 'img/prise-rdv2.png');
    menus.add(menu5);

    Menu menu6 =
        new Menu(5, allTranslations.text('annuaire_title'), 'img/annuaire.png');
    menus.add(menu6);

    Menu menu7 =
        new Menu(13, allTranslations.text('vaccin_title'), 'img/vaccin.png');
    menus.add(menu7);

    Menu menu8 = new Menu(17, allTranslations.text('carnet'),
        'img/informations-personnelles.png');
    menus.add(menu8);

    List<Menu> mens = new List();
    Menu men1 = new Menu(
        14, allTranslations.text('macartepro_title'), 'img/carte-digitale.png');
    mens.add(men1);

    Menu men2 = new Menu(11, allTranslations.text('mconsultation2_title'),
        'img/historique-soins.png');
    mens.add(men2);

    Menu men3 = new Menu(15, allTranslations.text('dossier_title'),
        'img/antecedents-medicaux.png');
    mens.add(men3);

    Menu men5 = new Menu(12, "Mes documents", 'img/identifiants-connexion.png');
    mens.add(men5);

    /*Menu men4 =
        new Menu(16, allTranslations.text('rdv_title'), 'img/prise-rdv2.png');
    mens.add(men4);

    Menu men5 = new Menu(12, allTranslations.text('identif2_title'),
        'img/identifiants-connexion.png');
    mens.add(men5); 

    Menu men6 = new Menu(18, allTranslations.text('carnet1'),
        'img/informations-personnelles.png');
    mens.add(men6);*/

    return Scaffold(
      backgroundColor: Colors.white,
      body: new Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: GridView.count(
            primary: true,
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            children:
                getStructuredGridCell(currentacces == "1" ? menus : mens)),
        // ],
        // )

        /* child: new FutureBuilder(
            future: indicateurs,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              if (!snapshot.hasData)
                // Shows progress indicator until the data is load.
                return new Container(
                  child: new Center(
                    child: new CircularProgressIndicator(),
                  ),
                );

              // Shows the real data with the data retrieved.
              List indicateurs = snapshot.data;

              if(indicateurs.length == 0) return new Center(
                child: new Text("Vivez l'expérience de l'assurance digitale à travers nos modules.",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26.0),textAlign: TextAlign.center,),
              );

              else {

                if(indicateurs.length != 0) {

                  List<Widget> _tiles = <Widget>[];
                  List<StaggeredTile> _staggeredTiles =  <StaggeredTile>[];

                  List colors = [Colors.red, Colors.green, Colors.orange, Colors.lightBlue, Colors.amber, Colors.brown, Colors.deepOrange, Colors.pink,Colors.purple];
                  Random random = new Random();
                  int index = 0;

                  for (int i = 0; i < indicateurs.length; i++) {

                    Indice indicateur = indicateurs[i];

                    index = random.nextInt(9);

                    _Tuile tuile = new _Tuile(colors[index], indicateur.valeur, indicateur.libelle);

                    StaggeredTile ti = new StaggeredTile.count(2, 2);

                    _tiles.add(tuile); _staggeredTiles.add(ti);

                  }

                  return new Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: new StaggeredGridView.count(
                        crossAxisCount: 4,
                        staggeredTiles: _staggeredTiles,
                        children: _tiles,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        padding: const EdgeInsets.all(4.0),
                      ));

                }

                else return Container();



              }

            }),
        */
      ),
    );
  }

  Future _scan() async {
  /*  String barcode = await scanner.scan();

    // String barcode = "22011237001";

    Fluttertoast.showToast(
        msg: allTranslations.text('wait_title'),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 5,
        backgroundColor: Colors.blue,
        textColor: Colors.white);

    // verification du code

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Setting.apiracine + "consultations/check?numero=" + barcode.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (_) => new Consultation4(barcode)),
      );
    } else {
      var responseJson = json.decode(response.body);

      Fluttertoast.showToast(
          msg: responseJson["message"].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.orange,
          textColor: Colors.white);
    }*/
  }
}

class _Tuile extends StatelessWidget {
  const _Tuile(this.backgroundColor, this.titre, this.label);

  final Color backgroundColor;
  final String titre;
  final String label;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {},
        child: new Center(
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(titre.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: Colors.white)),
                new Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),
                new Text(label.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
