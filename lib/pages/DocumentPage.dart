import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Document.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/Consultation2.dart';
import 'Consultation3.dart';
import 'Consultation6.dart';
import 'HomePage.dart';

class DocumentPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
      home: new DocumentPage_2(),
    );
  }
}

class DocumentPage_2 extends StatefulWidget {
  DocumentPage_2();

  @override
  DocumentPageState createState() => new DocumentPageState();
}

class DocumentPageState extends State<DocumentPage_2> {
  DocumentPageState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  Uint8List bytes = Uint8List(0);

  List<int> data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;
  Future<List<Document>>? documents;
  List<Document> _searchResult = [];
  TextEditingController controller = new TextEditingController();

  Future _loadMore() async {
    setState(() {
      isLoading = true;
    });

    // Add in an artificial delay
    await new Future.delayed(const Duration(seconds: 2));
    for (var i = currentLength; i <= currentLength + increment; i++) {
      data.add(i);
    }
    setState(() {
      isLoading = false;
      currentLength = data.length;
    });
  }

  _launchURL(String file) async {
    String url = Setting.serveurpdf + file;

    print("lien : " + url);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool _isSaving = true;

  Future<List<Document>> getDocs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String role = (prefs.getString('role') ?? '');
    String user = (prefs.getString('currentid') ?? '');
    String profil = (prefs.getString('currentpatient') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    List<Document> liste = [];

    var response =
        await http.get(Uri.parse(Setting.apiracine + "consultation/document"), headers: {
      "Authorization": basicAuth,
      "Language": mySingleton.getLangue.toString(),
    });

    print("DATA4 :" + role + " - " + profil + " - " + user);
    print("DATA4 :" + response.body.toString());


      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Document.fromJson(responseJson[i]));
      }

      return liste;
   
  }

  List<Widget> DocumentItem(List<Document> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = <Widget>[];

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Document item = maliste[i];

        List<Widget> actions = <Widget>[];

        var listItem = new Container(
          padding: new EdgeInsets.all(0.0),
          child: new GestureDetector(
            onTap: () {
              _launchURL(item.fichier);
            },
            child: Card(
                elevation: 2,
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Patient : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                                child: Text(item.patient,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black))),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Nature : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                                child: Text(item.titre,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black))),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Date de création : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                                child: Text(item.datecreation,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black))),
                          ],
                        ),
                      ],
                    ))),
          ),
          margin: const EdgeInsets.only(
              left: 0.0, right: 0.0, bottom: 5.0, top: 5.0),
        );

        listElementWidgetList.add(listItem);
      }
    }

    if (listElementWidgetList.length == 0) {
      var item = new Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Center(
                child: new Image.asset(
              'img/vide.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              width: 200.0,
            )),
            SizedBox(
              height: 8,
            ),
            Padding(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                child: Text(
                  allTranslations.text('empty'),
                  style: TextStyle(fontSize: 16.0),
                )),
          ],
        ),
      );

      listElementWidgetList.add(item);
    }

    return listElementWidgetList;
  }

  void initState() {
    super.initState();
    documents = getDocs();
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: Text("MES DOCUMENTS"),
                backgroundColor: color,
                elevation: 0,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (_) => new HomePage()),
                    );
                  },
                ),
              ),
              body: new FutureBuilder<List<Document>>(
                  future: documents, //new
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return new Container(
                          child: new Center(
                            child: new CircularProgressIndicator(),
                          ),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
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
                          } else {
                            onSearchTextChanged(String text) async {
                              _searchResult.clear();
                              if (text.isEmpty) {
                                setState(() {});
                                return;
                              }

                              snapshot.data!.forEach((userDetail) {
                                if (userDetail.patient
                                        .toString()
                                        .toLowerCase()
                                        .contains(text.toLowerCase()) ||
                                    userDetail.titre
                                        .toString()
                                        .toLowerCase()
                                        .contains(text.toLowerCase()))
                                  _searchResult.add(userDetail);
                              });

                              setState(() {});
                            }

                            return new Column(
                              children: <Widget>[
                                new Container(
                                  color: color,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Card(
                                      child: new ListTile(
                                        leading: new Icon(Icons.search),
                                        title: new TextField(
                                          controller: controller,
                                          decoration: new InputDecoration(
                                              hintText: allTranslations
                                                  .text('titre3_title'),
                                              border: InputBorder.none),
                                          onChanged: onSearchTextChanged,
                                        ),
                                        trailing: new IconButton(
                                          icon: new Icon(Icons.cancel),
                                          onPressed: () {
                                            controller.clear();
                                            onSearchTextChanged('');
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                new Expanded(
                                  child: _searchResult.length != 0 ||
                                          controller.text.isNotEmpty
                                      ? new LazyLoadScrollView(
                                          isLoading: isLoading,
                                          onEndOfPage: () => _loadMore(),
                                          child: ListView(
                                            scrollDirection: Axis.vertical,
                                            children: DocumentItem(
                                                _searchResult, context),
                                          ))
                                      : new LazyLoadScrollView(
                                          isLoading: isLoading,
                                          onEndOfPage: () => _loadMore(),
                                          child: ListView(
                                            scrollDirection: Axis.vertical,
                                            children: DocumentItem(
                                                snapshot.data!.cast<Document>(), context),
                                          )),
                                ),
                              ],
                            );
                          }
                        }

                        return Text('Result1: ${snapshot.data}');
                      // You can reach your snapshot.data['url'] in here
                    }

                  
                  })),
        ));
  }
}
