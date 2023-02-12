import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/image_compress_service.dart';
import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Items.dart';
import 'package:healthys_medecin/pages/Consultation4.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mime/mime.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/all_translations.dart';

class NewPatientForm1 extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<NewPatientForm1> {
  MyItems? civilite;
  MyItems? situation;
  MyItems? pays;
  MyItems? sexe;
  MyItems? rhesus;
  MyItems? electro;
  MyItems? sanguin;
  String? currentstatus;
  DateTime? _dateTime;

  final _formKey = GlobalKey<FormState>();

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
  final _poidsController = TextEditingController();
  final _tailleController = TextEditingController();
  final _cniController = TextEditingController();
  final _datedelivController = TextEditingController();
  final _nom1Controller = TextEditingController();
  final _numero1Controller = TextEditingController();
  final _nom2Controller = TextEditingController();
  final _numero2Controller = TextEditingController();
  final _autre1Controller = TextEditingController();
  final _autre2Controller = TextEditingController();
  final _sportController = TextEditingController();
  final _professionController = TextEditingController();
  final _pinController = TextEditingController();
  final _enfantController = TextEditingController();
  final _handicapController = TextEditingController();

  var _listMedecin = <Widget>[];
  var _listPersonne = <Widget>[];
  List<String> _liste_medecin = [];
  List<String> _liste_personne = [];

  bool visible = false;
  String code = "";
  bool _isSaving = true;
  String currentpin = "";
  String currentpatient = "";
  bool isVisible = true;
  bool isVisible1 = true;
  bool handicap = false;
  bool handicap1 = false;
  bool isVisible2 = true;

  String selectedValue = "Handicap moteur";

  List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Handicap moteur"),value: "Handicap moteur"),
    DropdownMenuItem(child: Text("Handicap auditif"),value: "Handicap auditif"),
    DropdownMenuItem(child: Text("Handicap visuel"),value: "Handicap visuel"),
    DropdownMenuItem(child: Text("Handicap"),value: "Handicap"),
    DropdownMenuItem(child: Text("Autres"),value: "Autres"),
  ];
  return menuItems;
}

  final gris = const Color(0xFF373736);
  final bleu = const Color(0xFF194185);
  final bleu1 = const Color(0xFF006CA7);
  final bleu2 = const Color(0xFF222651);
  final bleu3 = const Color(0xFF3b5998);
  final clair = const Color(0xFFF9FAFB);

  bool tabac = false;
  bool sport = false;
  bool enfant = false;
  bool alcool = false;
  bool hta = false;
  bool diabete = false;
  bool dsylipedemie = false;
  bool asmathique = false;
  bool seropositif = false;
  bool alzheimer = false;
  bool mental = false;
  bool audiovisuel = false;
  bool epilepsies = false;
  bool autre = false;
  bool autre2 = false;
  bool _isChecked = true;
  List<String> sitmat = [];

  String payslocalisation = "";
  String codepays = "";

  void _handleRadioValueCiv(MyItems? value) {
    setState(() {
      civilite = value;
    });
  }

  void _handleRadioValueElect(MyItems? value) {
    setState(() {
      electro = value;
    });
  }

  void _handleRadioValueSang(MyItems? value) {
    setState(() {
      sanguin = value;
    });
  }

  void _handleRadioValueSit(MyItems? value) {
    setState(() {
      situation = value;
    });
  }

  Widget _addPersonne({required Function refresh}) {
    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Container(
                //height: 420.0,
                width: 300.0, // Change as per your requirement
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
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
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: new Icon(
                              Icons.person,
                              color: color,
                            ),
                            labelText: allTranslations.text('fullname') + " *",
                            labelStyle: TextStyle(
                                color: color,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Champ obligatoire';
                            }
                          },
                          keyboardType: TextInputType.text,
                          controller: _nom1Controller,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: allTranslations.text('phone_title') + " *",
                        prefixIcon: new Icon(
                          Icons.phone,
                          color: color,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(),
                        ),
                        labelStyle: TextStyle(
                            color: color,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      initialCountryCode: 'CM',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                        if (mounted) {
                          _numero1Controller.text =
                              phone.completeNumber.toString();
                          //payslocalisation = phone.countryISOCode.toString();
                        }
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: new Center(
                          child: new InkWell(
                            onTap: () {
                              if (_nom1Controller.text.toString().isEmpty ||
                                  _numero1Controller.text.toString().isEmpty) {
                                Fluttertoast.showToast(
                                    msg: allTranslations.text('requis_title'),
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: color,
                                    textColor: Colors.white);
                              } else {
                                String json = '{"id":0,"nom":"' +
                                    _nom1Controller.text.toString() +
                                    '","phone":"' +
                                    _numero1Controller.text.toString() +
                                    '"}';

                                refresh(() {
                                  setState(() {
                                    _liste_personne.add(json);

                                    int pos = _liste_personne.length - 1;

                                    _listPersonne.add(Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              new Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      new Text(
                                                          allTranslations.text(
                                                                  'nom_title') +
                                                              " : ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          )),
                                                      new Text(
                                                          _nom1Controller.text
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      new Text(
                                                          allTranslations.text(
                                                                  'phone_title') +
                                                              " : ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          )),
                                                      new Text(
                                                          _numero1Controller
                                                              .text
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                ],
                                              )),
                                              Column(
                                                children: [
                                                  new IconButton(
                                                      icon: new Icon(
                                                        Icons.delete,
                                                        color: color,
                                                      ),
                                                      onPressed: () {
                                                        _removePersonne(pos);
                                                      }),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(height: 5, color: Colors.grey)
                                      ],
                                    ));
                                  });
                                });

                                _nom1Controller.text = "";
                                _numero1Controller.text = "";

                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              }
                            },
                            child: new Container(
                              width: 200.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: color,
                                border: new Border.all(
                                    color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              child: new Center(
                                child: new Text(
                                  allTranslations.text("z28"),
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ))));
  }

  void _removePersonne(int pos) {
    print("suppression : " + pos.toString());

    setState(() {
      _listPersonne = List.from(_listPersonne)..removeAt(pos);

      _liste_personne = List.from(_liste_personne)..removeAt(pos);
    });
  }

  Widget _addMedecin({required Function refresh}) {
    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Container(
                //height: 420.0,
                width: 300.0, // Change as per your requirement
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
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
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: new Icon(
                              Icons.person,
                              color: color,
                            ),
                            labelText: allTranslations.text('fullname') + " *",
                            labelStyle: TextStyle(
                                color: color,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Champ obligatoire';
                            }
                          },
                          keyboardType: TextInputType.text,
                          controller: _nom2Controller,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: allTranslations.text('phone_title') + " *",
                        prefixIcon: new Icon(
                          Icons.phone,
                          color: color,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(),
                        ),
                        labelStyle: TextStyle(
                            color: color,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      initialCountryCode: 'CM',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                        if (mounted) {
                          _numero2Controller.text =
                              phone.completeNumber.toString();
                          //payslocalisation = phone.countryISOCode.toString();
                        }
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: new Center(
                          child: new InkWell(
                            onTap: () {
                              if (_nom2Controller.text.toString().isEmpty ||
                                  _numero2Controller.text.toString().isEmpty) {
                                Fluttertoast.showToast(
                                    msg: allTranslations.text('requis_title'),
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: color,
                                    textColor: Colors.white);
                              } else {
                                String json = '{"id":0,"nom":"' +
                                    _nom2Controller.text.toString() +
                                    '","phone":"' +
                                    _numero2Controller.text.toString() +
                                    '"}';

                                refresh(() {
                                  setState(() {
                                    _liste_medecin.add(json);

                                    int pos = _liste_medecin.length - 1;

                                    _listMedecin.add(Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              new Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      new Text(
                                                          allTranslations.text(
                                                                  'nom_title') +
                                                              " : ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          )),
                                                      new Text(
                                                          _nom2Controller.text
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      new Text(
                                                          allTranslations.text(
                                                                  'phone_title') +
                                                              " : ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          )),
                                                      new Text(
                                                          _numero2Controller
                                                              .text
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                ],
                                              )),
                                              Column(
                                                children: [
                                                  new IconButton(
                                                      icon: new Icon(
                                                        Icons.delete,
                                                        color: color,
                                                      ),
                                                      onPressed: () {
                                                        _removeMedecin(pos);
                                                      }),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(height: 5, color: Colors.grey)
                                      ],
                                    ));
                                  });
                                });

                                _nom2Controller.text = "";
                                _numero2Controller.text = "";

                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              }
                            },
                            child: new Container(
                              width: 200.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: color,
                                border: new Border.all(
                                    color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              child: new Center(
                                child: new Text(
                                  allTranslations.text("z28"),
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ))));
  }

  void _removeMedecin(int pos) {
    print("suppression : " + pos.toString());

    setState(() {
      _listMedecin = List.from(_listMedecin)..removeAt(pos);

      _liste_medecin = List.from(_liste_medecin)..removeAt(pos);
    });
  }

  String? base64Image;
  String? _fileName;

  String? base64Image1;
  String? _fileName1;

  String? base64Image2;
  String? _fileName2;

  String? _path;
  Map<String, String>? _paths;
  String _extension = "png, jpg, jpeg, pdf";
  bool _loadingPath = false;
  bool _multiPick = false;
  Future<List<MyItems>>? civi;
  Future<List<MyItems>>? elect;
  Future<List<MyItems>>? sang;
  Future<List<MyItems>>? sit;
  Future<List<MyItems>>? toxico;
  MyItems? filiation;
  Future<List<MyItems>>? filiations;
  Future<List<MyItems>>? medical;

  bool is_cni = false;
  bool is_ordre = false;

  /** image pour uploads */

  List<Asset> l_images = <Asset>[];
  List<Asset> l_images1 = <Asset>[];

  List<Widget> buildGridView() {
    return List.generate(l_images.length, (index) {
      Asset asset = l_images[index];
      return Padding(
          padding: EdgeInsets.all(5),
          child: AssetThumb(
            asset: asset,
            width: 100,
            height: 100,
          ));
    });
  }

  List<Widget> buildGridView1() {
    return List.generate(l_images1.length, (index) {
      Asset asset = l_images1[index];
      return Padding(
          padding: EdgeInsets.all(5),
          child: AssetThumb(
            asset: asset,
            width: 200,
            height: 200,
          ));
    });
  }

  Future<List<File>> convertListAssetToListFile() async {
    List<File> files = <File>[];
    // images from galllery
    for (int i = 0; i < l_images.length; i++) {
      String imagePath = await FlutterAbsolutePath.getAbsolutePath(
        l_images[i].identifier,
      );
      File file = File(imagePath);
      files.add(file);
    }
    return files;
  }

  Future<List<File>> convertListAssetToListFile1() async {
    List<File> files = <File>[];
    // images from galllery
    for (int i = 0; i < l_images1.length; i++) {
      String imagePath = await FlutterAbsolutePath.getAbsolutePath(
        l_images[i].identifier,
      );
      File file = File(imagePath);
      files.add(file);
    }
    return files;
  }

  Future<void> loadAssets1() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 2,
        enableCamera: true,
        selectedAssets: l_images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      // await _uploadImage();

    } on Exception catch (e) {}
    if (!mounted) return;

    setState(() {
      l_images = resultList;
      if (resultList.length != 0) is_cni = true;
    });
  }

  Future<void> loadAssets2() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: l_images1,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      // await _uploadImage();

    } on Exception catch (e) {}
    if (!mounted) return;

    setState(() {
      l_images1 = resultList;
      if (resultList.length != 0) is_ordre = true;
    });
  }

  _uploadOrdre() async {}

  _uploadCni() async {
    List<File> file = await convertListAssetToListFile();

    Uri uri = Uri.parse(Setting.apiracine + "comptes/uploaders");

    MultipartRequest request = http.MultipartRequest("POST", uri);

    for (int i = 0; i < file.length; i++) {
      ImageCompressService imageCompressService = ImageCompressService(
        file: file[i],
      );

      File afterCompress = await imageCompressService.exec();

      Uint8List bytes = afterCompress.readAsBytesSync();

      ByteData data = ByteData.view(bytes.buffer);

      List<int> imageData = data.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'photo' + i.toString() + "",
        imageData,
        filename: 'some-file-name.jpg',
        //contentType: MediaType("image", "jpg"),
      );

      // add file to multipart
      request.files.add(multipartFile);
    }

    request.fields["qte"] = file.length.toString();

    var response = await request.send();

    var res = await http.Response.fromStream(response);

    return res.body.toString();
  }

  /** fin uploads */

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = [];

    MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Uri.parse(Setting.apiracine + "comptes/data?types=" + nature.toString()),
        headers: {"Language":  mySingleton.getLangue.toString()});

    print("DATA " + nature + " : " + response.body.toString());

      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
   
  }

  List<MyItems> selectedToxico = [];
  List<MyItems> selectedMedical = [];

  Widget _buildToxico(List<MyItems> list) {
    List<Widget> mList = [];

    for (int b = 0; b < list.length; b++) {
      MyItems cmap = list[b];

      mList.add(CheckboxListTile(
        onChanged: (bool? value) {
          if (mounted) {
            setState(() {
              if (value!) {
                selectedToxico.add(cmap);
                if (cmap.id == 23) autre2 = true;
              } else {
                selectedToxico.remove(cmap);
                if (cmap.id == 23) autre2 = false;
              }
            });
          }
        },
        value: selectedToxico.contains(cmap),
        title: new Text(
          cmap.libelle.toString().toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: mList,
    );
  }

  Widget _buildMedical(List<MyItems> list) {
    List<Widget> mList = [];

    for (int b = 0; b < list.length; b++) {
      MyItems cmap = list[b];

      mList.add(CheckboxListTile(
        onChanged: (bool? value) {
          if (mounted) {
            setState(() {
              if (value!) {
                selectedMedical.add(cmap);
                if (cmap.id == 28) autre = true;
              } else {
                selectedMedical.remove(cmap);
                if (cmap.id == 28) autre = false;
              }
            });
          }
        },
        value: selectedMedical.contains(cmap),
        title: new Text(
          cmap.libelle.toString().toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ));
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: mList,
    );
  }

  void _submitForms() async {
    MySingleton mySingleton = new MySingleton();

    if (_nomController.text.isEmpty ||
        civilite == null ||
        _prenomController.text.isEmpty ||
        _datnaissController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        situation == null ||
        _phone1Controller.text.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (_liste_personne.length == 0) {
      Fluttertoast.showToast(
          msg: "Veuillez renseigner une personne a prevenir",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (enfant == true && _enfantController.text.toString().isEmpty) {
      Fluttertoast.showToast(
          msg: "Veuillez renseigner votre nombre d'enfant",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else {
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

      // chargement des cni
      String _cnifile = "";
      String _profil = "";

      Uri uri = Uri.parse(Setting.apiracine + "comptes/uploaders");

      if (l_images != null) {
        List<File> file = await convertListAssetToListFile();

        MultipartRequest request1 = http.MultipartRequest("POST", uri);

        for (int i = 0; i < file.length; i++) {
          ImageCompressService imageCompressService = ImageCompressService(
            file: file[i],
          );

          File afterCompress = await imageCompressService.exec();

          Uint8List bytes = afterCompress.readAsBytesSync();

          ByteData data = ByteData.view(bytes.buffer);

          List<int> imageData = data.buffer.asUint8List();

          MultipartFile multipartFile = MultipartFile.fromBytes(
            'photo' + i.toString() + "",
            imageData,
            filename: 'some-file-name.jpg',
            //contentType: MediaType("image", "jpg"),
          );

          // add file to multipart
          request1.files.add(multipartFile);
        }

        request1.fields["qte"] = file.length.toString();
        request1.fields["types"] = "cni";

        var response1 = await request1.send();

        var res1 = await http.Response.fromStream(response1);

        print("photo1 : " + res1.body.toString());

        var responseCni = json.decode(res1.body.toString());

        _cnifile = responseCni[0]["path"] + "|" + responseCni[1]["path"];
      }

      if (l_images1 != null) {
        List<File> file1 = await convertListAssetToListFile1();

        MultipartRequest request2 = http.MultipartRequest("POST", uri);

        for (int i = 0; i < file1.length; i++) {
          ImageCompressService imageCompressService = ImageCompressService(
            file: file1[i],
          );

          File afterCompress = await imageCompressService.exec();

          Uint8List bytes = afterCompress.readAsBytesSync();

          ByteData data = ByteData.view(bytes.buffer);

          List<int> imageData = data.buffer.asUint8List();

          MultipartFile multipartFile = MultipartFile.fromBytes(
            'photo' + i.toString() + "",
            imageData,
            filename: 'some-file-name.jpg',
            //contentType: MediaType("image", "jpg"),
          );

          // add file to multipart
          request2.files.add(multipartFile);
        }

        request2.fields["qte"] = file1.length.toString();
        request2.fields["types"] = "ordre";

        var response2 = await request2.send();

        var res2 = await http.Response.fromStream(response2);

        print("photo2 : " + res2.body.toString());

        var responseOrdre = json.decode(res2.body.toString());

        _profil = responseOrdre[0]['path'];
      }

      String _sport = sport ? _sportController.text.toString() : "0";

      String _b1 = '[';
      String _b2 = '[';

      for (int i = 0; i < _liste_personne.length; i++) {
        if (i == 0)
          _b1 += _liste_personne[i];
        else
          _b1 += "," + _liste_personne[i];
      }

      for (int i = 0; i < _liste_medecin.length; i++) {
        if (i == 0)
          _b2 += _liste_medecin[i];
        else
          _b2 += "," + _liste_medecin[i];
      }

      _b1 += ']';
      _b2 += ']';

      if(handicap) {
        if(selectedValue != "Autres") {
          _handicapController.text = selectedValue;
        } 
      }

      String _handicap = handicap ? _handicapController.text.toString() : "0";

      if(_handicap.isEmpty) _handicap = "0";

      Map data = {
        'civilite': civilite!.id.toString(),
        'nom': _nomController.text.toString(),
        'prenom': _prenomController.text.toString(),
        'datnaiss': _datnaissController.text.toString(),
        'pays': payslocalisation,
        'ville': _villeController.text.toString(),
        'adresse': _adresseController.text.toString(),
        'phone1': _phone1Controller.text.toString(),
        'phone2': _phone2Controller.text.toString(),
        'codepays': codepays,
        'email': _emailController.text.toString(),
        'role': '1',
        'cni': _cnifile,
        'datedeliv': '',
        'personne': _b1,
        'handicap': _handicap,
        'medecin': _b2,
        'sport': _sport,
        'enfant': _enfantController.text.toString(),
        'profession': _professionController.text.toString(),
        'sitmat': situation!.id.toString(),
        'photo': _profil
      };

      print("data : " + data.toString());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token1 = (prefs.getString('token') ?? '');

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();


      var res = await http
          .post(Uri.parse(Setting.apiracine + "comptes/jointure4"), body: data, headers: {
        "Language":  mySingleton.getLangue.toString(),
        "Authorization": basicAuth,
      });

      print("retour : " + res.body.toString());

      if (res.statusCode == 200) {
        var responseJson = json.decode(res.body);

        Navigator.of(context, rootNavigator: true).pop('dialog');

        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (_) => new Consultation4(responseJson["code"])),
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        var responseJson = json.decode(res.body);

        print("retour:" + res.body.toString());

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

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      currentpin = (prefs.getString('currentpin') ?? '');
      currentpatient = (prefs.getString('currentpatient') ?? '');
    });
  }

  void initState() {
    super.initState();

    civi = getElements("2");
    elect = getElements("6");
    sang = getElements("4");
    sit = getElements("8");
    toxico = getElements("9");
    medical = getElements("11");
    _loadUser();
    filiations = getElements("12");
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
    _poidsController.dispose();
    _tailleController.dispose();
    _cniController.dispose();
    _datedelivController.dispose();
    _nom1Controller.dispose();
    _numero1Controller.dispose();
    _nom2Controller.dispose();
    _numero2Controller.dispose();
    _autre1Controller.dispose();
    _autre2Controller.dispose();
    _sportController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  bool isVideo = false;
  String? _retrieveDataError;

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  Future<File>? imageFile;
  PickedFile? _imageFile;
  File? _image;
  File? tmpFile;

  Future<File>? imageFile1;
  PickedFile? _imageFile1;
  File? _image1;
  File? tmpFile1;

  Future<File>? imageFile2;
  PickedFile? _imageFile2;
  File? _image2;
  File? tmpFile2;

  final ImagePicker _picker = ImagePicker();
  final ImagePicker _picker1 = ImagePicker();
  final ImagePicker _picker2 = ImagePicker();
  dynamic _pickImageError;

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return GestureDetector(
        onTap: () {
          _showSelectionDialog(context);
        },
        child: Image.file(File(_imageFile!.path)),
      );
    } else if (_pickImageError != null) {
      return Center(child: Text(""));
    } else {
      return Center(child: Text(""));
    }
  }

  Widget _previewImage1() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile1 != null) {
      return GestureDetector(
        onTap: () {
          _showSelectionDialog1(context);
        },
        child: Image.file(File(_imageFile1!.path)),
      );
    } else if (_pickImageError != null) {
      return Center(child: Text(""));
      ;
    } else {
      return Center(child: Text(""));
    }
  }

  Widget _previewImage2() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile2 != null) {
      return GestureDetector(
        onTap: () {
          _showSelectionDialog2(context);
        },
        child: Image.file(File(_imageFile2!.path)),
      );
    } else if (_pickImageError != null) {
      return Center(child: Text(""));
    } else {
      return Center(child: Text(""));
    }
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

        print("File picked : " + pickedFile!.path.toString());

        setState(() {
          _imageFile = pickedFile;
          isVisible = false;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  pickImageFromGallery1(ImageSource source, {required BuildContext context}) async {
    await _displayPickImageDialog(context,
        (double maxWidth, double maxHeight, int quality) async {
      try {
        final pickedFile = await _picker1.getImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );

        print("File picked : " + pickedFile!.path.toString());

        setState(() {
          _imageFile1 = pickedFile;
          isVisible1 = false;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  pickImageFromGallery2(ImageSource source, {required BuildContext context}) async {
    await _displayPickImageDialog(context,
        (double maxWidth, double maxHeight, int quality) async {
      try {
        final pickedFile = await _picker2.getImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );

        print("File picked : " + pickedFile!.path.toString());

        setState(() {
          _imageFile2 = pickedFile;
          isVisible2 = false;
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
      _retrieveDataError = response.exception!.code;
    }
  }

  Future<void> retrieveLostData1() async {
    final LostData response = await _picker1.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      isVideo = false;
      setState(() {
        _imageFile1 = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Future<void> retrieveLostData2() async {
    final LostData response = await _picker2.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      isVideo = false;
      setState(() {
        _imageFile2 = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
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

  Future<void> _showSelectionDialog1(BuildContext context) {
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
                        pickImageFromGallery1(ImageSource.gallery,
                            context: context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text(allTranslations.text('photo3_title')),
                      onTap: () {
                        Navigator.pop(
                            context, allTranslations.text('cancel_title'));
                        pickImageFromGallery1(ImageSource.camera,
                            context: context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<void> _showSelectionDialog2(BuildContext context) {
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
                        pickImageFromGallery2(ImageSource.gallery,
                            context: context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text(allTranslations.text('photo3_title')),
                      onTap: () {
                        Navigator.pop(
                            context, allTranslations.text('cancel_title'));
                        pickImageFromGallery2(ImageSource.camera,
                            context: context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  List<String> _fichier = [];
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 2,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Widget buildView() {
    var taille = images == null ? 0 : images.length;

    print("images : " + images.toString());

    return Center(child: Text(taille.toString() + " image(s) chosen"));
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: new Text(
                allTranslations.text('identif_title'),
                textAlign: TextAlign.left,
                style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: color),
              ),
            ),
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 8.0, top: 8.0, bottom: 0.0),
                      child: Center(
                        child: Text(
                          allTranslations.text('civ_title') + " *",
                          style: TextStyle(
                              color: color2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
                    child: FutureBuilder<List<MyItems>>(
                        future: civi,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return new Container();
                          } else if (snapshot.hasData) {
                            List<Widget> civ = [];

                            for (int i = 0; i < snapshot.data!.length; i++) {
                              Widget radio = new Radio(
                                value: snapshot.data![i],
                                groupValue: civilite,
                                onChanged: _handleRadioValueCiv,
                              );

                              Widget pad = new Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    snapshot.data![i].libelle.toString(),
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ));

                              civ.add(radio);
                              civ.add(pad);
                            }

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: civ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
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
                          labelText: allTranslations.text('nom_title') + " *",
                          labelStyle: TextStyle(
                              color: color,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Champ obligatoire';
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _nomController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
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
                          labelText: allTranslations.text('prenom_title'),
                          labelStyle: TextStyle(
                              color: color,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Champ obligatoire';
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _prenomController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                          child: new InkWell(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: _dateTime == null
                                          ? DateTime.now()
                                          : _dateTime!,
                                      firstDate: DateTime(1920),
                                      lastDate: DateTime.now())
                                  .then((date) {
                                setState(() {
                                  if(date != null) {

                                  _dateTime = date;
                                  String vj = "";
                                  String vm = "";
                                  var date1 =
                                      DateTime.parse(_dateTime.toString());
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
                                  var formattedDate =
                                      "${date1.year}-${vm}-${vj}";
                                  _datnaissController.text = formattedDate;
                                  }
                                });
                              });
                            },
                            child: new Container(
                              width: 120.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: color2,
                                border: new Border.all(
                                    color: Colors.white, width: 2.0),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(
                                child: new Text(
                                  allTranslations.text('choisir'),
                                  style: new TextStyle(
                                      fontSize: 14.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                            left: 10.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                            width: double.infinity,
                            decoration: new BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: new Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              obscureText: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: new Icon(
                                  Icons.calendar_today,
                                  color: color,
                                ),
                                labelText:
                                    allTranslations.text('datnaiss_title') +
                                        " *",
                                labelStyle: TextStyle(
                                    color: color,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Champ obligatoire';
                                }
                              },
                              keyboardType: TextInputType.text,
                              enabled: false,
                              controller: _datnaissController,
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: allTranslations.text('phone1_title') + " *",
                      prefixIcon: new Icon(
                        Icons.phone,
                        color: color,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(),
                      ),
                      labelStyle: TextStyle(
                          color: color,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                    ),
                    initialCountryCode: 'CM',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                      if (mounted) {
                        _phone1Controller.text =
                            phone.completeNumber.toString();
                        payslocalisation = phone.countryISOCode.toString();
                        codepays = phone.countryCode.toString();
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: allTranslations.text('phone2_title'),
                      prefixIcon: new Icon(
                        Icons.phone,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(),
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                    ),
                    initialCountryCode: 'CM',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                      if (mounted) {
                        _phone2Controller.text =
                            phone.completeNumber.toString();
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
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
                            Icons.email,
                            color: color,
                          ),
                          labelText: allTranslations.text('email_title'),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Champ obligatoire';
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
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
                            Icons.place,
                            color: color,
                          ),
                          labelText: allTranslations.text('adresse_title'),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Champ obligatoire';
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _adresseController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
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
                            Icons.map,
                            color: color,
                          ),
                          labelText: allTranslations.text('ville_title'),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Champ obligatoire';
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _villeController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(
                    height: 0.0,
                    color: Colors.transparent,
                  ),
                ]),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            Center(
                child: new Text(
              allTranslations.text('urgence_title'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: color),
            )),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, refresh) {
                        return AlertDialog(
                            content: _addPersonne(refresh: refresh));
                      },
                    );
                  },
                );
              },
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Image.asset("img/download.png",
                          width: 20.0,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 2),
                        child: Center(
                          child: Text(
                           allTranslations.text("z28"),
                            style: TextStyle(
                                color: color2,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ))
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(child: Column(children: this._listPersonne)),
            SizedBox(
              height: 30,
            ),
            Center(
                child: new Text(
              allTranslations.text('medecin_title'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: color),
            )),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, refresh) {
                        return AlertDialog(
                            content: _addMedecin(refresh: refresh));
                      },
                    );
                  },
                );
              },
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Image.asset("img/download.png",
                          width: 20.0,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 2),
                        child: Center(
                          child: Text(
                            allTranslations.text("z28"),
                            style: TextStyle(
                                color: color2,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ))
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(child: Column(children: this._listMedecin)),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 8.0, top: 5.0, bottom: 18.0),
                child: Center(
                  child: Text(
                    allTranslations.text('sit_title') + " *",
                    style: TextStyle(
                        color: color2,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                )),
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
                        Widget radio = new Radio(
                          value: snapshot.data![i],
                          groupValue: situation,
                          onChanged: _handleRadioValueSit,
                        );

                        Widget pad = new Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                              snapshot.data![i].libelle.toString(),
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ));

                        civ.add(radio);
                        civ.add(pad);
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: civ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
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
                      Icons.assignment,
                      color: color,
                    ),
                    labelText: allTranslations.text('profession_title'),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Champ obligatoire';
                    }
                  },
                  keyboardType: TextInputType.text,
                  controller: _professionController,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            CheckboxListTile(
              title: Center(
                  child: Text(
                'Avez-vous des enfants ?',
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              )),
              value: enfant,
              onChanged: (newValue) {
                if (newValue!)
                  setState(() {
                    enfant = true;
                  });
                else
                  setState(() {
                    enfant = false;
                    _enfantController.text = "";
                  });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            enfant
                ? Padding(
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
                            Icons.assignment,
                            color: color,
                          ),
                          labelText: allTranslations.text('enfant'),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Champ obligatoire';
                          }
                        },
                        keyboardType: TextInputType.number,
                        controller: _enfantController,
                      ),
                    ),
                  )
                : Container(),
            CheckboxListTile(
              title: Center(
                  child: Text(
                allTranslations.text('sport_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              )),
              value: sport,
              onChanged: (newValue) {
                if (newValue!)
                  setState(() {
                    sport = true;
                  });
                else
                  setState(() {
                    sport = false;
                    _sportController.text = "";
                  });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            sport
                ? Padding(
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
                            Icons.assessment,
                            color: color,
                          ),
                          labelText:
                              allTranslations.text('precision_title') + " *",
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Champ obligatoire';
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _sportController,
                      ),
                    ),
                  )
                : Container(),

                  CheckboxListTile(
              title: Center(
                  child: Text(
                allTranslations.text('z94'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              )),
              value: handicap,
              onChanged: (newValue) {
                if (newValue!)
                  setState(() {
                    handicap = true;
                  });
                else
                  setState(() {
                    handicap =  false;
                  });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),

            handicap
                ? Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 5.0, top: 3.0, bottom: 8.0),
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: new Border.all(color: Colors.black38),
                      ),
                      child: DropdownButton(
                        value: selectedValue,
                        items: dropdownItems, 
                        onChanged: (String? value) { 
                          setState(() {
                             selectedValue = value!;
                          });   
                         },
                        ) 
                      ),)  : Container(),

            handicap? SizedBox(height: 8.0,) : Container(),

            handicap
                ? Padding(
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
                            Icons.assessment,
                            color: color,
                          ),
                          labelText:
                              allTranslations.text('toxico4_title'),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        keyboardType: TextInputType.text,
                        controller: _handicapController,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 8.0, bottom: 10.0),
              child: Center(
                  child: Text(
                "Uploader la photo du patient",
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              )),
            ),
            (!is_ordre)
                ? GestureDetector(
                    onTap: loadAssets2,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 5, top: 0),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          color: Colors.grey,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: double.infinity,
                              height: 160,
                              color: clair,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("img/path.png",
                                        width: 50.0,
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      allTranslations.text("z22"),
                                      style: TextStyle(
                                          color: bleu,
                                          height: 1.5,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.0),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      allTranslations.text("z23"),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          height: 1.5,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  )
                : Container(),
            (is_ordre)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildGridView1(),
                  )
                : Container(),
            (is_ordre)
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          is_ordre = false;
                          l_images1.clear();
                        });
                      },
                      child: Text(
                        allTranslations.text("z24"),
                        style: TextStyle(
                            color: Colors.red,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      ),
                    ),
                  )
                : Container(),
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 8.0, bottom: 10.0),
              child: Center(
                  child: Text(
                allTranslations.text("z25")+" *",
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              )),
            ),
            (!is_cni)
                ? GestureDetector(
                    onTap: loadAssets1,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 5, top: 0),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          color: Colors.grey,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: double.infinity,
                              height: 160,
                              color: clair,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("img/path.png",
                                        width: 50.0,
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                     allTranslations.text("z26"),
                                      style: TextStyle(
                                          color: bleu,
                                          height: 1.5,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.0),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      allTranslations.text("z27"),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          height: 1.5,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                  )
                : Container(),
            (is_cni)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildGridView(),
                  )
                : Container(),
            (is_cni)
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          is_cni = false;
                          l_images.clear();
                        });
                      },
                      child: Text(
                        allTranslations.text("z24"),
                        style: TextStyle(
                            color: Colors.red,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20.0,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new Center(
                  child: new InkWell(
                    onTap: _submitForms,
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
                          allTranslations.text("z27"),
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

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
