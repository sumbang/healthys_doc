import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/pages/DossierMedicalPage2.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Setting.dart';
import 'package:flutter/cupertino.dart';
import '../pages/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DossierForm extends StatefulWidget {
  String patient;

  DossierForm(this.patient);

  @override
  DossierFormState createState() => DossierFormState(this.patient);
}

class DossierFormState extends State<DossierForm> {
  String patient;
  DossierFormState(this.patient);

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isSaving = true;

  final _patientController = TextEditingController();
  final _dateController = TextEditingController();
  final _symptomeController = TextEditingController();
  final _heureController = TextEditingController();
  final _securityController = TextEditingController();
  DateTime? _dateTime;
  int hopital = -1;

  File? selectedfile;
  Response? response;
  String? progress;
  Dio dio = new Dio();

  void initState() {
    super.initState();
    _patientController.text = this.patient.toString();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _patientController.dispose();
    _dateController.dispose();
    _symptomeController.dispose();
    _heureController.dispose();
    super.dispose();
  }

  selectFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['jpg', 'pdf']);

    if (result != null) {
    selectedfile = File(result.files.single.path.toString());
    } else {
      // User canceled the picker
    }
    
   /* selectedfile = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf'],
      //allowed extension to choose
    ); */

    //for file_pocker plugin version 2 or 2+
    /*
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);
    } */

    setState(() {}); //update the UI so that file name is shown
  }

  Future<void> _sentData() async {
    MySingleton mySingleton = new MySingleton();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String _security = _securityController.text.toString();
    String currentpin = (prefs.getString('currentpin') ?? '');

    // print("hopital : " + hopital.toString());

    if ((_security != currentpin) || (_security.isEmpty)) {
      Fluttertoast.showToast(
          msg: allTranslations.text('s5'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } else if (_patientController.text.isEmpty ||
        _symptomeController.text.isEmpty ||
        _dateController.text.isEmpty ||
        (selectedfile == null)) {
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

      // start the modal progress HUD
      setState(() {
        _isSaving = false;
      });

      String token1 = (prefs.getString('token') ?? '');
      String currentpatient1 = (prefs.getString('currentpatient') ?? '');

      String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

      // uploads du fichier

      String base64Image = base64Encode(selectedfile!.readAsBytesSync());
      String fileName = selectedfile!.path.split('/').last;
      String ext = lookupMimeType(selectedfile!.path)!.split('/').last;

      Map data1 = {
        "image": base64Image,
        "name": ext,
      };

      var res1 =
          await http.post(Uri.parse(Setting.apiracine + "comptes/uploader1"), body: data1);

      if (res1.statusCode == 200) {
        var response1Json = json.decode(res1.body);

        Map data = {
          "patient": this.patient.toString(),
          "dateconsultation": _dateController.text.toString(),
          "description": _symptomeController.text.toString(),
          "fichier": response1Json['path'],
        };

        MySingleton mySingleton = new MySingleton();

        var res = await http
            .post(Uri.parse(Setting.apiracine + "comptes/dossier"), body: data, headers: {
          "Authorization": basicAuth,
          "Language":  mySingleton.getLangue.toString()
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
            new MaterialPageRoute(
                builder: (_) =>
                    new DossierMedicalPage2(this.patient.toString())),
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
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              allTranslations.text("z13") + " *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 3.0,
              color: Colors.transparent,
            ),
            TextFormField(
                obscureText: false,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                controller: _patientController,
                enabled: false,
                keyboardType: TextInputType.multiline),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text("z14") + " *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 3.0,
              color: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: TextFormField(
                      obscureText: false,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                      controller: _dateController,
                      keyboardType: TextInputType.text,
                      enabled: false,
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
                                    : _dateTime!,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now())
                            .then((date) {
                          setState(() {
                            if(date != null) {

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
                            }
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
              height: 15.0,
              color: Colors.transparent,
            ),
            new Text(
              allTranslations.text("z15") + " *",
              textAlign: TextAlign.left,
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  color: Colors.black),
            ),
            Divider(
              height: 3.0,
              color: Colors.transparent,
            ),
            TextFormField(
              obscureText: false,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal),
              controller: _symptomeController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            Container(
              margin: EdgeInsets.all(10),
              //show file name here
              child: selectedfile == null
                  ? Text("Choose File")
                  : Text(p.basename(selectedfile!.path)),
              //basename is from path package, to get filename from path
              //check if file is selected, if yes then show file name
            ),
            Divider(
              height: 10.0,
              color: Colors.transparent,
            ),
            Container(
                child: ElevatedButton.icon(
              onPressed: () {
                selectFile();
              },
              icon: Icon(Icons.folder_open),
              label: Text(allTranslations.text("z16")+" *"),
             // color: Colors.redAccent,
              //colorBrightness: Brightness.dark,
            )),
            Divider(
              height: 30.0,
              color: Colors.transparent,
            ),
            TextFormField(
              obscureText: false,
              controller: _securityController,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: new Icon(
                  Icons.security,
                  color: color,
                ),
                labelText: allTranslations.text('s2'),
                labelStyle: TextStyle(
                    color: color2,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return allTranslations.text('requis_title');
                }
              },
            ),
            Divider(
              height: 30.0,
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
}
