import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Items.dart';
import 'package:healthys_medecin/pages/LoginPage.dart';
import 'package:healthys_medecin/pages/UserCondition.dart';
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

class SignupForm extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupForm> {
  MyItems? civilite;
  MyItems? situation;
  MyItems? pays;
  MyItems? sexe;
  MyItems? rhesus;
  MyItems? electro;
  MyItems? sanguin;
  DateTime? _datenaiss;
  String? currentstatus;

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

  bool tabac = false;
  bool sport = false;
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
  bool _isSaving = true;
  List<String> sitmat = [];

  String payslocalisation = "";
  String codepays = "";
  String payslocalisation1 = "";
  String payslocalisation2 = "";
  String codepays1 = "";
  String codepays2 = "";

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

  String? base64Image;
  String? _fileName;
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
  Future<List<MyItems>>? medical;
  DateTime? _dateTime;

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = [];

     MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Uri.parse(Setting.apiracine + "comptes/data?types=" + nature.toString()),
        headers: {"Language": mySingleton.getLangue.toString(),});

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
        _datnaissController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _phone1Controller.text.isEmpty ||
        _cniController.text.isEmpty ||
        _datedelivController.text.isEmpty ||
        _nom1Controller.text.isEmpty ||
        _numero1Controller.text.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (images.length == 0) {
      Fluttertoast.showToast(
          msg: "Veuillez charger votre CNI",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } /*else if (!_isChecked) {
      Fluttertoast.showToast(
          msg: allTranslations.text('condition_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    }*/
    else {
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

      setState(() {
        _isSaving = false;
      });

      // uploads de la CNI

      Uri uri = Uri.parse(Setting.apiracine + "comptes/uploaders");

      MultipartRequest request = http.MultipartRequest("POST", uri);

      for (int i = 0; i < images.length; i++) {
        ByteData data = await images[i].getByteData();

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

      request.fields["qte"] = images.length.toString();

      var response = await request.send();

      String fichiers = "";

      var res = await http.Response.fromStream(response);

      print("retour : " + res.body.toString());

      if (res.statusCode == 200) {
        var responseJson = json.decode(res.body);

        //String _photo = responseJson['path'];

        String _cnifile = "";

        _fichier.clear();

        for (int i = 0; i < responseJson.length; i++) {
          _fichier.add(responseJson[i]['path']);
          if (i == 0)
            _cnifile += responseJson[i]['path'];
          else
            _cnifile += "|" + responseJson[i]['path'];
        }

        if (_imageFile == null) {
          String _sport = sport ? _sportController.text.toString() : "0";
          String _autre = autre ? _autre1Controller.text.toString() : "0";
          String _autre2 = autre2 ? _autre2Controller.text.toString() : "0";

          String toxicovalue = "";

          for (int a = 0; a < selectedToxico.length; a++) {
            if (a == 0)
              toxicovalue += selectedToxico[a].id.toString();
            else
              toxicovalue += "|" + selectedToxico[a].id.toString();
          }

          String medicalvalue = "";

          for (int a = 0; a < selectedMedical.length; a++) {
            if (a == 0)
              medicalvalue += selectedMedical[a].id.toString();
            else
              medicalvalue += "|" + selectedMedical[a].id.toString();
          }

          Map data = {
            'civilite': civilite!.id.toString(),
            'nom': _nomController.text.toString(),
            'prenom': _prenomController.text.toString(),
            'datnaiss': _datnaissController.text.toString(),
            'pays': payslocalisation,
            'pays1': payslocalisation1,
            'pays2': payslocalisation2,
            'codepays1': codepays1,
            'codepays2': codepays2,
            'ville': _villeController.text.toString(),
            'adresse': _adresseController.text.toString(),
            'phone1': _phone1Controller.text.toString(),
            'codepays': codepays,
            'email': _emailController.text.toString(),
            'poids': _poidsController.text.toString(),
            'taille': _tailleController.text.toString(),
            'electro': electro!.id.toString(),
            'sanguin': sanguin!.id.toString(),
            'role': '1',
            'cni': _cniController.text.toString(),
            'datedeliv': _datedelivController.text.toString(),
            'nom1': _nom1Controller.text.toString(),
            'numero1': _numero1Controller.text.toString(),
            'nom2': _nom2Controller.text.toString(),
            'numero2': _numero2Controller.text.toString(),
            'toxico': toxicovalue,
            'sport': _sport,
            'medical': medicalvalue,
            'autre': _autre,
            'profession': _professionController.text.toString(),
            'sitmat': situation!.id.toString(),
            'autre2': _autre2,
            'photo': '',
            'cnifile': _cnifile
          };

          var res = await http.post(Uri.parse(Setting.apiracine + "comptes"),
              body: data,
              headers: {
                "Language": mySingleton.getLangue.toString(),
              });

          if (res.statusCode == 200) {
            var responseJson = json.decode(res.body);

            Navigator.of(context, rootNavigator: true).pop('dialog');

            Fluttertoast.showToast(
                msg: responseJson["message"].toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.blue,
                textColor: Colors.white);

            Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new LoginPage()),
            );
          } else {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            var responseJson = json.decode(res.body);

            Fluttertoast.showToast(
                msg: responseJson["message"].toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.blue,
                textColor: Colors.white);
          }
        } else {
          tmpFile = File(_imageFile!.path);

          base64Image = base64Encode(tmpFile!.readAsBytesSync());

          String fileName = tmpFile!.path.split('/').last;

          String ext = lookupMimeType(tmpFile!.path)!.split('/').last;

          Map data = {
            "image": base64Image,
            "name": ext,
          };

          var res1 = await http.post(Uri.parse(Setting.apiracine + "comptes/uploader"),
              body: data);

          print("retour : " + res1.body.toString());

          if (res1.statusCode == 200) {
            var response1Json = json.decode(res1.body);

            String _sport = sport ? _sportController.text.toString() : "0";
            String _autre = autre ? _autre1Controller.text.toString() : "0";
            String _autre2 = autre2 ? _autre2Controller.text.toString() : "0";

            String toxicovalue = "";

            for (int a = 0; a < selectedToxico.length; a++) {
              if (a == 0)
                toxicovalue += selectedToxico[a].id.toString();
              else
                toxicovalue += "|" + selectedToxico[a].id.toString();
            }

            String medicalvalue = "";

            for (int a = 0; a < selectedMedical.length; a++) {
              if (a == 0)
                medicalvalue += selectedMedical[a].id.toString();
              else
                medicalvalue += "|" + selectedMedical[a].id.toString();
            }

            Map data = {
              'civilite': civilite!.id.toString(),
              'nom': _nomController.text.toString(),
              'prenom': _prenomController.text.toString(),
              'datnaiss': _datnaissController.text.toString(),
              'pays': payslocalisation,
              'ville': _villeController.text.toString(),
              'adresse': _adresseController.text.toString(),
              'phone1': _phone1Controller.text.toString(),
              'codepays': codepays,
              'email': _emailController.text.toString(),
              'poids': _poidsController.text.toString(),
              'taille': _tailleController.text.toString(),
              'electro': electro!.id.toString(),
              'sanguin': sanguin!.id.toString(),
              'role': '1',
              'cni': _cniController.text.toString(),
              'datedeliv': _datedelivController.text.toString(),
              'nom1': _nom1Controller.text.toString(),
              'numero1': _numero1Controller.text.toString(),
              'nom2': _nom2Controller.text.toString(),
              'numero2': _numero2Controller.text.toString(),
              'toxico': toxicovalue,
              'codepays1': codepays1,
              'codepays2': codepays2,
              'sport': _sport,
              'medical': medicalvalue,
              'autre': _autre,
              'profession': _professionController.text.toString(),
              'sitmat': situation!.id.toString(),
              'autre2': _autre2,
              'photo': response1Json['path'],
              'cnifile': _cnifile
            };

            print("send : " + data.toString());

            var res = await http.post(Uri.parse(Setting.apiracine + "comptes"),
                body: data,
                headers: {
                  "Language": mySingleton.getLangue.toString(),
                });

            print("retour1 : " + res.body.toString());

            if (res.statusCode == 200) {
              var responseJson = json.decode(res.body);

              Navigator.of(context, rootNavigator: true).pop('dialog');

              Fluttertoast.showToast(
                  msg: responseJson["message"].toString(),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white);

              Navigator.push(
                context,
                new MaterialPageRoute(builder: (_) => new LoginPage()),
              );
            } else {
              Navigator.of(context, rootNavigator: true).pop('dialog');

              var responseJson = json.decode(res.body);

              Fluttertoast.showToast(
                  msg: responseJson["message"].toString(),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white);
            }
          } else {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            Fluttertoast.showToast(
                msg: allTranslations.text('erreur_title'),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.orange,
                textColor: Colors.white);
          }
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        Fluttertoast.showToast(
            msg: "Impossible de charger votre CNI",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
      }
    }
  }

  void initState() {
    super.initState();

    civi = getElements("2");
    elect = getElements("6");
    sang = getElements("4");
    sit = getElements("8");
    toxico = getElements("9");
    medical = getElements("11");
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
  bool isVisible = true;

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  Future<File>? imageFile;
  PickedFile? _imageFile;
  File? _image;
  File? tmpFile;
  final ImagePicker _picker = ImagePicker();
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

  List<String> _fichier = [];
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
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
                          allTranslations.text('civ_title'),
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
                            return allTranslations.text('requis_title');
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
                            return allTranslations.text('requis_title');
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
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: allTranslations.text('phone1_title'),
                      labelStyle: TextStyle(
                          color: color,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
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
                            return allTranslations.text('requis_title');
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _villeController,
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
                            return allTranslations.text('requis_title');
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
                                       locale:  Locale("fr","FR"),
                                      initialDate: _dateTime == null
                                          ? DateTime.now()
                                          : _dateTime!,
                                      firstDate: DateTime(1920),
                                      lastDate: DateTime(2030))
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
                                    allTranslations.text('datnaiss_title'),
                                labelStyle: TextStyle(
                                    color: color,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return allTranslations.text('requis_title');
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
                           return allTranslations.text('requis_title');
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
                            Icons.security,
                            color: color,
                          ),
                          labelText: allTranslations.text('cni_title'),
                          labelStyle: TextStyle(
                              color: color,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                           return allTranslations.text('requis_title');
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _cniController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  new Container(
                    child: buildView(),
                  ),
                  Center(
                      child: new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        new InkWell(
                          onTap: loadAssets,
                          child: new Container(
                            width: 250.0,
                            height: 50.0,
                            decoration: new BoxDecoration(
                              color: color2,
                              border: new Border.all(
                                  color: Colors.white, width: 2.0),
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: new Center(
                              child: new Text(
                                allTranslations.text("z74"),
                                style: new TextStyle(
                                    fontSize: 14.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
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
                                       locale:  Locale("fr","FR"),
                                      initialDate: _dateTime == null
                                          ? DateTime.now()
                                          : _dateTime!,
                                      firstDate: DateTime(2010),
                                      lastDate: DateTime(2030))
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
                                  _datedelivController.text = formattedDate;
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
                                    allTranslations.text('datedeliv_title'),
                                labelStyle: TextStyle(
                                    color: color,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                 return allTranslations.text('requis_title');
                                }
                              },
                              keyboardType: TextInputType.text,
                              enabled: false,
                              controller: _datedelivController,
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
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
                  Divider(
                    height: 10.0,
                    color: Colors.transparent,
                  ),
                ]),
            Divider(
              height: 15.0,
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
                    labelText: allTranslations.text('fullname') + " *",
                    labelStyle: TextStyle(
                        color: color,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return allTranslations.text('requis_title');
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
                labelStyle: TextStyle(
                    color: color,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
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
              ),
              initialCountryCode: 'CM',
              onChanged: (phone) {
                print(phone.completeNumber);
                if (mounted) {
                  _numero1Controller.text = phone.completeNumber.toString();
                  payslocalisation1 = phone.countryISOCode.toString();
                  codepays1 = phone.countryCode.toString();
                }
              },
            ),
            SizedBox(
              height: 30.0,
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
                    labelText: allTranslations.text('fullname'),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return allTranslations.text('requis_title');
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
                labelText: allTranslations.text('phone_title'),
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
              ),
              initialCountryCode: 'CM',
              onChanged: (phone) {
                print(phone.completeNumber);
                if (mounted) {
                  _numero2Controller.text = phone.completeNumber.toString();
                  payslocalisation2 = phone.countryISOCode.toString();
                  codepays2 = phone.countryCode.toString();
                }
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            Center(
                child: new Text(
              allTranslations.text('para_title'),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: color),
            )),
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
                      Icons.assignment,
                      color: color,
                    ),
                    labelText: allTranslations.text('poids_title'),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return allTranslations.text('requis_title');
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: _poidsController,
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
                      Icons.assignment,
                      color: color,
                    ),
                    labelText: allTranslations.text('taille_title'),
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return allTranslations.text('requis_title');
                    }
                  },
                  keyboardType: TextInputType.number,
                  controller: _tailleController,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 8.0, top: 20.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    allTranslations.text('electro_title'),
                    style: TextStyle(
                        color: color2,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                    textAlign: TextAlign.left,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: elect,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      List<Widget> civ = [];

                      for (int i = 0; i < snapshot.data!.length; i++) {
                        Widget radio = new Radio(
                          value: snapshot.data![i],
                          groupValue: electro,
                          onChanged: _handleRadioValueElect,
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
            Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 8.0, top: 20.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    allTranslations.text('groupe_title'),
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
                  future: sang,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      List<Widget> civ = [];

                      for (int i = 0; i < snapshot.data!.length; i++) {
                        Widget radio = new Radio(
                          value: snapshot.data![i],
                          groupValue: sanguin,
                          onChanged: _handleRadioValueSang,
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
              height: 30.0,
            ),
            Center(
                child: new Text(
              allTranslations.text('antecedent_title').toUpperCase(),
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: color),
            )),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 8.0, bottom: 0.0),
              child: Text(
                allTranslations.text('vie_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
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
                     return allTranslations.text('requis_title');
                    }
                  },
                  keyboardType: TextInputType.text,
                  controller: _professionController,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 8.0, top: 20.0, bottom: 8.0),
                child: Center(
                  child: Text(
                    allTranslations.text('sit_title'),
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
                            return allTranslations.text('requis_title');
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _sportController,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 8.0, bottom: 0.0),
              child: Text(
                allTranslations.text('toxico_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: toxico,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      return _buildToxico(snapshot.data!);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            autre2
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
                              allTranslations.text('toxico4_title') + " *",
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return allTranslations.text('requis_title');
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _autre2Controller,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 8.0, bottom: 0.0),
              child: Text(
                allTranslations.text('toxico5_title'),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 0.0, bottom: 0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: medical,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      return _buildMedical(snapshot.data!);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            autre
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
                              allTranslations.text('toxico4_title') + " *",
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return allTranslations.text('requis_title');
                          }
                        },
                        keyboardType: TextInputType.text,
                        controller: _autre1Controller,
                      ),
                    ),
                  )
                : Container(),
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
            /* CheckboxListTile(
              title: Text(allTranslations.text('cond_title'),
                  style: TextStyle(fontWeight: FontWeight.bold, color: color2)),
              value: _isChecked,
              onChanged: (newValue) {
                setState(() {
                  _isChecked = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),*/

            GestureDetector(
              child: Center(
                  child: Text(allTranslations.text('cond_title'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: color2))),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) =>
                        UserCondition()));
              },
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
                          allTranslations.text('create_title'),
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
