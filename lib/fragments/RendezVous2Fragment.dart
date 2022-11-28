import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Meeting.dart';
import 'package:healthys_medecin/pages/RdvPage.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RendezVous2Fragment extends StatefulWidget {
  RendezVous2Fragment();

  @override
  RendezVousFragmentState createState() => new RendezVousFragmentState();
}

class RendezVousFragmentState extends State<RendezVous2Fragment>
    with SingleTickerProviderStateMixin {
  RendezVousFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";
  String currentnom = "";
  String currentphoto = "";
  TabController? _controller;

  Future<List<Meeting>>? meetings;
  Future<List<Meeting>>? meetings1;
  Future<List<Meeting>>? meetings2;
  List<Meeting> _searchResult = [];
  TextEditingController controller = new TextEditingController();

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      currentnom = (prefs.getString('currentnom') ?? '');
      currentphoto = (prefs.getString('currentphoto') ?? '');
      currentpatient = (prefs.getString('currentpatient') ?? '');
      token = (prefs.getString('token') ?? '');
    });
  }

  List<int> data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;
  bool _isSaving = true;

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

  void initState() {
    super.initState();
    _loadUser();
    print("photo : " + currentphoto.toString());
    _controller = new TabController(length: 2, vsync: this);

    meetings = getMeeting();
  }

  _setConfirm(String pos) async {
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
    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Setting.apiracine + "meetings/confirm?id=" + pos.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA4 :" + pos.toString());

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

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
        new MaterialPageRoute(builder: (_) => new RdvPage()),
      );
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

  _setCancel(String pos) async {
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
    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    var response = await http.get(
        Setting.apiracine + "meetings/rejet?id=" + pos.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA4 :" + pos.toString());

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

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
        new MaterialPageRoute(builder: (_) => new RdvPage()),
      );
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

  List<Widget> MeetingItem(List<Meeting> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = <Widget>[];

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Meeting item = maliste[i];

        var listItem = new GestureDetector(
          onTap: () {
            if (item.statut == "A venir") {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('FAIRE UN CHOIX'),
                      content: setupAlertDialoadContainer(item),
                    );
                  });
            }
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.0),
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.black54),
            ),
            width: double.infinity,
            margin: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date : " + item.datemeeting,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: color)),
                Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),
                Text(item.patientname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: color2)),
                          Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),
                 Text("Matricule : " + item.patientmatricule,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black)),
                Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
                Text("Médécin : " + item.docname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black)),
                Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
                Text("Statut : " + item.statut,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: color2)),
                Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
                Text(item.symptome,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: Colors.black)),
                Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
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

  Widget setupAlertDialoadContainer(Meeting id) {
    Widget maliste = ListView(
      children: ListTile.divideTiles(context: context, tiles: [
        ListTile(
          //leading: Icon(Icons.insert_drive_file),
          title: Text("Marquer comme terminé"),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            _setConfirm(id.id.toString());
          },
        ),
        ListTile(
          //leading: Icon(Icons.insert_drive_file),
          title: Text("Annuler "),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            _setCancel(id.id.toString());
          },
        ),
      ]).toList(),
    );

    return Container(
        height: 100.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: maliste);
  }

  Future<List<Meeting>> getMeeting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String role = (prefs.getString('role') ?? '');
    String profil = (prefs.getString('currentpatient') ?? '');
    String id = (prefs.getString('currentid') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    List<Meeting> liste = [];

    print("DATA4 :" + role + " - " + id);

    var response = await http.get(
        Setting.apiracine + "meetings?role=" + role + "&hopital=" + id + "",
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA4 :" + response.body.toString());

   
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        Meeting m = Meeting.fromJson(responseJson[i]);

        liste.add(m);
      }

      return liste;
   
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    final color = const Color(0xFFcd005f);
    final color2 = const Color(0xFF008dad);

    // TODO: implement build
    return Scaffold(
      body: FutureBuilder<List<Meeting>>(
          future: meetings, //new
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                        if (userDetail.docname
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            userDetail.hopital
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            userDetail.datemeeting
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            userDetail.statut
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            userDetail.symptome
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
                                      hintText:
                                          allTranslations.text('titre3_title'),
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
                                      // This next line does the trick.
                                      scrollDirection: Axis.vertical,
                                      children: MeetingItem(
                                        _searchResult,
                                        context,
                                      ),
                                    ))
                                : new LazyLoadScrollView(
                                    isLoading: isLoading,
                                    onEndOfPage: () => _loadMore(),
                                    child: ListView(
                                      // This next line does the trick.
                                      scrollDirection: Axis.vertical,
                                      children: MeetingItem(
                                        snapshot.data!.cast<Meeting>(),
                                        context,
                                      ),
                                    ))),
                      ],
                    );
                  }
                }
            }

           
          }),
    );
  }
}
