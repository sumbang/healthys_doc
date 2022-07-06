import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:healthys_medecin/pages/ConsultationPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
//import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class NewConsultationForm extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<NewConsultationForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  final _codeController = TextEditingController();
  final _numeroController = TextEditingController();
  final _pinController = TextEditingController();

  bool visible = true;
  String code = "";
  bool _isSaving = true;
  String currentpin = "";
  String currentpatient = "";
  bool isVisible = true;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _codeController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      currentpin = (prefs.getString('currentpin') ?? '');
    });
  }

  MyItems filiation;
  Future<List<MyItems>> filiations;
  String base64Image;
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension = "png, jpg, jpeg, pdf";
  bool _loadingPath = false;
  bool _multiPick = false;
  Future<File> imageFile;
  PickedFile _imageFile;
  File _image;
  File tmpFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  String _retrieveDataError;
  bool isVideo = false;

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

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
        child: Image.file(File(_imageFile.path)),
      );
    } else if (_pickImageError != null) {
      return Center(
          child: Text(
        'Erreur : $_pickImageError',
      ));
    } else {
      return Center(child: Text(""));
    }
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
          isVisible = false;
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

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = List();

    MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Setting.apiracine + "comptes/data?types=" + nature.toString(),
        headers: {"Language":  mySingleton.getLangue.toString()});

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  @override
  void initState() {
    requestPersmission();
    super.initState();

    _loadUser();
    filiations = getElements("12");
  }

  _makeReset() async {
    String matricule = _numeroController.text.toString();
    String pin = _pinController.text.toString();
    String code1 = _codeController.text.toString();

    if (code1 != code) {
      Fluttertoast.showToast(
          msg: allTranslations.text("z29"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (pin != currentpin) {
      Fluttertoast.showToast(
          msg: allTranslations.text("z30"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
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

      // if (_imageFile == null) {
      Map data = {
        //'parent': currentpatient.toString(),
        'fils': _numeroController.text.toString(),
        // 'filiation': filiation.id.toString(),
        'photo': ''
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token1 = (prefs.getString('token') ?? '');

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

      var res = await http
          .post(Setting.apiracine + "comptes/jointure3", body: data, headers: {
        "Language":  mySingleton.getLangue.toString(),
        "Authorization": basicAuth,
      });

      if (res.statusCode == 200) {
        var responseJson = json.decode(res.body);

        Navigator.of(context, rootNavigator: true).pop('dialog');

        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (_) => new ConsultationPage(responseJson["code"])),
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

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }

  _scan() {

      /* showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('SCAN DE QR CODE'),
            content: Container(child:  MobileScanner(
                                        allowDuplicates: false,
                                        onDetect: (barcode, args) {
                                          final String code = barcode.rawValue;
                                          debugPrint('Barcode found! $code');
                                          _numeroController.text = code;
                                           Navigator.of(context, rootNavigator: true).pop('dialog');
                                        }) , width: 300.0, height: 300.0,),
          );
        }); */

  }

  Future _scan1() async {
  
    //await Permission.camera.request();
   /* String barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      //this._outputController.text = barcode;
      _numeroController.text = barcode;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
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
                          labelText: allTranslations.text('matricule') + " *",
                          labelStyle: TextStyle(
                              color: color,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                           return allTranslations.text('requis_title');
                          }
                        },
                        controller: _numeroController,
                        keyboardType: TextInputType.number,
                        // enabled: visible ? false : true,
                      ),
                    ),
                  ),
                  flex: 5,
                ),
                Flexible(
                    child: IconButton(
                      onPressed: () {
                        // You enter here what you want the button to do once the user interacts with it
                        _scan();
                      },
                      icon: Icon(
                        Icons.qr_code,
                        color: color,
                      ),
                      iconSize: 40.0,
                    ),
                    flex: 1)
              ],
            ),
            visible
                ? Divider(
                    height: 25.0,
                    color: Colors.transparent,
                  )
                : Container(),
            visible
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
                            Icons.security,
                            color: color,
                          ),
                          labelText: allTranslations.text('s2') + " *",
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return allTranslations.text('requis_title');
                          }
                        },
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  )
                : Container(),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            visible
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: new Center(
                      child: new InkWell(
                        onTap: _makeReset,
                        child: new Container(
                          width: 300.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            color: color2,
                            border:
                                new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          child: new Center(
                            child: new Text(
                              allTranslations.text("z17"),
                              style: new TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
