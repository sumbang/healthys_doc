import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/Programme.dart';
import 'package:healthys_medecin/models/Vaccin.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VaccinationFragment extends StatefulWidget {
  VaccinationFragment();

  @override
  VaccinationFragmentState createState() => new VaccinationFragmentState();
}

class VaccinationFragmentState extends State<VaccinationFragment>
    with SingleTickerProviderStateMixin {
  VaccinationFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";
  String currentnom = "";
  String currentphoto = "";
  TabController _controller;

  Future<List<Vaccin>> vaccins;
  Future<List<Programme>> programmes;

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

    vaccins = getVaccin("0");
    programmes = getProgamme();
  }

  List<Widget> VaccinItem(List<Vaccin> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = new List<Widget>();

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Vaccin item = maliste[i];

        var listItem = new GestureDetector(
          onTap: () {
            /* showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('FAIRE UN CHOIX'),
                    content: setupAlertDialoadContainer(),
                  );
                });*/
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
                Padding(
                    padding: EdgeInsets.only(left: 0.0, top: 2.0, bottom: 2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("img/date.png",
                            fit: BoxFit.cover,
                            width: 15.0,
                            alignment: Alignment.centerLeft),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("Date " + item.date,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                                color: color)),
                      ],
                    )),
                Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),
                Text(item.nom,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: color2)),
                Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
                Text(item.importance.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
                        color: Colors.black)),
                Divider(
                  height: 10.0,
                  color: Colors.transparent,
                ),
                Text("Patient : " + item.personne.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16.0,
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

  List<Widget> ProgrammeItem(List<Programme> maliste) {
    List<Widget> listElementWidgetList = new List<Widget>();

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Programme item = maliste[i];

        var listItem = new GestureDetector(
          onTap: () {
            /* Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new NewDetailPage(item)),
            ); */
          },
          child: Container(
            padding: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey),
            ),
            width: double.infinity,
            margin: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(Setting.serveurimage + '' + item.image,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft),
                Divider(
                  height: 3.0,
                  color: Colors.transparent,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(item.titre,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: color2)),
                ),
                Divider(
                  height: 1.0,
                  color: Colors.transparent,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 2.0, bottom: 2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("img/date.png",
                            fit: BoxFit.cover,
                            width: 15.0,
                            alignment: Alignment.centerLeft),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("Publié le " + item.date,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                                color: color)),
                      ],
                    )),
                Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(item.description + " [...]",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          color: Colors.black)),
                ),
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

  Future<List<Vaccin>> getVaccin(String groupe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String id = (prefs.getString('currentid') ?? '');

    String basicAuth = 'Bearer ' + token1;

    List<Vaccin> liste = List();

    Locale myLocale = Localizations.localeOf(context);

    var response = await http
        .get(Setting.apiracine + "vaccins?groupe=2&id=" + id, headers: {
      "Authorization": basicAuth,
      "Language": allTranslations.currentLanguage.toString()
    });

    print("DATA4 :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Vaccin.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  Future<List<Programme>> getProgamme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String id = (prefs.getString('id') ?? '');

    String basicAuth = 'Bearer ' + token1;

    List<Programme> liste = List();

    Locale myLocale = Localizations.localeOf(context);

    var response =
        await http.get(Setting.apiracine + "vaccins/programme", headers: {
      "Authorization": basicAuth,
      "Language": allTranslations.currentLanguage.toString()
    });

    print("DATA4 :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Programme.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  Widget setupAlertDialoadContainer() {
    Widget maliste = ListView(
      children: ListTile.divideTiles(context: context, tiles: [
        ListTile(
          //leading: Icon(Icons.payment),
          title: Text('MODIFIER'),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
        ListTile(
          //leading: Icon(Icons.insert_drive_file),
          title: Text('SUPPRIMER'),
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');

            /* String codep = "";

               Navigator.push(
                 context,
                 new MaterialPageRoute(
                     builder: (_) => new FilmPaiement(id, 2, codep, 0)),
               ); */
          },
        ),
      ]).toList(),
    );

    return Container(
        height: 100.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: maliste);
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    // TODO: implement build
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      currentnom,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: SizedBox(
                    width: 30.0,
                  ),
                  flex: 0,
                ),
                /*Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (_) => new NewVaccinPage()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Image.asset("img/download.png",
                            width: 30.0,
                            fit: BoxFit.contain,
                            alignment: Alignment.centerLeft),
                      )),
                  flex: 0,
                ), */
              ],
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: new Container(
            decoration: new BoxDecoration(color: Colors.transparent),
            child: new TabBar(
              controller: _controller,
              indicatorColor: color2,
              labelColor: Colors.black,
              unselectedLabelColor: color,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  text: allTranslations.text('v7'),
                ),
                Tab(
                  text: allTranslations.text('v8'),
                ),
              ],
            ),
          ),
          flex: 1,
        ),
        Expanded(
          flex: 10,
          child: new Container(
            height: 630.0,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                new FutureBuilder<List<Vaccin>>(
                    future: vaccins, //new
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
                              return new Column(
                                children: <Widget>[
                                  new Expanded(
                                    child: new LazyLoadScrollView(
                                        isLoading: isLoading,
                                        onEndOfPage: () => _loadMore(),
                                        child: ListView(
                                          // This next line does the trick.
                                          scrollDirection: Axis.vertical,
                                          children: VaccinItem(
                                              snapshot.data, context),
                                        )),
                                  ),
                                ],
                              );
                            }
                          }
                      }

                      return null;
                    }),
                new FutureBuilder<List<Programme>>(
                    future: programmes, //new
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
                                              ProgrammeItem(snapshot.data),
                                        )),
                                  ),
                                ],
                              );
                            }
                          }

                          return Text('Result1: ${snapshot.data}');
                        // You can reach your snapshot.data['url'] in here
                      }

                      return null;
                    }),
              ],
            ),
          ),
        )
      ],
    );
  }
}
