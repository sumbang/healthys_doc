import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/SizeConfig.dart';
import 'package:healthys_medecin/config/image_compress_service.dart';
import 'package:healthys_medecin/models/Content.dart';
import 'package:healthys_medecin/models/DetailConsultation.dart';
import 'package:healthys_medecin/models/soins.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import '../models/Affection.dart';
import '../models/Medicament.dart';
import 'Consultation2.dart';

class Consultation6 extends StatelessWidget {
  String id;

  Consultation6(this.id);

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
              home: Consultation51(this.id),
            );
          },
        );
      },
    );
  }
}

class Consultation51 extends StatefulWidget {
  String id;

  Consultation51(this.id);

  @override
  ConsultationPageState createState() => new ConsultationPageState(this.id);
}

class ConsultationPageState extends State<Consultation51> {
  String id;
  ConsultationPageState(this.id);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool isVideo = false;
  String? _retrieveDataError;
  String? _retrieveDataError1;
  bool _isSaving = true;

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController motifController = TextEditingController();
  final TextEditingController examenController = TextEditingController();
  final TextEditingController diagnosticController = TextEditingController();
  final TextEditingController bilanController = TextEditingController();
  final TextEditingController resultatController = TextEditingController();
  final TextEditingController ordonnanceController = TextEditingController();
  final TextEditingController conclusionController = TextEditingController();

  final TextEditingController libelleController = TextEditingController();
  final TextEditingController valeurController = TextEditingController();
  final TextEditingController examController = TextEditingController();
  final TextEditingController medocController = TextEditingController();
  final TextEditingController priseController = TextEditingController();
  final TextEditingController dureeController = TextEditingController();
  final TextEditingController cpController = TextEditingController();
  final TextEditingController momentController = TextEditingController();

  
  final TextEditingController resultatexamenController = TextEditingController();
  final TextEditingController diagnosticconfirmationController = TextEditingController();
   String dropdownValue = "";

  List<String> exa = [];
  List<String> para = [];
  List<String> soins = [];
  List<String> diag = [];
  var _listPara = [];
  var _listPara1 = [];
  var _listExam = [];
  var _listSoin = [];
  var _listDiag = [];

  Future<File>? imageFile, imageFile1, imageFile2;
  PickedFile? _imageFile, _imageFile1, _imageFile2;
  File? _image, _image1, _image2;
  File? tmpFile, tmpFile1, tmpFile2;
  final ImagePicker _picker = ImagePicker();
  dynamic? _pickImageError;
  final ImagePicker _picker1 = ImagePicker();
  dynamic? _pickImageError1;
  final ImagePicker _picker2 = ImagePicker();
  dynamic? _pickImageError2;

  String? base64Image;
  String? _fileName;
  String? _path;
  String? base64Image1;
  String? _fileName1;
  String? _path1;
  Map<String, String>? _paths;
  String _extension = "png, jpg, jpeg, pdf";
  bool _loadingPath = false;
  bool _multiPick = false;


  Soins? currentSoin;
  Affection? currentAffection;
  Medicament? currentMedoc;
  Future<List<Soins>>? _soins;
  List<Soins> listSoins = [];
  List<Medicament> listMedocs = [];
  Future<List<Medicament>>? _medocs;
  List<Affection> listAffection = [];
  Future<List<Affection>>? _affections;

  bool is_cni = false;
  bool is_ordre = false;
  bool is_resultat = false;

  final gris = const Color(0xFF373736);
  final bleu = const Color(0xFF194185);
  final bleu1 = const Color(0xFF006CA7);
  final bleu2 = const Color(0xFF222651);
  final bleu3 = const Color(0xFF3b5998);
  final clair = const Color(0xFFF9FAFB);

  List<Asset> l_images = <Asset>[];
  List<Asset> l_images1 = <Asset>[];
  List<Asset> l_images2 = <Asset>[];

  List<Widget> buildGridView() {
    return List.generate(l_images.length, (index) {
      Asset asset = l_images[index];
      return Padding(
          padding: EdgeInsets.all(5),
          child: AssetThumb(
            asset: asset,
            width: 200,
            height: 200,
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

  List<Widget> buildGridView2() {
    return List.generate(l_images2.length, (index) {
      Asset asset = l_images2[index];
      return Padding(
          padding: EdgeInsets.all(5),
          child: AssetThumb(
            asset: asset,
            width: 100,
            height: 100,
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
        l_images1[i].identifier,
      );
      File file = File(imagePath);
      files.add(file);
    }
    return files;
  }

  Future<List<File>> convertListAssetToListFile2() async {
    List<File> files = <File>[];
    // images from galllery
    for (int i = 0; i < l_images2.length; i++) {
      String imagePath = await FlutterAbsolutePath.getAbsolutePath(
        l_images2[i].identifier,
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
        maxImages: 1,
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
      if (resultList.length != 0) is_ordre = true;
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
      if (resultList.length != 0) is_cni = true;
    });
  }

  Future<void> loadAssets3() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: l_images2,
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
      l_images2 = resultList;
      if (resultList.length != 0) is_resultat =  true;
    });
  }


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

  Widget _previewImage1() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile1 != null) {
      return Image.file(File(_imageFile1!.path));
    } else if (_pickImageError1 != null) {
      return Text(
        'Erreur : $_pickImageError1',
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        allTranslations.text('noimage_title'),
        textAlign: TextAlign.center,
      );
    }
  }

    Widget _previewImage2() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile2 != null) {
      return Image.file(File(_imageFile2!.path));
    } else if (_pickImageError2 != null) {
      return Text(
        'Erreur : $_pickImageError2',
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

        print("File picked : " + pickedFile!.path.toString());

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
        });
      } catch (e) {
        setState(() {
          _pickImageError1 = e;
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
      _retrieveDataError1 = response.exception!.code;
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

  Future<List<Content>>? contenu;
  Future<DetailConsultation>? details;
  Future<List<Content>> _getContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    MySingleton mySingleton = new MySingleton();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1; 

    var response = await http.get(
        Uri.parse(Setting.apiracine +
            "consultations/" +
            this.id.toString() +
            "?type=1&language=" +
            mySingleton.getLangue.toString()),
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

  Future<DetailConsultation> _getDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    MySingleton mySingleton = new MySingleton();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1; 

    var response = await http.get(
        Uri.parse(Setting.apiracine +
            "consultations/view2?id=" +
            this.id.toString() +
            "?type=1&language=" +
            mySingleton.getLangue.toString()),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA21 :" + response.body.toString());

    List<Content> maliste = [];


      final responseJson = json.decode(response.body);

      return DetailConsultation.fromJson(responseJson);
  
  }


  
 Future<List<Soins>> _getSoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    MySingleton mySingleton = new MySingleton();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Uri.parse(Setting.apiracine +
            "comptes/soins"),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA21 :" + response.body.toString());

    List<Soins> maliste = []; listSoins.clear();


      final responseJson = json.decode(response.body);

      for (int i = 0; i < responseJson.length; i++) {
        maliste.add(Soins.fromJson(responseJson[i]));
        listSoins.add(Soins.fromJson(responseJson[i]));
      }
      return maliste;
   
  }

   Future<List<Medicament>> _getMedocs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    MySingleton mySingleton = new MySingleton();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Uri.parse(Setting.apiracine +
            "comptes/medicament"),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA21 :" + response.body.toString());

    List<Medicament> maliste = []; listMedocs.clear();

      final responseJson = json.decode(response.body);

      for (int i = 0; i < responseJson.length; i++) {
        maliste.add(Medicament.fromJson(responseJson[i]));
        listMedocs.add(Medicament.fromJson(responseJson[i]));
      }
      return maliste;
   
  }

  
   Future<List<Affection>> _getAffections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    MySingleton mySingleton = new MySingleton();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;

    var response = await http.get(
        Uri.parse(Setting.apiracine +
            "comptes/affection"),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA21 :" + response.body.toString());

    List<Affection> maliste = []; listAffection.clear();

      final responseJson = json.decode(response.body);

      for (int i = 0; i < responseJson.length; i++) {
        maliste.add(Affection.fromJson(responseJson[i]));
        listAffection.add(Affection.fromJson(responseJson[i]));
      }
      return maliste;
   
  }



  void initState() {
    super.initState();
    contenu = _getContent();
    details = _getDetail();

    _soins = _getSoins();
    _medocs = _getMedocs();
    _affections = _getAffections();
  }

  List<Widget> _buildList(String datas) {
    List<Widget> listElementWidgetList = <Widget>[];
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
              child: Expanded(
                  child: Text(items[i].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black))),
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

  List<Widget> _buildList2(String datas) {
    List<Widget> listElementWidgetList = <Widget>[];
    List<String> items = datas.split("|");

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
              child: Expanded(
                  child: Text(items[i].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black))),
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

  List<Widget> _buildExpandableContent1(List<Content> items) {
    String texte = "";

    List<Widget> listElementWidgetList = <Widget>[];

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
              child: Expanded(
                  child: Text(items[i].libelle.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black))),
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

  void _removeExa(int pos) {
    print("suppression : " + pos.toString());

    setState(() {
      _listExam = List.from(_listExam)..removeAt(pos);

      exa = List.from(exa)..removeAt(pos);
    });
  }

  void _removePara(int pos) {
    setState(() {
      _listPara1 = List.from(_listPara1)..removeAt(pos);

      para = List.from(para)..removeAt(pos);
    });
  }

  void _removeSoins(int pos) {
    setState(() {
      _listSoin = List.from(_listSoin)..removeAt(pos);

      soins = List.from(soins)..removeAt(pos);
    });
  }

  void _removeDiag(int pos) {
    setState(() {
      _listDiag = List.from(_listDiag)..removeAt(pos);

      diag = List.from(diag)..removeAt(pos);
    });
  }


  _addPara() {
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
                            allTranslations.text("z46"),
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
              content: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Container(
                          height: 320.0,
                          width: 300.0, // Change as per your requirement
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(allTranslations.text("z47")+ " *"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: new BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1.0)),
                                    border:
                                        new Border.all(color: Colors.black38),
                                  ),
                                  child: TextFormField(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        hintText: allTranslations.text("z48"),
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      controller: libelleController,
                                      keyboardType: TextInputType.text),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(allTranslations.text("z49")+ " *"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: new BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1.0)),
                                    border:
                                        new Border.all(color: Colors.black38),
                                  ),
                                  child: TextFormField(
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      controller: valeurController,
                                      keyboardType: TextInputType.text),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: new Center(
                                    child: new InkWell(
                                      onTap: () {
                                        if (libelleController.text
                                                .toString()
                                                .isEmpty ||
                                            valeurController.text
                                                .toString()
                                                .isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: allTranslations
                                                  .text('requis1_title'),
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white);
                                        } else {
                                          String json = '{"libelle":"' +
                                              libelleController.text
                                                  .toString() +
                                              '","valeur":"' +
                                              valeurController.text.toString() +
                                              '"}';

                                          para.add(json);

                                          int pos = para.length - 1;

                                          _listPara1.add(Column(children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 15.0,
                                                    top: 0,
                                                    bottom: 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    new Expanded(
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17.0),
                                                          child: new Text(
                                                              libelleController
                                                                      .text
                                                                      .toString() +
                                                                  " : " +
                                                                  valeurController
                                                                      .text
                                                                      .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ))),
                                                    ),
                                                    new IconButton(
                                                        icon: new Icon(
                                                          Icons.delete,
                                                          color: color,
                                                        ),
                                                        onPressed: () {
                                                          _removePara(pos);
                                                        }),
                                                  ],
                                                )),
                                            Divider(
                                                height: 5, color: Colors.grey)
                                          ]));

                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');

                                          setState(() {
                                            libelleController.text = "";
                                            valeurController.text = "";
                                          });
                                        }
                                      },
                                      child: new Container(
                                        width: 200.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                          color: color2,
                                          border: new Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        child: new Center(
                                          child: new Text(
                                           allTranslations.text("z28"),
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          )))));
        });
  }

  _addExam() {
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
                            allTranslations.text("z91"),
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
              content: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Container(
                         // height: 250.0,
                          width: 300.0, // Change as per your requirement
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(allTranslations.text("z91")+" *"),
                              ),
                              Divider(height: 10, color: Colors.transparent,),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  padding: const EdgeInsets.all(0.0),
                                  width: double.infinity,
                                  /*decoration: new BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0)),
                                    border:
                                        new Border.all(color: Colors.black38),
                                  ),*/
                                  child:SimpleAutocompleteFormField<Soins>(
               decoration: InputDecoration(labelText: "Saisir un examen ", border: OutlineInputBorder()),
                //suggestionsHeight: 300.0,
                maxSuggestions: 5,
                itemBuilder: (context, person) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(person!.nom, style: TextStyle(fontWeight: FontWeight.normal)),
                  ]),
                ),
                onSearch: (search) async => listSoins
                    .where((person) =>
                        person.nom.toLowerCase().contains(search.toLowerCase()))
                    .toList(),
                itemFromString: (string) {
                  final matches = listSoins.where((person) => person.nom.toLowerCase() == string.toLowerCase());
                  return matches.isEmpty ? null : matches.first;
                },
                initialValue: null,
                controller: examController,
                onChanged: (value) => setState(() => currentSoin = value),
                onSaved: (value) => setState(() => currentSoin = value),
                //validator: (person) => person == null ? 'Invalid person.' : null,
              )
                                 /* child: TextFormField(
                                      maxLines: 3,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      controller: examController,
                                      keyboardType: TextInputType.multiline),*/
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: new Center(
                                    child: new InkWell(
                                      onTap: () {
                                        if (examController.text
                                            .toString()
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: allTranslations
                                                  .text('requis1_title'),
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white);
                                        } else {
                                          String json = '{"libelle":"' +
                                              examController.text.toString() +
                                              '"}';

                                          exa.add(json);

                                          int pos = exa.length - 1;

                                          _listExam.add(Column(
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
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17.0),
                                                          child: new Text(
                                                              examController
                                                                  .text
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ))),
                                                    ),
                                                    new IconButton(
                                                        icon: new Icon(
                                                          Icons.delete,
                                                          color: color,
                                                        ),
                                                        onPressed: () {
                                                          _removeExa(pos);
                                                        }),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                  height: 5, color: Colors.grey)
                                            ],
                                          ));

                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');

                                          setState(() {
                                            examController.text = "";
                                          });
                                        }
                                      },
                                      child: new Container(
                                        width: 200.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                          color: color2,
                                          border: new Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        child: new Center(
                                          child: new Text(
                                            allTranslations.text("z28"),
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          )))));
        });
  }

  _addDiag() {
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
                            allTranslations.text('para10').toUpperCase(),
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
              content: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Container(
                         // height: 250.0,
                          width: 300.0, // Change as per your requirement
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    allTranslations.text('para8').toString() +
                                        "*"),
                              ),
                              SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  padding: const EdgeInsets.all(0.0),
                                  width: double.infinity,
                                 // height: 70,
                              /*    decoration: new BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(1.0)),
                                    border:
                                        new Border.all(color: Colors.black38),
                                  ),*/
                                   child:SimpleAutocompleteFormField<Affection>(
               decoration: InputDecoration(labelText: "Saisir un diagnostic ", border: OutlineInputBorder()),
                //suggestionsHeight: 300.0,
                maxSuggestions: 5,
                itemBuilder: (context, person) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(person!.lib_affection, style: TextStyle(fontWeight: FontWeight.normal)),
                  ]),
                ),
                onSearch: (search) async => listAffection
                    .where((person) =>
                        person.lib_affection.toLowerCase().contains(search.toLowerCase()))
                    .toList(),
                itemFromString: (string) {
                  final matches = listAffection.where((person) => person.lib_affection.toLowerCase() == string.toLowerCase());
                  return matches.isEmpty ? null : matches.first;
                },
                initialValue: null,
                controller: diagnosticController,
                onChanged: (value) => setState(() => currentAffection = value),
                onSaved: (value) => setState(() => currentAffection = value),
                //validator: (person) => person == null ? 'Invalid person.' : null,
              )
                                /*  child: TextFormField(
                                      maxLines: 3,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      controller: diagnosticController,
                                      keyboardType: TextInputType.multiline),*/
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(allTranslations.text('z68').toString(),style: TextStyle(fontSize: 11, color:color)),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: new Center(
                                    child: new InkWell(
                                      onTap: () {
                                        if (diagnosticController.text
                                            .toString()
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: allTranslations
                                                  .text('requis1_title'),
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Colors.blue,
                                              textColor: Colors.white);
                                        } else {
                                          String json = '{"libelle":"' +
                                              diagnosticController.text
                                                  .toString() +
                                              '"}';

                                          diag.add(json);

                                          int pos = diag.length - 1;

                                          _listDiag.add(Column(
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
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 17.0),
                                                          child: new Text(
                                                              diagnosticController
                                                                  .text
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black,
                                                              ))),
                                                    ),
                                                    new IconButton(
                                                        icon: new Icon(
                                                          Icons.delete,
                                                          color: color,
                                                        ),
                                                        onPressed: () {
                                                          _removeDiag(pos);
                                                        }),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                  height: 5, color: Colors.grey)
                                            ],
                                          ));

                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');

                                          setState(() {
                                            diagnosticController.text = "";
                                          });
                                        }
                                      },
                                      child: new Container(
                                        width: 200.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                          color: color2,
                                          border: new Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        child: new Center(
                                          child: new Text(
                                            allTranslations.text("z28"),
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          )))));
        });
  }

  int _value = 1;
  int _value1 = 1;
  String matin = "Matin";
  String midi = "Midi";
  String apresmidi = "Après-midi";
  String soir = "Soir";
  String coucher = "Au coucher";
  List<String> selectedZone = [];

  _addSoins(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, refresh) {
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
                              allTranslations.text("z52"),
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
                content: SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(),
                        child: Container(
                            width: 300.0, // Ch
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(allTranslations.text("z101")+" *"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(0.0),
                                      width: double.infinity,
                                      //height: 70,
                                     /* decoration: new BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1.0)),
                                        border: new Border.all(
                                            color: Colors.black38),
                                      ),*/
                                             child:SimpleAutocompleteFormField<Medicament>(
                decoration: InputDecoration(labelText: "Saisir un medicament *", border: OutlineInputBorder()),
                //suggestionsHeight: 80.0,
                maxSuggestions: 5,
                itemBuilder: (context, person) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(person!.nom, style: TextStyle(fontWeight: FontWeight.normal)),
                  ]),
                ),
                onSearch: (search) async => listMedocs
                    .where((person) =>
                        person.nom.toLowerCase().contains(search.toLowerCase()))
                    .toList(),
                itemFromString: (string) {
                  final matches = listMedocs.where((person) => person.nom.toLowerCase() == string.toLowerCase());
                  return matches.isEmpty ? null : matches.first;
                },
                initialValue: null,
                controller: medocController,
                onChanged: (value) => setState(() => currentMedoc = value),
                onSaved: (value) => setState(() => currentMedoc = value),
               // validator: (person) => person == null ? 'Invalid person.' : null,
              )
                                     /* child: TextFormField(
                                          maxLines: 3,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          controller: medocController,
                                          keyboardType:
                                              TextInputType.multiline),*/
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                     child: Text(allTranslations.text("z102")+" *"),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(12.0),
                                          width: 80,
                                          height: 50,
                                          decoration: new BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1.0)),
                                            border: new Border.all(
                                                color: Colors.black38),
                                          ),
                                          child: TextFormField(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              controller: priseController,
                                              keyboardType:
                                                  TextInputType.number),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.0, left: 8.0, right: 8.0),
                                        child: Text(
                                          "X",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: DropdownButton(
                                              value: _value,
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text(allTranslations.text("z98")),
                                                  value: 1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("Ml"),
                                                  value: 2,
                                                ),
                                                DropdownMenuItem(
                                                    child: Text(allTranslations.text("z99")),
                                                    value: 3)
                                              ],
                                              onChanged: (value) {
                                                refresh(() {
                                                  setState(() {
                                                    _value = value!;
                                                  });
                                                });
                                              }))
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(allTranslations.text("z103")+ "*"),
                                  ),
                                  Column(children: [
                                    CheckboxListTile(
                                      onChanged: (bool? value) {
                                        if (mounted) {
                                          setState(() {
                                            if (value!) {
                                              selectedZone.add(matin);
                                            } else {
                                              selectedZone.remove(matin);
                                            }
                                          });
                                        }
                                        Navigator.of(context).pop(); // Line 1
                                        _addSoins(context);
                                      },
                                      value: selectedZone.contains(matin),
                                      title: new Text(matin),
                                    ),
                                    CheckboxListTile(
                                      onChanged: (bool? value) {
                                        if (mounted) {
                                          setState(() {
                                            if (value!) {
                                              selectedZone.add(midi);
                                            } else {
                                              selectedZone.remove(midi);
                                            }
                                          });
                                          Navigator.of(context).pop(); // Line 1
                                          _addSoins(context);
                                        }
                                      },
                                      value: selectedZone.contains(midi),
                                      title: new Text(midi),
                                    ),
                                    CheckboxListTile(
                                      onChanged: (bool? value) {
                                        if (mounted) {
                                          setState(() {
                                            if (value!) {
                                              selectedZone.add(apresmidi);
                                            } else {
                                              selectedZone.remove(apresmidi);
                                            }
                                          });
                                          Navigator.of(context).pop(); // Line 1
                                          _addSoins(context);
                                        }
                                      },
                                      value: selectedZone.contains(apresmidi),
                                      title: new Text(apresmidi),
                                    ),
                                    CheckboxListTile(
                                      onChanged: (bool? value) {
                                        if (mounted) {
                                          setState(() {
                                            if (value!) {
                                              selectedZone.add(soir);
                                            } else {
                                              selectedZone.remove(soir);
                                            }
                                          });
                                          Navigator.of(context).pop(); // Line 1
                                          _addSoins(context);
                                        }
                                      },
                                      value: selectedZone.contains(soir),
                                      title: new Text(soir),
                                    ),
                                    CheckboxListTile(
                                      onChanged: (bool? value) {
                                        if (mounted) {
                                          setState(() {
                                            if (value!) {
                                              selectedZone.add(coucher);
                                            } else {
                                              selectedZone.remove(coucher);
                                            }
                                          });
                                          Navigator.of(context).pop(); // Line 1
                                          _addSoins(context);
                                        }
                                      },
                                      value: selectedZone.contains(coucher),
                                      title: new Text(coucher),
                                    ),
                                  ]),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(allTranslations.text("z104")+" *"),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(12.0),
                                          width: 80,
                                          height: 50,
                                          decoration: new BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(1.0)),
                                            border: new Border.all(
                                                color: Colors.black38),
                                          ),
                                          child: TextFormField(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              controller: dureeController,
                                              keyboardType:
                                                  TextInputType.number),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20.0, left: 8.0, right: 8.0),
                                        child: Text(
                                          "X",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: DropdownButton(
                                              value: _value1,
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text(allTranslations.text("z95")),
                                                  value: 1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(allTranslations.text("z96")),
                                                  value: 2,
                                                ),
                                                DropdownMenuItem(
                                                    child: Text(allTranslations.text("z97")),
                                                    value: 3)
                                              ],
                                              onChanged: (value) {
                                                refresh(() {
                                                  setState(() {
                                                    _value1 = value!;
                                                  });
                                                });
                                              }))
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: new Center(
                                        child: new InkWell(
                                          onTap: () {
                                            if (medocController.text.toString().isEmpty ||
                                                dureeController.text
                                                    .toString()
                                                    .isEmpty ||
                                                priseController.text
                                                    .toString()
                                                    .isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: allTranslations
                                                      .text('requis1_title'),
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 5,
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white);
                                            } else if (selectedZone.length ==
                                                0) {
                                              Fluttertoast.showToast(
                                                  msg: allTranslations
                                                      .text('requis1_title'),
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 5,
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white);
                                            } else {
                                              int pos = 0;

                                              if (soins.length == 0)
                                                pos = 0;
                                              else
                                                pos = soins.length - 1;
                                              String duree1 = "";
                                              String prise1 = "";

                                              if (_value1 == 1)
                                                duree1 = allTranslations.text("z95");
                                              else if (_value1 == 2)
                                                duree1 = allTranslations.text("z96");
                                              else if (_value1 == 3)
                                                duree1 = allTranslations.text("z97");

                                              if (_value == 1)
                                                prise1 = allTranslations.text("z98");
                                              else if (_value == 2)
                                                prise1 = "Ml";
                                              else if (_value == 3)
                                                prise1 = allTranslations.text("z99");
                                              else if (_value == 4)
                                                prise1 = allTranslations.text("z100");

                                              String meszones = "";

                                              for (int a = 0;
                                                  a < selectedZone.length;
                                                  a++) {
                                                if (a == 0)
                                                  meszones += selectedZone[a]
                                                      .toString();
                                                else
                                                  meszones += "," +
                                                      selectedZone[a]
                                                          .toString();
                                              }

                                              String json = '{"medoc":"' +
                                                  medocController.text
                                                      .toString() +
                                                  '","prise":"' +
                                                  priseController.text
                                                      .toString() +
                                                  '","duree":"' +
                                                  dureeController.text
                                                      .toString() +
                                                  '","dose":"' +
                                                  prise1.toString() +
                                                  '","periode":"' +
                                                  duree1.toString() +
                                                  '","heure":"' +
                                                  meszones.toString() +
                                                  '"}';

                                              soins.add(json);

                                              _listSoin.add(Column(
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        new Expanded(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            new Text(
                                                                medocController
                                                                    .text
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            new Text(
                                                                priseController
                                                                        .text
                                                                        .toString() +
                                                                    " " +
                                                                    prise1
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            new Text(
                                                                allTranslations.text("z93") +
                                                                    dureeController
                                                                        .text
                                                                        .toString()
                                                                        .toUpperCase() +
                                                                    " " +
                                                                    duree1,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            SizedBox(
                                                              height: 5.0,
                                                            ),
                                                            new Text(
                                                                allTranslations.text("z94") +
                                                                    meszones
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            SizedBox(
                                                                height: 5.0),
                                                          ],
                                                        )),
                                                        new IconButton(
                                                            icon: new Icon(
                                                              Icons.delete,
                                                              color: color,
                                                            ),
                                                            onPressed: () {
                                                              _removeSoins(pos);
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                      height: 5,
                                                      color: Colors.grey)
                                                ],
                                              ));

                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop('dialog');

                                              setState(() {
                                                medocController.text = "";
                                                dureeController.text = "";
                                                priseController.text = "";
                                                cpController.text = "";
                                                momentController.text = "";
                                                selectedZone.clear();
                                              });
                                            }
                                          },
                                          child: new Container(
                                            width: 200.0,
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
                                                allTranslations.text("z28"),
                                                style: new TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                ])))));
          },
        );
      },
    );
  }

  void _submitForms() async {
    MySingleton mySingleton = new MySingleton();

    if (motifController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
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

      String scan1 = "";
      String scan2 = "";
      String scan3 = "";

      Uri uri = Uri.parse(Setting.apiracine + "comptes/uploaders");

      if (l_images.length != 0) {
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
        request1.fields["types"] = "cons";

        var response1 = await request1.send();

        var res1 = await http.Response.fromStream(response1);

        print("photo1 : " + res1.body.toString());

        var responseCni = json.decode(res1.body.toString());

        scan1 = responseCni[0]["path"];
      }

      if (l_images1.length != 0) {
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
        request2.fields["types"] = "cons";

        var response2 = await request2.send();

        var res2 = await http.Response.fromStream(response2);

        print("photo2 : " + res2.body.toString());

        var responseOrdre = json.decode(res2.body.toString());

        scan2 = responseOrdre[0]['path'];
      }

       if (l_images2.length != 0) {
        List<File> file2 = await convertListAssetToListFile2();

        MultipartRequest request3 = http.MultipartRequest("POST", uri);

        for (int i = 0; i < file2.length; i++) {

          ImageCompressService imageCompressService = ImageCompressService(
            file: file2[i],
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
          request3.files.add(multipartFile);
        }

        request3.fields["qte"] = file2.length.toString();
        request3.fields["types"] = "res";

        var response3 = await request3.send();

        var res3 = await http.Response.fromStream(response3);

        print("photo2 : " + res3.body.toString());

        var responseOrdre1 = json.decode(res3.body.toString());

        for(int j = 0; j < responseOrdre1.length; j++){
          if(j == 0) scan3+= responseOrdre1[j]['path'];
          else scan3+= "|"+responseOrdre1[j]['path'];
        }

      }

      //String _para = '[';
      String _exam = '[';
      String _traitement = '[';
      String _diag = '[';

      for (int i = 0; i < exa.length; i++) {
        if (i == 0)
          _exam += exa[i];
        else
          _exam += "," + exa[i];
      }

      for (int i = 0; i < soins.length; i++) {
        if (i == 0)
          _traitement += soins[i];
        else
          _traitement += "," + soins[i];
      }

     /* for (int i = 0; i < diag.length; i++) {
        if (i == 0)
          _diag += diag[i];
        else
          _diag += "," + diag[i];
      }*/

      //_para += ']';
      _traitement += ']';
      _exam += ']';
      _diag += ']';

       MySingleton mySingleton = new MySingleton();

      Map data = {
        'diagnostic': _diag,
        'traitement': _traitement,
        'mise1': dropdownValue.toString(),
        'resultat1': scan3,
        'diagnostic1': diagnosticconfirmationController.text.toString(),
        'exams': _exam,
        'motif': motifController.text.toString(),
        'scan1': scan1,
        'scan2': scan2,
        'language': mySingleton.getLangue.toString()
      };

      print("Requete : " + data.toString());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token1 = (prefs.getString('token') ?? '');
      String basicAuth = 'Bearer ' + token1; 

      var res = await http.put(
          Uri.parse(Setting.apiracine + "consultations/update2?id=" + this.id.toString()),
          body: data,
          headers: {
            "Authorization": basicAuth,
            "Language": mySingleton.getLangue.toString(),
          });

      print("Retour : " + res.body.toString());

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
          new MaterialPageRoute(builder: (_) => new Consultation2()),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return Scaffold(
        backgroundColor: Color(0xffF8F8FA),
        body: FutureBuilder(
            future: Future.wait([contenu!, details!]),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData) {
                if (snapshot.data[0] == null) {
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
                } else if (snapshot.data![0].toString().contains("PHP Notice")) {
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
                  List<Content> identification = [];
                  List<Content> parametres = [];
                  List<Content> antecedents = [];
                  List<Content> antecedents1 = [];
                  String motif = "";
                  String photo = "";
                  String nom = "";
                  String adresse = "";
                  String datnaiss = "";

                  for (int i = 0; i < snapshot.data[0].length; i++) {
                         if (snapshot.data![0][i].groupe == 1) {
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

                  DetailConsultation deta = snapshot.data![1];

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
                    children: <Widget>[
                      Container(
                        color: color,
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
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (_) =>
                                                new Consultation2()),
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
                                                Setting.serveurimage1 +
                                                    '' +
                                                    photo))),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Expanded(
                                      child: Column(
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
                                        allTranslations.text("z220") + truedate,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ))
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
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 30.0),
                                    child: Center(
                                      child: Text(
                                        allTranslations.text('raison') + " *",
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 2.2 *
                                                SizeConfig.textMultiplier),
                                      ),
                                    )),
                                SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 5.0,
                                        top: 3.0,
                                        bottom: 3.0),
                                    width: double.infinity,
                                    decoration: new BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      border:
                                          new Border.all(color: Colors.black38),
                                    ),
                                    child: TextFormField(
                                      obscureText: false,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: new Icon(
                                          Icons.message,
                                          color: color,
                                        ),
                                        labelText: allTranslations
                                                .text('comment_title') +
                                            " *",
                                        labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      controller: motifController,
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 30.0),
                                  child: Column(
                                    children: <Widget>[
                                    /*  SizedBox(height: 20),
                                      Text(
                                          allTranslations
                                              .text('diagnostic_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      SizedBox(height: 10),
                                      Container(
                                          child: Column(
                                        children: this._listDiag,
                                      )),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          _addDiag();
                                        },
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Image.asset(
                                                    "img/download.png",
                                                    width: 25.0,
                                                    fit: BoxFit.contain,
                                                    alignment:
                                                        Alignment.centerLeft),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      top: 1 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  child: Center(
                                                    child: Text(
                                                      allTranslations
                                                          .text('para6'),
                                                      style: TextStyle(
                                                          color: color2,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 2.1 *
                                                              SizeConfig
                                                                  .textMultiplier),
                                                    ),
                                                  ))
                                            ]),
                                      ),*/
                                      SizedBox(height: 20),
                                      Text(allTranslations.text('cmt_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      /*  SizedBox(height: 20),
                                      deta.scan1 != null
                                          ? !deta.scan1.isEmpty
                                              ? Image.network(
                                                  Setting.serveurimage +
                                                      '' +
                                                      deta.scan1,
                                                  fit: BoxFit.fill)
                                              : Container()
                                          : Container(),*/
                                      Container(
                                          child: Column(
                                        children: this._listExam.cast<Widget>(),
                                      )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _addExam();
                                        },
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Image.asset(
                                                    "img/download.png",
                                                    width: 25.0,
                                                    fit: BoxFit.contain,
                                                    alignment:
                                                        Alignment.centerLeft),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      top: 1 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  child: Center(
                                                    child: Text(
                                                      allTranslations
                                                          .text('para2'),
                                                      style: TextStyle(
                                                          color: color2,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 2.1 *
                                                              SizeConfig
                                                                  .textMultiplier),
                                                    ),
                                                  ))
                                            ]),
                                      ),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 8.0,
                                            top: 8.0,
                                            bottom: 10.0),
                                        child: Center(
                                            child: Text(
                                          allTranslations.text("z69"),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                          textAlign: TextAlign.left,
                                        )),
                                      ),
                                      (!is_ordre)
                                          ? GestureDetector(
                                              onTap: loadAssets1,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 5,
                                                      top: 0),
                                                  child: DottedBorder(
                                                    borderType:
                                                        BorderType.RRect,
                                                    color: Colors.grey,
                                                    radius: Radius.circular(12),
                                                    padding: EdgeInsets.all(1),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 160,
                                                        color: clair,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                  "img/path.png",
                                                                  width: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  alignment:
                                                                      Alignment
                                                                          .center),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                allTranslations.text("z88"),
                                                                style: TextStyle(
                                                                    color: bleu,
                                                                    height: 1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        15.0),
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                allTranslations.text("z23"),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    height: 1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: buildGridView(),
                                            )
                                          : Container(),
                                      (is_ordre)
                                          ? Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    is_ordre = false;
                                                    l_images.clear();
                                                  });
                                                },
                                                child: Text(
                                                  allTranslations.text("z24"),
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      height: 1.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                          Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              top: 3 *
                                                  SizeConfig.heightMultiplier),
                                          child: Center(
                                            child: Text(
                                              allTranslations
                                                  .text('z70'),
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.2 *
                                                      SizeConfig
                                                          .textMultiplier),
                                            ),
                                          )),
                                          SizedBox(height: 10,),
                                            (!is_resultat)
                                          ? GestureDetector(
                                              onTap: loadAssets3,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 5,
                                                      top: 0),
                                                  child: DottedBorder(
                                                    borderType:
                                                        BorderType.RRect,
                                                    color: Colors.grey,
                                                    radius: Radius.circular(12),
                                                    padding: EdgeInsets.all(1),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 160,
                                                        color: clair,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                  "img/path.png",
                                                                  width: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  alignment:
                                                                      Alignment
                                                                          .center),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                allTranslations.text("z89"),
                                                                style: TextStyle(
                                                                    color: bleu,
                                                                    height: 1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        15.0),
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                allTranslations.text("z114"),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    height: 1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            )
                                          : Container(),
                                      (is_resultat)
                                          ? SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: buildGridView2(),
                                            ))
                                          : Container(),
                                      (is_resultat)
                                          ? Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    is_resultat =  false;
                                                    l_images2.clear();
                                                  });
                                                },
                                                child: Text(
                                                  allTranslations.text("z24"),
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      height: 1.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(height: 20),
                                       Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              top: 3 *
                                                  SizeConfig.heightMultiplier),
                                          child: Center(
                                            child: Text(
                                              allTranslations
                                                  .text('z72'),
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.2 *
                                                      SizeConfig
                                                          .textMultiplier),
                                            ),
                                          )),
                                              Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              top: 3.0,
                                              bottom: 3.0),
                                          width: double.infinity,
                                          decoration: new BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            border: new Border.all(
                                                color: Colors.black38),
                                          ),
                                          child: TextFormField(
                                            obscureText: false,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              icon: new Icon(
                                                Icons.message,
                                                color: color,
                                              ),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            controller: diagnosticconfirmationController,
                                            maxLines: 3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          allTranslations
                                              .text('ordonnance_title'),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier)),
                                      /*  SizedBox(height: 20),
                                      deta.scan2 != null
                                          ? !deta.scan2.isEmpty
                                              ? Image.network(
                                                  Setting.serveurimage +
                                                      '' +
                                                      deta.scan2,
                                                  fit: BoxFit.fill)
                                              : Container()
                                          : Container(),*/
                                      Container(
                                          child: Column(
                                        children: this._listSoin.cast<Widget>(),
                                      )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _addSoins(context);
                                        },
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Image.asset(
                                                    "img/download.png",
                                                    width: 25.0,
                                                    fit: BoxFit.contain,
                                                    alignment:
                                                        Alignment.centerLeft),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      top: 1 *
                                                          SizeConfig
                                                              .heightMultiplier),
                                                  child: Center(
                                                    child: Text(
                                                      allTranslations
                                                          .text('para3'),
                                                      style: TextStyle(
                                                          color: color2,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 2.1 *
                                                              SizeConfig
                                                                  .textMultiplier),
                                                    ),
                                                  ))
                                            ]),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 8.0,
                                            top: 8.0,
                                            bottom: 10.0),
                                        child: Center(
                                            child: Text(
                                          allTranslations.text("z71"),
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                          textAlign: TextAlign.left,
                                        )),
                                      ),
                                      (!is_cni)
                                          ? GestureDetector(
                                              onTap: loadAssets2,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      bottom: 5,
                                                      top: 0),
                                                  child: DottedBorder(
                                                    borderType:
                                                        BorderType.RRect,
                                                    color: Colors.grey,
                                                    radius: Radius.circular(12),
                                                    padding: EdgeInsets.all(1),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 160,
                                                        color: clair,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                  "img/path.png",
                                                                  width: 50.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  alignment:
                                                                      Alignment
                                                                          .center),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                allTranslations.text("z88"),
                                                                style: TextStyle(
                                                                    color: bleu,
                                                                    height: 1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        15.0),
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                allTranslations.text("z23"),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    height: 1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: buildGridView1(),
                                            )
                                          : Container(),
                                      (is_cni)
                                          ? Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    is_cni = false;
                                                    l_images1.clear();
                                                  });
                                                },
                                                child: Text(
                                                  allTranslations.text("z24"),
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      height: 1.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                  SizedBox(height: 20),
                                       Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.0,
                                              top: 3 *
                                                  SizeConfig.heightMultiplier),
                                          child: Center(
                                            child: Text(
                                              allTranslations
                                                  .text('z73'),
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.2 *
                                                      SizeConfig
                                                          .textMultiplier),
                                            ),
                                          )),
                                              Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              top: 3.0,
                                              bottom: 3.0),
                                          width: double.infinity,
                                          decoration: new BoxDecoration(
                                            color: Colors.white70,
                                          ),
                                          child:  DropdownButton<String>(
                                                    value: dropdownValue,
                                                    icon: const Icon(Icons.arrow_drop_down_sharp),
                                                    elevation: 16,
                                                    style: const TextStyle(color: Colors.deepPurple),
                                                    underline: Container(
                                                      height: 2,
                                                      color: Colors.deepPurpleAccent,
                                                    ),
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        dropdownValue = newValue!;
                                                      });
                                                    },
                                                    items: <String>['', 'Observation', 'Hospitalisation', 'Ambulatoire']
                                                        .map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                                                      ),
                                      ),
                                SizedBox(height: 30.0),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 10.0),
                                    child: Center(
                                      child: new InkWell(
                                        onTap: () {
                                          _submitForms();
                                        },
                                        child: new Container(
                                          width: 200.0,
                                          height: 50.0,
                                          decoration: new BoxDecoration(
                                            color: color,
                                            border: new Border.all(
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          child: new Center(
                                            child: new Text(
                                              allTranslations
                                                  .text('save1_title'),
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                SizedBox(height: 30.0)
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
