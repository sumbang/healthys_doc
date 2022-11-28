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
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Employe.dart';
import 'package:healthys_medecin/models/Medecin.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import '../models/DetailConsultation.dart';
import 'AnnuairePage.dart';
import 'ConsultationPage.dart';
import 'NewRdvPage.dart';

class DetailMedecin extends StatelessWidget {
  Medecin med;

  DetailMedecin(this.med);

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
              home: DetailMedecin1(this.med),
            );
          },
        );
      },
    );
  }
}

class DetailMedecin1 extends StatefulWidget {
  Medecin med;

  DetailMedecin1(this.med);

  @override
  DetailMedecin1State createState() => new DetailMedecin1State(this.med);
}

class DetailMedecin1State extends State<DetailMedecin1> {
  Medecin med;
  DetailMedecin1State(this.med);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool isVideo = false;

  void initState() {
    super.initState();
  }

  Widget _buildSchedule(List<Employe> list) {
    List<Widget> mList = [];

    for (int b = 0; b < list.length; b++) {
      Employe cmap = list[b];

      mList.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(allTranslations.text('h1') + " : ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: Colors.black)),
              SizedBox(
                width: 10.0,
              ),
              Text(cmap.hopital,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17.0,
                      color: Colors.black)),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(allTranslations.text('h2') + " : ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: Colors.black)),
              SizedBox(
                width: 10.0,
              ),
              Text(cmap.localisation,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17.0,
                      color: Colors.black)),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(allTranslations.text('h3') + " : ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: Colors.black)),
              SizedBox(
                width: 10.0,
              ),
              Text(cmap.horaire,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17.0,
                      color: Colors.black)),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            color: Colors.grey,
            height: 2.0,
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ));
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: mList,
    );
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return Scaffold(
        backgroundColor: Color(0xffF8F8FA),
        body: new Stack(
          children: <Widget>[
            Container(
              color: color2,
              height: 31 * SizeConfig.heightMultiplier,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 10 * SizeConfig.heightMultiplier),
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
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (_) => new AnnuairePage()),
                            );
                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          height: 10 * SizeConfig.heightMultiplier,
                          width: 20 * SizeConfig.widthMultiplier,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      Setting.serveurimage + '' + med.photo))),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(med.nom,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                      color: Colors.white)),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(med.specialite,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18.0,
                                      color: Colors.white)),
                              SizedBox(
                                height: 20.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (_) => new NewRdvPage(med)),
                                  );
                                },
                                child: new Container(
                                  width: 160.0,
                                  height: 50.0,
                                  decoration: new BoxDecoration(
                                    color: color,
                                    border: new Border.all(
                                        color: Colors.transparent, width: 1.0),
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      allTranslations.text('bt2_med'),
                                      style: new TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 32 * SizeConfig.heightMultiplier),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, top: 3 * SizeConfig.heightMultiplier),
                          child: Center(
                            child: Text(
                              allTranslations.text('med1'),
                              style: TextStyle(
                                  color: color2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 2.7 * SizeConfig.textMultiplier),
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, bottom: 20.0, top: 5.0),
                          child: Container(
                            width: 120.0,
                            height: 7.0,
                            child: Container(
                              decoration: new BoxDecoration(
                                color: color2,
                                shape: BoxShape.rectangle,
                                borderRadius: null,
                              ),
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(allTranslations.text('hint5_title') + " : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                      color: Colors.black)),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(med.phone,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17.0,
                                      color: Colors.black)),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(allTranslations.text('email_title') + " : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                      color: Colors.black)),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(med.email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17.0,
                                      color: Colors.black)),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  allTranslations.text('adresse_title') + " : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                      color: Colors.black)),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(med.adresse,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17.0,
                                      color: Colors.black)),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, top: 3 * SizeConfig.heightMultiplier),
                          child: Center(
                            child: Text(
                              allTranslations.text('med2'),
                              style: TextStyle(
                                  color: color2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 2.7 * SizeConfig.textMultiplier),
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, bottom: 20.0, top: 5.0),
                          child: Container(
                            width: 120.0,
                            height: 7.0,
                            child: Container(
                              decoration: new BoxDecoration(
                                color: color2,
                                shape: BoxShape.rectangle,
                                borderRadius: null,
                              ),
                            ),
                          )),
                      _buildSchedule(med.emplois)
                    ]))))
          ],
        ));
  }
}
