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
import 'package:healthys_medecin/models/Content.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import '../models/DetailConsultation.dart';
import 'ConsultationPage.dart';

class Consultation32 extends StatelessWidget {
  String id;

  Consultation32(this.id);

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
              home: Consultation31(this.id),
            );
          },
        );
      },
    );
  }
}

class Consultation31 extends StatefulWidget {
  String id;

  Consultation31(this.id);

  @override
  ConsultationPageState createState() => new ConsultationPageState(this.id);
}

class ConsultationPageState extends State<Consultation31> {
  String id;
  ConsultationPageState(this.id);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool isVideo = false;
  String _retrieveDataError;

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  Future<File> imageFile;
  PickedFile _imageFile;
  File _image;
  File tmpFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  Future<List<Content>> contenu;
  Future<DetailConsultation> details;

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Image.file(File(_imageFile.path));
    } else if (_pickImageError != null) {
      return Text(
        'Erreur : $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        allTranslations.text('noimage_title'),
        textAlign: TextAlign.center,
      );
    }
  }

  pickImageFromGallery(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context,
        (double maxWidth, double maxHeight, int quality) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );

        print("File picked : " + pickedFile.path.toString());

        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      isVideo = false;
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(allTranslations.text('photo1_title')),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(allTranslations.text('photo2_title')),
                      onTap: () {
                        Navigator.pop(
                            context, allTranslations.text('cancel_title'));
                        pickImageFromGallery(ImageSource.gallery,
                            context: context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text(allTranslations.text('photo3_title')),
                      onTap: () {
                        Navigator.pop(
                            context, allTranslations.text('cancel_title'));
                        pickImageFromGallery(ImageSource.camera,
                            context: context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<List<Content>> _getContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Locale myLocale = Localizations.localeOf(context);

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Setting.apiracine +
            "consultations/" +
            this.id.toString() +
            "?type=1&language=" +
            myLocale.languageCode.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA2 :" + response.body.toString());

    List<Content> maliste = List();

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      for (int i = 0; i < responseJson.length; i++) {
        maliste.add(Content.fromJson(responseJson[i]));
      }

      return maliste;
    }

    return null;
  }

  Future<DetailConsultation> _getDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Locale myLocale = Localizations.localeOf(context);

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Setting.apiracine +
            "consultations/view2?id=" +
            this.id.toString() +
            "?type=1&language=" +
            myLocale.languageCode.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA21 :" + response.body.toString());

    List<Content> maliste = List();

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      return DetailConsultation.fromJson(responseJson);
    }

    return null;
  }

  void initState() {
    super.initState();
    contenu = _getContent();
    details = _getDetail();
  }

  List<Widget> _buildExpandableContent(List<Content> items) {
    List<Widget> listElementWidgetList = new List<Widget>();

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

  List<Widget> _buildList(String datas) {
    List<Widget> listElementWidgetList = new List<Widget>();
    List<String> items = datas.split(";");

    for (int i = 0; i < items.length; i++) {
      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
              child: Text(items[i].toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black)),
            )
          ],
        ),
      ));

      listElementWidgetList.add(Divider(
        height: 5.0,
        color: Colors.grey,
      ));
    }

    return listElementWidgetList;
  }

  List<Widget> _buildExpandableContent1(List<Content> items) {
    String texte = "";

    List<Widget> listElementWidgetList = new List<Widget>();

    for (int i = 0; i < items.length; i++) {
      texte += items[i].libelle.toString() + ", ";

      listElementWidgetList.add(new Padding(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
              child: Text(items[i].libelle.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black)),
            )
          ],
        ),
      ));

      listElementWidgetList.add(Divider(
        height: 5.0,
        color: Colors.grey,
      ));
    }

    /*Padding content = new Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
      child: Text(texte,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.5,
              color: Colors.black)),
    );

    return content; */

    return listElementWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return Scaffold(
        backgroundColor: Color(0xffF8F8FA),
        body: FutureBuilder(
            future: Future.wait([contenu, details]),
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
                  List<Content> identification = new List();
                  List<Content> parametres = new List();
                  List<Content> antecedents = new List();
                  List<Content> antecedents1 = new List();
                  String motif = "";
                  String photo = "";
                  String nom = "";
                  String adresse = "";
                  String datnaiss = "";

                  for (int i = 0; i < snapshot.data[0].length; i++) {
                    if (snapshot.data[0][i].groupe == 1) {
                      if (snapshot.data[0][i].libelle == "Nom")
                        nom = snapshot.data[0][i].valeur.toString();
                      else if (snapshot.data[0][i].libelle == "photo")
                        photo = snapshot.data[0][i].valeur.toString();
                      else if (snapshot.data[0][i].libelle == "Résidence")
                        adresse = snapshot.data[0][i].valeur.toString();
                      else if (snapshot.data[0][i].libelle ==
                          "Date de naissance")
                        datnaiss = snapshot.data[0][i].valeur.toString();
                      else
                        identification.add(snapshot.data[0][i]);
                    } else if (snapshot.data[0][i].groupe == 2) {
                      if (snapshot.data[0][i].libelle == "motif")
                        motif = snapshot.data[0][i].valeur.toString();
                      else
                        parametres.add(snapshot.data[0][i]);
                    } else if (snapshot.data[0][i].groupe == 3) {
                      if (snapshot.data[0][i].famille == 1)
                        antecedents.add(snapshot.data[0][i]);
                      else
                        antecedents1.add(snapshot.data[0][i]);
                    }
                  }

                  var truedate = "";

                  if (datnaiss != null) {
                    /*var d = datnaiss.toString().split("-");
                    truedate = d[2].toString() +
                        "-" +
                        d[1].toString() +
                        "-" +
                        d[0].toString();*/
                        truedate = datnaiss.toString();
                  }

                  return new Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        color: color2,
                        height: 25 * SizeConfig.heightMultiplier,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              top: 8 * SizeConfig.heightMultiplier),
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
                                      /*Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (_) =>
                                                new ConsultationPage()),
                                      );*/
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
                                                Setting.serveurimage +
                                                    '' +
                                                    photo))),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        nom,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        adresse,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Née le " + truedate,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                                        left: 15.0,
                                        top: 3 * SizeConfig.heightMultiplier),
                                    child: Center(
                                      child: Text(
                                        allTranslations
                                            .text('consultation1_title'),
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 2.2 *
                                                SizeConfig.textMultiplier),
                                      ),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Column(
                                    children:
                                        _buildExpandableContent(parametres),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 30.0),
                                    child: Center(
                                      child: Text(
                                        allTranslations
                                            .text('consultation5_title'),
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 2.2 *
                                                SizeConfig.textMultiplier),
                                      ),
                                    )),
                                SizedBox(height: 10.0),
                                Container(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Center(
                                        child: Text(
                                          motif,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      )),
                                ),
                                SizedBox(height: 30.0),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 20),
                                      Text(allTranslations.text('hist_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Center(
                                              child: Text(
                                                snapshot.data[1].histoire
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            )),
                                      ),
                                      SizedBox(height: 30.0),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 30.0),
                                          child: Center(
                                            child: Text(
                                              allTranslations
                                                  .text('antecedent_title'),
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.2 *
                                                      SizeConfig
                                                          .textMultiplier),
                                            ),
                                          )),
                                      SizedBox(height: 10.0),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 30.0),
                                          child: Center(
                                            child: Text(
                                              allTranslations
                                                  .text('toxico_title'),
                                              style: TextStyle(
                                                  color: color2,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 1.8 *
                                                      SizeConfig
                                                          .textMultiplier),
                                            ),
                                          )),
                                      SizedBox(height: 10.0),
                                      Container(
                                        child: Column(
                                            children: _buildExpandableContent1(
                                                antecedents)),
                                      ),
                                      SizedBox(height: 10.0),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 30.0),
                                          child: Center(
                                            child: Text(
                                              allTranslations
                                                  .text('antecedent6_title'),
                                              style: TextStyle(
                                                  color: color2,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 1.8 *
                                                      SizeConfig
                                                          .textMultiplier),
                                            ),
                                          )),
                                      SizedBox(height: 3),
                                      Container(
                                        child: Column(
                                            children: _buildExpandableContent1(
                                                antecedents1)),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                          allTranslations
                                              .text('physique_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Center(
                                              child: Text(
                                                snapshot.data[1].examen
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            )),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                          allTranslations
                                              .text('diagnostic_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      Container(
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Center(
                                              child: Text(
                                                snapshot.data[1].diagnostic
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            )),
                                      ),
                                      SizedBox(height: 20),
                                      Text(allTranslations.text('cmt_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      SizedBox(height: 10),
                                      Container(
                                        child: Column(
                                            children: _buildList(snapshot
                                                .data[1].resultat
                                                .toString())),
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox(height: 20),
                                      /*Text(allTranslations.text('res_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      Text(
                                        snapshot.data[1].resultat.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 20),
                                      !snapshot.data[1].scan1.isEmpty
                                          ? Image.network(
                                              Setting.serveurimage +
                                                  '' +
                                                  snapshot.data[1].scan1,
                                              fit: BoxFit.fill)
                                          : Container(),
                                      SizedBox(height: 20), */
                                      Text(
                                          allTranslations
                                              .text('ordonnance_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      SizedBox(height: 20),
                                      Container(
                                        child: Column(
                                            children: _buildList(snapshot
                                                .data[1].ordonnance
                                                .toString())),
                                      ),
                                      SizedBox(height: 20),
                                      !snapshot.data[1].scan2.isEmpty
                                          ? Image.network(
                                              Setting.serveurimage +
                                                  '' +
                                                  snapshot.data[1].scan2,
                                              fit: BoxFit.fill)
                                          : Container(),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                /*Text(allTranslations.text('conclusion_title'),
                                    style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            2.2 * SizeConfig.textMultiplier)),
                                Text(
                                  snapshot.data[1].conclusion.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 20),*/
                              ],
                            ),
                          ),
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

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    double width = maxWidthController.text.isNotEmpty
        ? double.parse(maxWidthController.text)
        : null;

    double height = maxHeightController.text.isNotEmpty
        ? double.parse(maxHeightController.text)
        : null;

    int quality = qualityController.text.isNotEmpty
        ? int.parse(qualityController.text)
        : null;

    onPick(width, height, quality);
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
