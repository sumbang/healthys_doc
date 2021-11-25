import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/Meeting.dart';
import 'package:healthys_medecin/pages/ViewRdvPage1.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RendezVousFragment extends StatefulWidget {
  RendezVousFragment();

  @override
  RendezVousFragmentState createState() => new RendezVousFragmentState();
}

class RendezVousFragmentState extends State<RendezVousFragment>
    with SingleTickerProviderStateMixin {
  RendezVousFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";
  String currentnom = "";
  String currentphoto = "";
  TabController _controller;

  Future<List<Meeting>> meetings;
  Future<List<Meeting>> meetings1;
  Future<List<Meeting>> meetings2;

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

    meetings = getMeeting(0);
    meetings1 = getMeeting(1);
    meetings2 = getMeeting(2);
  }

  Widget setupAlertDialoadContainer2(Meeting id) {
    Widget maliste = ListView(
      children: ListTile.divideTiles(context: context, tiles: [
        ListTile(
          //leading: Icon(Icons.insert_drive_file),
          title: Text(allTranslations.text('c6')),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new ViewRdvPage1(id)),
            );
          },
        ),
      ]).toList(),
    );

    return Container(
        height: 50.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: maliste);
  }

  Widget setupAlertDialoadContainer(Meeting id) {
    Widget maliste = ListView(
      children: ListTile.divideTiles(context: context, tiles: [
        ListTile(
          //leading: Icon(Icons.payment),
          title: Text(allTranslations.text('c6')),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new ViewRdvPage1(id)),
            );
          },
        ),
        ListTile(
          //leading: Icon(Icons.insert_drive_file),
          title: Text(allTranslations.text('c7')),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
      ]).toList(),
    );

    return Container(
        height: 100.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: maliste);
  }

  List<Widget> MeetingItem(List<Meeting> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = new List<Widget>();

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Meeting item = maliste[i];

        var listItem = new GestureDetector(
          onTap: () {
            if (item.statut == 1 || item.statut == 2) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('FAIRE UN CHOIX'),
                      content: setupAlertDialoadContainer2(item),
                    );
                  });
            } else {
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
                Text(item.docname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: color2)),
                Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
                Text(item.specialite,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black)),
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

    return listElementWidgetList;
  }

  Future<List<Meeting>> getMeeting(int statut) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String role = (prefs.getString('role') ?? '');
    String profil = (prefs.getString('currentpatient') ?? '');

    String basicAuth = 'Bearer ' + token1;

    List<Meeting> liste = List();

    Locale myLocale = Localizations.localeOf(context);

    var response = await http.get(
        Setting.apiracine + "meetings?role=" + role + "&profil=" + profil + "",
        headers: {
          "Authorization": basicAuth,
          "Language": allTranslations.currentLanguage.toString()
        });

    print("DATA4 :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        Meeting m = Meeting.fromJson(responseJson[i]);

        if (m.statut == statut) liste.add(m);
      }

      return liste;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    final color = const Color(0xFFcd005f);
    final color2 = const Color(0xFF008dad);

    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 60.0,
          bottom: TabBar(
            indicatorColor: color,
            labelColor: Colors.black,
            unselectedLabelColor: color,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                text: allTranslations.text('c2'),
              ),
              Tab(
                text: allTranslations.text('c1'),
              ),
              Tab(
                text: allTranslations.text('c5'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            new FutureBuilder<List<Meeting>>(
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
                          return new Column(
                            children: <Widget>[
                              new Expanded(
                                child: new LazyLoadScrollView(
                                    isLoading: isLoading,
                                    onEndOfPage: () => _loadMore(),
                                    child: ListView(
                                      // This next line does the trick.
                                      scrollDirection: Axis.vertical,
                                      children:
                                          MeetingItem(snapshot.data, context),
                                    )),
                              ),
                            ],
                          );
                        }
                      }
                  }

                  return null;
                }),
            new FutureBuilder<List<Meeting>>(
                future: meetings1, //new
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
                          return new Column(
                            children: <Widget>[
                              new Expanded(
                                child: new LazyLoadScrollView(
                                    isLoading: isLoading,
                                    onEndOfPage: () => _loadMore(),
                                    child: ListView(
                                      // This next line does the trick.
                                      scrollDirection: Axis.vertical,
                                      children:
                                          MeetingItem(snapshot.data, context),
                                    )),
                              ),
                            ],
                          );
                        }
                      }
                  }

                  return null;
                }),
            new FutureBuilder<List<Meeting>>(
                future: meetings2, //new
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
                          return new Column(
                            children: <Widget>[
                              new Expanded(
                                child: new LazyLoadScrollView(
                                    isLoading: isLoading,
                                    onEndOfPage: () => _loadMore(),
                                    child: ListView(
                                      // This next line does the trick.
                                      scrollDirection: Axis.vertical,
                                      children:
                                          MeetingItem(snapshot.data, context),
                                    )),
                              ),
                            ],
                          );
                        }
                      }
                  }

                  return null;
                }),
          ],
        ),
      ),
    );
  }
}
