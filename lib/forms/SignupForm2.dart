import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/image_compress_service.dart';
import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:healthys_medecin/pages/LoginPage.dart';
import 'package:healthys_medecin/pages/UserCondition.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mime/mime.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/all_translations.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class SignupForm2 extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupForm2> {
  MyItems? civilite;
  MyItems? pays;
  MyItems? sexe;
  MyItems? specialite;
  MyItems? vaca;
  DateTime? _datenaiss;
  bool is_cni = false;
  bool is_ordre = false;
  bool is_image = false;

  final _sign = GlobalKey<SignatureState>();
  String signatures = "";
  ByteData _img = ByteData(0);
  var strokeWidth = 5.0;

  /** image pour uploads */

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

    List<Widget> buildGridView2() {
    return List.generate(l_images2.length, (index) {
      Asset asset = l_images2[index];
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

    Future<void> loadAssets3() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
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
      if (resultList.length != 0) is_image = true;
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

  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);
  final gris = const Color(0xFF373736);
  final bleu = const Color(0xFF194185);
  final bleu1 = const Color(0xFF006CA7);
  final bleu2 = const Color(0xFF222651);
  final bleu3 = const Color(0xFF3b5998);
  final clair = const Color(0xFFF9FAFB);

  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _datnaissController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _villeController = TextEditingController();
  final _adresseController = TextEditingController();
  final _emailController = TextEditingController();
  final _ordreController = TextEditingController();
  final _cniController = TextEditingController();
  final _datedelivController = TextEditingController();

  bool _isChecked = false;
  bool _isSaving = true;
  DateTime? _dateTime;
  DateTime? _dateTime1;

  MyItems? zone;
  Future<List<MyItems>>? _listZone;
  List<MyItems> selectedZone = [];

  Future<List<MyItems>> getElements(String nature) async {
    List<MyItems> liste = [];

     MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Uri.parse(Setting.apiracine + "comptes/data?types=" + nature.toString()),
        headers: {"Language": mySingleton.getLangue.toString(),});

      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
    
  }

  Future<List<MyItems>> getZone(String nature) async {
    List<MyItems> liste = [];

    print("search zone");

     MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Uri.parse(Setting.apiracine + "comptes/zone?pays=" + nature.toString()),
        headers: {"Language": mySingleton.getLangue.toString(),});

    print("zone : " + response.body.toString());


      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(MyItems.fromJson(responseJson[i]));
      }

      return liste;
   
  }

  Widget _builZone(List<MyItems> list) {
    List<Widget> mList = [];

    for (int b = 0; b < list.length; b++) {
      MyItems cmap = list[b];

      mList.add(CheckboxListTile(
        onChanged: (bool? value) {
          if (mounted) {
            setState(() {
              if (value!) {
                selectedZone.add(cmap);
              } else {
                selectedZone.remove(cmap);
              }
            });
          }
        },
        value: selectedZone.contains(cmap),
        title: new Text(cmap.libelle.toString()),
      ));
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: mList,
    );
  }

  String? base64Image;
  String? base64Image1;
  String? base64Image2;
  String? _fileName;
  String? _path;
  Map<String, String>? _paths;
  String _extension = "png, jpg, jpeg, pdf";
  bool _loadingPath = false;
  bool _multiPick = false;

  void _submitForms() async {
    MySingleton mySingleton = new MySingleton();


    // recuperation de l'objet signature
    final sign2 = _sign.currentState;
    final image = await sign2!.getData();
    var data = await image.toByteData(format: ui.ImageByteFormat.png);
    final encoded = base64.encode(data!.buffer.asUint8List());
    setState(() {
      _img = data;
    });

    // _uploadImage2();

    if (_nomController.text.isEmpty ||
        _phone1Controller.text.isEmpty ||
        _cniController.text.isEmpty ||
        _emailController.text.isEmpty ||
        civilite == null ||
        specialite == null ||
        _datedelivController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } 
    else if (!sign2.hasPoints) {
      Fluttertoast.showToast(
          msg: allTranslations.text('condition_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    }else if (l_images1.length == 0) {
      Fluttertoast.showToast(
          msg: allTranslations.text('z84'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (l_images2.length == 0) {
      Fluttertoast.showToast(
          msg: allTranslations.text('z85'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (l_images.length != 2) {
      Fluttertoast.showToast(
          msg: allTranslations.text('z86'),
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

      // start the modal progress HUD
      setState(() {
        _isSaving = false;
      });

      // chargement des cni
      String _ordre = "";
      String _signature = "";
      String _profil = "";

      List<File> file = await convertListAssetToListFile();
      List<File> file1 = await convertListAssetToListFile1();
      List<File> file2 = await convertListAssetToListFile2();

      Uri uri = Uri.parse(Setting.apiracine + "comptes/uploaders");

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
      request3.fields["types"] = "profil";

      var response3 = await request3.send();

      var res3 = await http.Response.fromStream(response3);

      var responseOrdre = json.decode(res2.body.toString());

      var responseCni = json.decode(res1.body.toString());

      var responseProfil = json.decode(res3.body.toString());

      String _cnifile = responseCni[0]["path"] + "|" + responseCni[1]["path"];

            // uploads de la signature
      Map _data = {
        "image": encoded,
        "name": "jpg",
      };

      var res5 =
          await http.post(Uri.parse(Setting.apiracine + "comptes/uploader"), body: _data);
      if (res5.statusCode == 200) {
        setState(() {
          _signature = res5.body.toString();
        });
      }

      String meszones = "";

      _ordre = responseOrdre[0]['path'];  _profil = responseProfil[0]['path']; 

      String _hospit = '[';

      _hospit += ']'; int vac = 0;

      if(vaca != null) vac = vaca!.id;

       MySingleton mySingleton = new MySingleton();

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
        'cni': _cniController.text.toString(),
        'datedeliv': _datedelivController.text.toString(),
        'specialite': specialite!.id.toString(),
        'ordre': _ordreController.text.toString(),
        'role': '2',
        'photo': '',
        'photo1': _ordre,
        'language': mySingleton.getLangue.toString(),
        'cnifile': _cnifile,
        'zones': meszones,
        'hopital': _hospit,
        'signature': _signature,
        'vacation': vac.toString(),
        'image': _profil
      };

      print("tosend : " + data.toString());

      var res = await http.post(Uri.parse(Setting.apiracine + "comptes"),
          body: data,
          headers: {"Language": mySingleton.getLangue.toString(),});

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
    }
  }

  bool isVideo = false;
  String? _retrieveDataError;

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController hopitalController = TextEditingController();
  final TextEditingController heureController = TextEditingController();

  List<String> hopital = [];
  var _listHopital = <Widget>[];

  Future<File>? imageFile;
  Future<File>? imageFile1;
  Future<File>? imageFile2;
  PickedFile? _imageFile;
  PickedFile? _imageFile1;
  PickedFile? _imageFile2;
  File? _image;
  File? tmpFile;
  File? _image1;
  File? tmpFile1;
  File? _image2;
  File? tmpFile2;
  final ImagePicker _picker = ImagePicker();
  final ImagePicker _picker1 = ImagePicker();
  final ImagePicker _picker2 = ImagePicker();
  dynamic _pickImageError;
  Future<List<MyItems>>? special;
  List<MyItems> vacation = [];
  
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
      ;
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

  void _removeHopital(int pos) {
    setState(() {
      _listHopital = List.from(_listHopital)..removeAt(pos);

      hopital = List.from(hopital)..removeAt(pos);
    });
  }

  _addHopital() {
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
                            "NOUVEAU LIEU",
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
                          height: 360.0,
                          width: 300.0, // Change as per your requirement
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    allTranslations.text('workplace1') + " *"),
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
                                      controller: hopitalController,
                                      keyboardType: TextInputType.text),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    allTranslations.text('workplace2') + " *"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  height: 100,
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
                                      controller: heureController,
                                      keyboardType: TextInputType.text),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: new Center(
                                    child: new InkWell(
                                      onTap: () {
                                        if (hopitalController.text
                                                .toString()
                                                .isEmpty ||
                                            heureController.text
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
                                          String json = '{"nom":"' +
                                              hopitalController.text
                                                  .toString() +
                                              '","heure":"' +
                                              heureController.text.toString() +
                                              '"}';

                                          hopital.add(json);

                                          int pos = hopital.length - 1;

                                          _listHopital.add(Column(children: [
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
                                                              hopitalController
                                                                      .text
                                                                      .toString() +
                                                                  ", " +
                                                                  heureController
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
                                                          _removeHopital(pos);
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
                                            hopitalController.text = "";
                                            heureController.text = "";
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
                                            'AJOUTER',
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

  Widget buildView() {
    var taille = images == null ? 0 : images.length;

    print("images : " + images.toString());

    return Center(child: Text(taille.toString() + " image(s) chosen"));
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

  bool isVisible = true;
  bool isVisible1 = true;
  bool isVisible2 = true;

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

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
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
                            allTranslations.text('photo1_title'),
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
                            allTranslations.text('photo1_title'),
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
                            allTranslations.text('photo1_title'),
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

  void initState() {
    vacation.add(MyItems.fromJson({"id":1,"libelle":"Oui"}));
    vacation.add(MyItems.fromJson({"id":2,"libelle":"Non"}));
    super.initState();
    civi = getElements("2");
    special = getElements("7");
    _listZone = getZone("CM");
  }

  Future<List<MyItems>>? civi;
  String payslocalisation = "CM";
  String codepays = "";

  void _handleRadioValueCiv(MyItems? value) {
    setState(() {
      civilite = value;
    });
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
    _ordreController.dispose();
    _cniController.dispose();
    _datedelivController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    List<DropdownMenuItem<MyItems>> items1 = [];
    for (int i = 0; i < vacation.length; i++) {
                            items1.add(
                              DropdownMenuItem(
                                  child: Text(vacation[i].libelle),
                                  value: vacation[i]),
                            );
                      }

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
                          labelText:
                              allTranslations.text('prenom_title') + " *",
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
                      labelText: allTranslations.text('phone1_title') + " *",
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
                        //_listZone = getZone(payslocalisation);
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: allTranslations.text('phone2_title'),
                      labelStyle: TextStyle(
                          color: Colors.grey,
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
                        _phone2Controller.text =
                            phone.completeNumber.toString();
                        payslocalisation = phone.countryISOCode.toString();
                        codepays = phone.countryCode.toString();
                        //_listZone = getZone(payslocalisation);
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
                          labelText: allTranslations.text('email_title') + " *",
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
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                    ),
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.transparent,
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
                                    allTranslations.text('datnaiss_title'),
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
                ]),
            SizedBox(
              height: 0.0,
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
                    labelText: allTranslations.text('cni_title') + " *",
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
                                initialDate: _dateTime1 == null
                                    ? DateTime.now()
                                    : _dateTime1!,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050))
                            .then((date) {
                          setState(() {
                            if(date != null) {

                            _dateTime1 = date;
                            String vj = "";
                            String vm = "";
                            var date1 = DateTime.parse(_dateTime1.toString());
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
                            var formattedDate = "${date1.year}-${vm}-${vj}";
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
                          border:
                              new Border.all(color: Colors.white, width: 2.0),
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
                            Icons.calendar_today,
                            color: color,
                          ),
                          labelText:
                              allTranslations.text('datedeliv_title') + " *",
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
            /* */
            SizedBox(height: 20),
            Center(
              child: new Text(
                allTranslations.text('para2_title'),
                textAlign: TextAlign.left,
                style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: color),
              ),
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 8.0, top: 8.0, bottom: 15.0),
                    child: Center(
                      child: Text(
                        allTranslations.text('specialite_title') + " *",
                        style: TextStyle(
                            color: color2,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: FutureBuilder<List<MyItems>>(
                      future: special,
                      builder: (context, snapshot) {
                        print(snapshot.toString());

                        if (snapshot.hasError) {
                          return new Container();
                        } else if (snapshot.hasData) {
                          //  if (ville == null) ville = snapshot.data.elementAt(0);

                          List<DropdownMenuItem<MyItems>> items = [];

                          for (int i = 0; i < snapshot.data!.length; i++) {
                            items.add(
                              DropdownMenuItem(
                                  child: Text(snapshot.data![i].libelle),
                                  value: snapshot.data![i]),
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
                                      value: specialite,
                                      items: items,
                                      onChanged: (value) {
                                        setState(() {
                                          specialite = value;
                                        });
                                      })));
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
                Divider(
                  height: 15.0,
                  color: Colors.transparent,
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
                          Icons.card_membership,
                          color: color,
                        ),
                        labelText: allTranslations.text('ordre_title1'),
                        labelStyle: TextStyle(
                            color: color,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      keyboardType: TextInputType.text,
                      controller: _ordreController,
                    ),
                  ),
                ),
                Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
              ],
            ),
            new Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 8.0, bottom: 10.0),
              child: Center(
                  child: Text(
                allTranslations.text("z33"),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                      allTranslations.text("z81"),
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
new Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 8.0, bottom: 10.0),
              child: Center(
                  child: Text(
                allTranslations.text("z82"),
                style: TextStyle(
                    color: color2, fontWeight: FontWeight.bold, fontSize: 16.0),
                textAlign: TextAlign.left,
              )),
            ),
                (!is_image)
                ? GestureDetector(
                    onTap: loadAssets3,
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
            (is_image)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildGridView2(),
                  )
                : Container(),
            (is_image)
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          is_image = false;
                          l_images2.clear();
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
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 8.0, top: 8.0, bottom: 15.0),
                    child: Center(
                      child: Text(allTranslations.text("z34"),
                        style: TextStyle(
                            color: color2,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
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
                                      value: vaca,
                                      items: items1,
                                      onChanged: (value) {
                                        setState(() {
                                          vaca = value;
                                        });
                                      }))),
                ),
                Divider(
                  height: 15.0,
                  color: Colors.transparent,
                ),
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
           GestureDetector(
              child: Center(
                  child: Text(allTranslations.text('cond_title'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: color2))),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) =>
                        UserCondition()));
              },
            ),
             SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey,
                child: Signature(
                  color: Colors.black,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                  },
                  //backgroundPainter: MyCustomPainter2(this._image3),
                  strokeWidth: 5.0,
                )),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new InkWell(
                  onTap: () async {
                    //ui.Image image = _signaturePadKey.currentState.clear();
                    //_signaturePadKey.currentState.clear();
                    final sign = _sign.currentState;
                    sign!.clear();
                    setState(() {
                      _img = ByteData(0);
                      signatures = "";
                    });
                    debugPrint("cleared");
                  },
                  child: new Container(
                    width: 120.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      border: new Border.all(color: Colors.white, width: 2.0),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: new Center(
                      child: new Text(
                        allTranslations.text("z117"),
                        style: new TextStyle(
                            fontFamily: 'Candara',
                            fontSize: 14.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
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
                              fontSize: 16.0, color: Colors.white),
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
