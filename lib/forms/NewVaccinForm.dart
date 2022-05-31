import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/config/image_compress_service.dart';
import 'package:healthys_medecin/models/MyItems.dart';
import 'package:healthys_medecin/pages/HomePageNew.dart';
import 'package:healthys_medecin/pages/VaccinPage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:fluttertoast/fluttertoast.dart';

class NewVaccinForm extends StatefulWidget {
  @override
  NewVaccinFormState createState() => NewVaccinFormState();
}

class NewVaccinFormState extends State<NewVaccinForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  final gris = const Color(0xFF373736);
  final bleu = const Color(0xFF194185);
  final bleu1 = const Color(0xFF006CA7);
  final bleu2 = const Color(0xFF222651);
  final bleu3 = const Color(0xFF3b5998);
  final clair = const Color(0xFFF9FAFB);

  final _nomController = TextEditingController();
  final _importanceController = TextEditingController();
  final _dateController = TextEditingController();
  final _periodeController = TextEditingController();
  final _priseController = TextEditingController();
  final _numeroController = TextEditingController();
  Future<List<MyItems>> period;
  Future<File> imageFile;
  PickedFile _imageFile;
  File _image;
  File tmpFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  bool is_image = false;
  List<Asset> l_images = List<Asset>();

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

  Future<List<File>> convertListAssetToListFile() async {
    List<File> files = List<File>();
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

  Future<void> loadAssets1() async {
    List<Asset> resultList = List<Asset>();

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
      if (resultList.length != 0) is_image = true;
    });
  }

  MyItems c_exist;

  DateTime _dateTime;
  int periode = -1;
  bool _isSaving = true;
  String perso = "";

     _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      perso = (prefs.getString('currentperso') ?? "");
    });
  }

  void initState() {
    requestPersmission();
    _loadUser();
    super.initState();
    period = getElements();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _nomController.dispose();
    _dateController.dispose();
    _importanceController.dispose();
    _periodeController.dispose();
    _priseController.dispose();
    super.dispose();
  }

  Widget _buildPeriode(List<MyItems> list) {
    List<Widget> mList = new List();

    for (int b = 0; b < list.length; b++) {
      MyItems cmap = list[b];

      mList.add(RadioListTile(
          value: cmap.id,
          groupValue: periode,
          title: Text(
            cmap.libelle.toString(),
            style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          onChanged: (newValue) => setState(() => periode = newValue),
          activeColor: color));
    }

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: mList,
    );
  }

  Future _scan() async {
   /* String barcode = await scanner.scan();

    _numeroController.text = barcode;*/
  }

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
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

  Future<List<MyItems>> getElements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;
    List<MyItems> liste = List();

    var response = await http.get(Setting.apiracine + "vaccins/item", headers: {
      "Authorization": basicAuth,
      "Language": allTranslations.currentLanguage.toString()
    });

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
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20.0),
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
            Divider(
              height: 20.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v2')+" *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  controller: _nomController,
                ),
              ),
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v3')+" *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                height: 100,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _importanceController,
                ),
              ),
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v4')+" *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: new Border.all(color: Colors.black38),
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal),
                            contentPadding: const EdgeInsets.all(15.0)),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: _dateController,
                      ),
                    ),
                  ),
                  flex: 2,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: new IconButton(
                      icon: new Icon(
                        Icons.calendar_today,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: _dateTime == null
                                    ? DateTime.now()
                                    : _dateTime,
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2030))
                            .then((date) {
                          setState(() {
                            _dateTime = date;
                            String vj = "";
                            String vm = "";
                            var date1 = DateTime.parse(_dateTime.toString());
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
                            _dateController.text = formattedDate;
                          });
                        });
                      },
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v5')+" *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: FutureBuilder<List<MyItems>>(
                  future: period,
                  builder: (context, snapshot) {
                    print(snapshot.toString());

                    if (snapshot.hasError) {
                      return new Container();
                    } else if (snapshot.hasData) {
                      return _buildPeriode(snapshot.data);
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text('v6')+" *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 8.0,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: new Border.all(color: Colors.black38),
                ),
                child: TextFormField(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.all(15.0)),
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  controller: _priseController,
                ),
              ),
            ),
            SizedBox(height: 20),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 8.0,
                                            top: 8.0,
                                            bottom: 10.0),
                                        child:  Text(
                                          allTranslations.text("z110").toUpperCase()+" *",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              
                                              fontSize: 18.0),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      (!is_image)
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
                                      (is_image)
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: buildGridView(),
                                            )
                                          : Container(),
                                      (is_image)
                                          ? Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    is_image = false;
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
                                          SizedBox(height: 20),
            Divider(
              height: 15.0,
              color: Colors.transparent,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: new Center(
                  child: new InkWell(
                    onTap: _sentData,
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
                          allTranslations.text('save1_title'),
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

  Future<void> _sentData() async {
    Locale myLocale = Localizations.localeOf(context);

    if (_nomController.text.isEmpty ||
        _importanceController.text.isEmpty ||
        _priseController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _numeroController.text.isEmpty ||
        (periode == -1)) {
      Fluttertoast.showToast(
          msg: allTranslations.text('requis1_title'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (l_images.length == 0) {
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

       String scan1 = "";
       
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');
      String id = (prefs.getString('currentid') ?? '');

      String basicAuth = 'Bearer ' + token1;

      Uri uri = Uri.parse(Setting.apiracine + "comptes/uploaders");

      if (l_images.length != 0 ) {
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
        request1.fields["types"] = "vac";
        var response1 = await request1.send();
        var res1 = await http.Response.fromStream(response1);
        print("photo1 : " + res1.body.toString());
        var responseCni = json.decode(res1.body.toString());
        scan1 = responseCni[0]["path"];
      }

      Map data = {
        "nom": _nomController.text.toString(),
        "importance": _importanceController.text.toString(),
        "date": _dateController.text.toString(),
        "periode": periode.toString(),
        "prise": _priseController.text.toString(),
        "profil": _numeroController.text.toString(),
        "id": id,
        "scan":scan1
      };

      var res =
          await http.post(Setting.apiracine + "vaccins", body: data, headers: {
        "Authorization": basicAuth,
        "Language": allTranslations.currentLanguage.toString()
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
}
