import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/Items.dart';
import 'package:healthys_medecin/pages/Consultation4.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class NewPatientForm extends StatefulWidget {
  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<NewPatientForm> {
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
      currentpatient = (prefs.getString('currentpatient') ?? '');
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

    var response = await http.get(
        Setting.apiracine + "comptes/data?types=" + nature.toString(),
        headers: {"Language": allTranslations.currentLanguage.toString()});

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
          msg: "Code de confirmation incorrect",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (pin != currentpin) {
      Fluttertoast.showToast(
          msg: "Pin d'authentification incorrect",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } /*else if (filiation == null) {
      Fluttertoast.showToast(
          msg: "Veuillez renseigner votre filiation",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } */
    else {
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

      String basicAuth = 'Bearer ' + token1;

      var res = await http
          .post(Setting.apiracine + "comptes/jointure3", body: data, headers: {
        "Language": allTranslations.currentLanguage.toString(),
        "Authorization": basicAuth,
      });

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

        Fluttertoast.showToast(
            msg: responseJson["message"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
      }

      /* } 
      
      else {
        tmpFile = File(_imageFile.path);

        base64Image = base64Encode(tmpFile.readAsBytesSync());

        String fileName = tmpFile.path.split('/').last;

        String ext = lookupMimeType(tmpFile.path).split('/').last;

        Map data = {
          "image": base64Image,
          "name": ext,
        };

        var res1 =
            await http.post(Setting.apiracine + "comptes/uploader", body: data);

        print("retour : " + res1.body.toString());

        if (res1.statusCode == 200) {
          var response1Json = json.decode(res1.body);

          Map data = {
            'parent': currentpatient.toString(),
            'fils': _numeroController.text.toString(),
            'filiation': filiation.id.toString(),
            'photo': response1Json['path']
          };

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token1 = (prefs.getString('token') ?? '');

          String basicAuth = 'Bearer ' + token1;

          var res = await http.post(Setting.apiracine + "comptes/jointure",
              body: data,
              headers: {
                "Language": allTranslations.currentLanguage.toString(),
                "Authorization": basicAuth,
              });

          if (res.statusCode == 200) {
            var responseJson = json.decode(res.body);

            Navigator.of(context, rootNavigator: true).pop('dialog');

            Fluttertoast.showToast(
                msg: responseJson["message"].toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 5,
                backgroundColor: Colors.blue,
                textColor: Colors.white);

            Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new HomePage(0)),
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
        } else {
          Navigator.of(context, rootNavigator: true).pop('dialog');

          Fluttertoast.showToast(
              msg: allTranslations.text('erreur_title'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 5,
              backgroundColor: Colors.orange,
              textColor: Colors.white);
        }
      } */
    }
  }

  _init() async {
    String matricule = _numeroController.text.toString();

    if (matricule.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');

      String basicAuth = 'Bearer ' + token1;

      var response = await http.get(
          Setting.apiracine + "comptes/check?matricule=" + matricule.toString(),
          headers: {
            "Language": allTranslations.currentLanguage.toString(),
            "Authorization": basicAuth,
          });

      print("retour : " + response.body.toString());

      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        var responseJson = json.decode(response.body);
        setState(() {
          visible = true;
          code = responseJson["code"].toString();
          Fluttertoast.showToast(
              msg: "Le code est : " + responseJson["code"].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 5,
              backgroundColor: Colors.blue,
              textColor: Colors.white);
        });
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        var responseJson = json.decode(response.body);

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

  Future _scan() async {
   /* String barcode = await scanner.scan();

    _numeroController.text = barcode;*/  }

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
  }

  Future _scan1() async {
    //await Permission.camera.request();
  /*  String barcode = await scanner.scan();
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

    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

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
                            return 'Champ obligatoire';
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
                        _scan1();
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
            /*  Divider(
              height: 25.0,
              color: Colors.transparent,
            ),
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
                            Icons.person,
                            color: color,
                          ),
                          labelText:
                              allTranslations.text('codeconfirm_title') + " *",
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Champ obligatoire';
                          }
                        },
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  )
                : Container(),*/
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
                            return 'Champ obligatoire';
                          }
                        },
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  )
                : Container(),
            visible
                ? Divider(
                    height: 10.0,
                    color: Colors.transparent,
                  )
                : Container(),
            /*  visible
                ? Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 8.0, top: 8.0, bottom: 15.0),
                    child: Center(
                      child: Text(
                        allTranslations.text('filiation') + " *",
                        style: TextStyle(
                            color: color2,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ))
                : Container(),
            visible
                ? Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: FutureBuilder<List<MyItems>>(
                        future: filiations,
                        builder: (context, snapshot) {
                          print(snapshot.toString());

                          if (snapshot.hasError) {
                            return new Container();
                          } else if (snapshot.hasData) {
                            List<DropdownMenuItem<MyItems>> items = List();

                            for (int i = 0; i < snapshot.data.length; i++) {
                              items.add(
                                DropdownMenuItem(
                                    child: Text(snapshot.data[i].libelle),
                                    value: snapshot.data[i]),
                              );
                            }

                            return Container(
                                width: double.infinity,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: new Border.all(color: Colors.black38),
                                ),
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 5.0,
                                    top: 5.0,
                                    bottom: 4.0),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<MyItems>(
                                        isExpanded: true,
                                        value: filiation,
                                        items: items,
                                        onChanged: (value) {
                                          setState(() {
                                            filiation = value;
                                          });
                                        })));
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  )
                : Container(),*/
            visible
                ? Divider(
                    height: 15.0,
                    color: Colors.transparent,
                  )
                : Container(),
            /*   visible
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 8.0, top: 8.0, bottom: 10.0),
                        child: Center(
                            child: Text(
                          allTranslations.text('takephoto_title'),
                          style: TextStyle(
                              color: color2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                          textAlign: TextAlign.left,
                        )),
                      ),
                      defaultTargetPlatform == TargetPlatform.android
                          ? FutureBuilder<void>(
                              future: retrieveLostData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<void> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return Center(child: Text(""));
                                  case ConnectionState.done:
                                    return _previewImage();
                                  default:
                                    if (snapshot.hasError) {
                                      return Center(
                                          child: Text(
                                        'Erreur : ${snapshot.error}}',
                                        textAlign: TextAlign.center,
                                      ));
                                    } else {
                                      return Center(child: Text(""));
                                    }
                                }
                              },
                            )
                          : _previewImage(),
                      isVisible
                          ? Container(
                              width: double.infinity,
                              height: 200.0,
                              child: GestureDetector(
                                onTap: () {
                                  _showSelectionDialog(context);
                                },
                                child: Image.asset('img/uploads.png'),
                              ))
                          : Container(),
                    ],
                  )
                : Container(), */
            !visible
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: new Center(
                      child: new InkWell(
                        onTap: _init,
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
                              allTranslations.text('initconfirm_title'),
                              style: new TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ))
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
                              "Continuer",
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
