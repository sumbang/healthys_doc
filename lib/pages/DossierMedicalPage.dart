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
import 'package:healthys_medecin/models/Content.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import '../models/DetailConsultation.dart';
import 'ConsultationPage.dart';
import 'MedicalReportPage.dart';

class DossierMedicalPage extends StatelessWidget {
  String numero;

  DossierMedicalPage(this.numero);

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
  String? _retrieveDataError;

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController _securityController = TextEditingController();
  Future<File>? imageFile;
  PickedFile? _imageFile;
  File? _image;
  File? tmpFile;
  final ImagePicker _picker = ImagePicker();
  dynamic? _pickImageError;
  Future<List<Content>>? contenu;
  Future<DetailConsultation>? details;

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Image.file(File(_imageFile!.path));
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

  pickImageFromGallery(ImageSource source, {required BuildContext context}) async {
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
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
   
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

    MySingleton mySingleton = new MySingleton();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1; 

    var response = await http.get(
        Setting.apiracine +
            "comptes/patient?id=" +
            this.id.toString() +
            "&type=1&language=" +
           mySingleton.getLangue.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA2 :" + response.body.toString());

    List<Content> maliste = [];

      final responseJson = json.decode(response.body);

      for (int i = 0; i < responseJson.length; i++) {
        maliste.add(Content.fromJson(responseJson[i]));
      }

      return maliste;
   
  }

  void initState() {
    super.initState();
    //contenu = _getContent();
  }

  List<Widget> _buildExpandableContent(List<Content> items) {
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

  Widget _buildExpandableContent1(List<Content> items) {
    String texte = "";

    for (int i = 0; i < items.length; i++) {
      texte += items[i].libelle.toString() + ", ";
    }

    Padding content = new Padding(
      padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
      child: Text(texte,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14.5,
              color: Colors.black)),
    );

    return content;
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
              color: color,
              height: 12 * SizeConfig.heightMultiplier,
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
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (_) => new MedicalReportPage()),
                            );
                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              allTranslations.text('ds').toUpperCase() +
                                  " " +
                                  id.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.only(top: 12 * SizeConfig.heightMultiplier),
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
                        padding:
                            EdgeInsets.only(left: 10.0, right: 30.0, top: 20.0),
                        child: Center(
                          child: Text(
                            allTranslations.text('d1').toUpperCase(),
                            style: TextStyle(
                                color: color2,
                                fontWeight: FontWeight.bold,
                                fontSize: 2.2 * SizeConfig.textMultiplier),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 30.0),
                        child: Center(
                          child: Text(
                            allTranslations.text('urgence_title').toUpperCase(),
                            style: TextStyle(
                                color: color2,
                                fontWeight: FontWeight.bold,
                                fontSize: 2.2 * SizeConfig.textMultiplier),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 30.0),
                        child: Center(
                          child: Text(
                            allTranslations.text('medecin_title').toUpperCase(),
                            style: TextStyle(
                                color: color2,
                                fontWeight: FontWeight.bold,
                                fontSize: 2.2 * SizeConfig.textMultiplier),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 30.0),
                        child: Center(
                          child: Text(
                            allTranslations.text('d2').toUpperCase(),
                            style: TextStyle(
                                color: color2,
                                fontWeight: FontWeight.bold,
                                fontSize: 2.2 * SizeConfig.textMultiplier),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    /*  Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations.text('d3').toUpperCase(),
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
                                  children: [],
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations.text('d4'),
                                      style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier),
                                    ),
                                  )),
                              SizedBox(height: 10.0),
                              Container(
                                child: Column(
                                  children: [],
                                ),
                              ),
                              SizedBox(height: 30.0), */
                    Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 30.0),
                        child: Center(
                          child: Text(
                            allTranslations.text('d5').toUpperCase(),
                            style: TextStyle(
                                color: color2,
                                fontWeight: FontWeight.bold,
                                fontSize: 2.2 * SizeConfig.textMultiplier),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 30.0),
                        child: Center(
                          child: Text(
                            allTranslations.text('d6').toUpperCase(),
                            style: TextStyle(
                                color: color2,
                                fontWeight: FontWeight.bold,
                                fontSize: 2.2 * SizeConfig.textMultiplier),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 30.0),
                        child: Center(
                          child: Text(
                            allTranslations.text('d7').toUpperCase(),
                            style: TextStyle(
                                color: color2,
                                fontWeight: FontWeight.bold,
                                fontSize: 2.2 * SizeConfig.textMultiplier),
                          ),
                        )),
                    SizedBox(height: 10.0),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    ),
                    SizedBox(height: 30.0),
                  ],
                )),
              ),
            )
          ],
        )

        /*FutureBuilder<List<Content>>(
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
                  List<Content> parametres = new List();
                  String motif = "";
                  String photo = "";
                  String nom = "";
                  String adresse = "";
                  String datnaiss = "";

                  for (int i = 0; i < snapshot.data.length; i++) {
                    if (snapshot.data[i].groupe == 1) {
                      if (snapshot.data[i].libelle == "Nom")
                        nom = snapshot.data[i].valeur.toString();
                      else if (snapshot.data[i].libelle == "photo")
                        photo = snapshot.data[i].valeur.toString();
                      else if (snapshot.data[i].libelle == "Résidence")
                        adresse = snapshot.data[i].valeur.toString();
                      else if (snapshot.data[i].libelle == "Date de naissance")
                        datnaiss = snapshot.data[i].valeur.toString();
                      // else identification.add(snapshot.data[0][i]);
                    } else if (snapshot.data[i].groupe == 2) {
                      parametres.add(snapshot.data[i]);
                    } else if (snapshot.data[i].groupe == 3) {}
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
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (_) =>
                                                new MedicalReportPage()),
                                      );
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
                                            .toUpperCase(),
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
                                          onTap: () {},
                                          child: new Container(
                                            width: 300.0,
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
                                                allTranslations.text('tele1'),
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
                                  children: [],
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
                                  children: [],
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
                                  children: [],
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
                                  children: [],
                                ),
                              ),
                              SizedBox(height: 30.0),
                       
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations.text('d5').toUpperCase(),
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
                                  children: [],
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations.text('d6').toUpperCase(),
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
                                  children: [],
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Center(
                                    child: Text(
                                      allTranslations.text('d7').toUpperCase(),
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
                                  children: [],
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
            })*/
        );
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    double? width = maxWidthController.text.isNotEmpty
        ? double.parse(maxWidthController.text)
        : null;

    double? height = maxHeightController.text.isNotEmpty
        ? double.parse(maxHeightController.text)
        : null;

    int? quality = qualityController.text.isNotEmpty
        ? int.parse(qualityController.text)
        : null;

    onPick(width!, height!, quality!);
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
