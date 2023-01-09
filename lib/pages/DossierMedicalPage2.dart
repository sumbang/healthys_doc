import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/SizeConfig.dart';
import 'package:healthys_medecin/models/Contenu.dart';
import 'package:healthys_medecin/pages/AntecedentPatient.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/DetailConsultation.dart';
import 'ConsultationPage.dart';
import 'HomePage.dart';
import 'HomePageNew.dart';
import 'NewDossierPage.dart';
import 'PdfViewer.dart';

class DossierMedicalPage2 extends StatelessWidget {
  String numero;

  DossierMedicalPage2(this.numero);

  // This widget is the root of your application.
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
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              // Tells the system which are the supported languages
              supportedLocales: allTranslations.supportedLocales(),
              home: DossierMedical(this.numero),
            );
          },
        );
      },
    );
  }
}

class DossierMedical extends StatefulWidget {
  String id;

  DossierMedical(this.id);

  @override
  DossierMedicalPageState createState() => new DossierMedicalPageState(this.id);
}

class DossierMedicalPageState extends State<DossierMedical> {
  String id;
  DossierMedicalPageState(this.id);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool isVideo = false;
  bool isVisible = false;
  bool isAccess = true;
  Future<String>? contenu;
  List<Contenu> base = [];
  List<Contenu> urgence = [];
  List<Contenu> docteur = [];
  List<Contenu> consultation = [];

  void initState() {
    _loadUser();
    super.initState();
    contenu = _getDossier();
  }

    String perso = "";

     _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      perso = (prefs.getString('currentperso') ?? "");
    });
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  /* void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url'; */

  _launchURL(String file) async {
    String url = Setting.serveurpdf + file;

    print("lien : " + url);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewWithJavaScript(String file) async {
     String url = Setting.serveurpdf + file;
     print("lien : " + url);
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Widget> _buildExpandableContent(List<Contenu> items) {
    List<Widget> listElementWidgetList = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                child: Text(items[i].libelle.toString() + " : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black)),
              ),
              flex: 1,
            ),
            new Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                child: Text(items[i].valeur.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black)),
              ),
              flex: 1,
            )
          ],
        ),
      ));
    }

    return listElementWidgetList;
  }

  List<Widget> _buildExpandableContent1(List<Contenu> items) {
    List<Widget> listElementWidgetList = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("Date : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: color)),
                  ),
                  flex: 1,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text(items[i].date.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black)),
                  ),
                  flex: 1,
                )
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              child: Text(items[i].libelle.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.black)),
            ),
            new Center(
              child: new InkWell(
                onTap: () {
                  print("fichier : " + items[i].valeur);

                    Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          PdfViewer(items[i].valeur)));

                 // _launchURL(items[i].valeur);
                },
                child: new Container(
                  width: 150.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: color,
                    border: new Border.all(color: Colors.white, width: 2.0),
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  child: new Center(
                    child: new Text(
                      allTranslations.text("z113"),
                      style: new TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(color: Colors.grey, height: 1),
            SizedBox(height: 5),
          ],
        ),
      ));
    }

    return listElementWidgetList;
  }

  Future<String> _getDossier() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    MySingleton mySingleton = new MySingleton();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1; 

    print("langue :" + mySingleton.getLangue.toString());

    var response = await http.get(
        Setting.apiracine +
            "consultation/dossier?numero=" +
            this.id.toString() +
            "&type=1",
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA2 :" + response.body.toString());

      return response.body.toString();
   
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return Scaffold(
        backgroundColor: Color(0xffF8F8FA),
        body: FutureBuilder<String>(
            future: contenu,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Divider(
                          color: Colors.transparent,
                          height: 100.0,
                        ),
                        Icon(
                          Icons.error,
                          size: 120.0,
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.0,
                        ),
                        Text(allTranslations.text('erreur_title'),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.black)),
                      ],
                    )),
                  );
                } else if (snapshot.data.toString().contains("PHP Notice")) {
                  return Container(
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Divider(
                          color: Colors.transparent,
                          height: 100.0,
                        ),
                        Icon(
                          Icons.error,
                          size: 120.0,
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 5.0,
                        ),
                        Text(allTranslations.text('erreur_title'),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: Colors.black)),
                      ],
                    )),
                  );
                } else {
                  final responseJson = json.decode(snapshot.data.toString());
                  base.clear();
                  urgence.clear();
                  docteur.clear();
                  consultation.clear();

                  print("base : "+responseJson["base"].toString());

                  for (int i = 0; i < responseJson["base"].length; i++) {
                    Contenu contenu = Contenu.fromJson(responseJson["base"][i]);
                    base.add(contenu);
                  }

                  for (int i = 0; i < responseJson["urgence"].length; i++) {
                    Contenu contenu =
                        Contenu.fromJson(responseJson["urgence"][i]);
                    urgence.add(contenu);
                  }

                  for (int i = 0; i < responseJson["docteur"].length; i++) {
                    Contenu contenu =
                        Contenu.fromJson(responseJson["docteur"][i]);
                    docteur.add(contenu);
                  }

                  for (int i = 0;
                      i < responseJson["consultation"].length;
                      i++) {
                    Contenu contenu =
                        Contenu.fromJson(responseJson["consultation"][i]);
                    consultation.add(contenu);
                  }

                  return new Stack(
                    children: <Widget>[
                      Container(
                        color: color,
                        height: 25 * SizeConfig.heightMultiplier,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              top: 6 * SizeConfig.heightMultiplier),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new IconButton(
                                    icon: new Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if(perso == "1") {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new HomePageNew()),
                  );
                  }else {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (_) => new HomePage()),
                  );
                  }
                                    },
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        allTranslations
                                                .text('ds')
                                                .toUpperCase() +
                                            " " +
                                            id.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      new Center(
                                        child: new InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (_) =>
                                                      new NewDossierPage(
                                                          this.id.toString())),
                                            );
                                          },
                                          child: new Container(
                                            width: 250.0,
                                            height: 50.0,
                                            decoration: new BoxDecoration(
                                              color: color2,
                                              border: new Border.all(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                            child: new Center(
                                              child: new Text(
                                                allTranslations.text("z221"),
                                                style: new TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20 * SizeConfig.heightMultiplier),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                topLeft: Radius.circular(30.0),
                              )),
                          child: SingleChildScrollView(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.0, right: 30.0, top: 20.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations.text('d1').toUpperCase(),
                                      style: TextStyle(
                                          color: color2,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier),
                                    ),
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Column(
                                  children: _buildExpandableContent(base),
                                ),
                              ),  SizedBox(
                                        height: 20,
                                      ),
                                      new Center(
                                        child: new InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (_) =>
                                                      new AntecedentPatient(
                                                          this.id.toString())),
                                            );
                                          },
                                          child: new Container(
                                            width: 250.0,
                                            height: 50.0,
                                            decoration: new BoxDecoration(
                                              color: color,
                                              border: new Border.all(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                            child: new Center(
                                              child: new Text(
                                                "Antécédents médicaux",
                                                style: new TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    
                              SizedBox(
                                height: 30.0,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations
                                          .text('urgence_title')
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: color2,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier),
                                    ),
                                  )),
                              SizedBox(height: 10.0),
                              Container(
                                child: Column(
                                  children: _buildExpandableContent(urgence),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations
                                          .text('medecin_title')
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: color2,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier),
                                    ),
                                  )),
                              SizedBox(height: 10.0),
                              Container(
                                child: Column(
                                  children: _buildExpandableContent(docteur),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations.text('d2').toUpperCase(),
                                      style: TextStyle(
                                          color: color2,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier),
                                    ),
                                  )),
                              SizedBox(height: 10.0),
                              Container(
                                child: Column(
                                  children:
                                      _buildExpandableContent1(consultation),
                                ),
                              ),
                              SizedBox(height: 30.0),
                            ],
                          )),
                        ),
                      )
                    ],
                  );
                }
              } else {
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              }
            }));
  }
}
