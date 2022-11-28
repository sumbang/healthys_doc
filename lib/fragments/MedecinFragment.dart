import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Medecin.dart';
import 'package:healthys_medecin/pages/DetailMedecin.dart';
import 'package:healthys_medecin/pages/NewRdvPage.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MedecinFragment extends StatefulWidget {
  MedecinFragment();

  @override
  MedecinFragmentState createState() => new MedecinFragmentState();
}

class MedecinFragmentState extends State<MedecinFragment> {
  MedecinFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";

  void initState() {
    super.initState();
    docteurs = getMedecin();
  }

  List<int> data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;
  Future<List<Medecin>>? docteurs;
  List<Medecin> _searchResult = [];
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

  List<Widget> MedecinItem(List<Medecin> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = <Widget>[];

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Medecin item = maliste[i];

        List<Widget> actions = <Widget>[];

        var listItem = new Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13.0),
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.grey),
            ),
            width: double.infinity,
            margin: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 120,
                        height: 120,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage(
                                  Setting.serveurimage + '' + item.photo,
                                )))),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.nom,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                  color: color2)),
                          Divider(height: 15.0, color: Colors.transparent),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.place,
                                  size: 20.0,
                                  color: color,
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(item.adresse,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                flex: 8,
                              ),
                            ],
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.local_hospital,
                                  size: 20.0,
                                  color: color,
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(item.specialite,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                flex: 8,
                              ),
                            ],
                          ),
                          Divider(
                            height: 5.0,
                            color: Colors.transparent,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.phone,
                                  size: 20.0,
                                  color: color,
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(item.phone,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                flex: 8,
                              ),
                            ],
                          ),
                        ],
                      ),
                      flex: 1,
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (_) => new DetailMedecin(item)),
                        );
                      },
                      child: new Container(
                        width: 180.0,
                        height: 50.0,
                        decoration: new BoxDecoration(
                          color: color2,
                          border:
                              new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: new Center(
                          child: new Text(
                            allTranslations.text('bt1_med'),
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (_) => new NewRdvPage(item)),
                        );
                      },
                      child: new Container(
                        width: 160.0,
                        height: 50.0,
                        decoration: new BoxDecoration(
                          color: color,
                          border:
                              new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: new Center(
                          child: new Text(
                            allTranslations.text('bt2_med'),
                            style: new TextStyle(
                                fontSize: 18.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));

        listElementWidgetList.add(listItem);
      }
    }

    return listElementWidgetList;
  }

  Future<List<Medecin>> getMedecin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String role = (prefs.getString('role') ?? '');
    String user = (prefs.getString('currentid') ?? '');
    String profil = (prefs.getString('currentnumero') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    List<Medecin> liste = [];

    var response = await http.get(
        Setting.apiracine +
            "comptes/docteur?language=" +
            mySingleton.getLangue.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA4 :" + response.body.toString());

  
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Medecin.fromJson(responseJson[i]));
      }

      return liste;
   
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return FutureBuilder<List<Medecin>>(
        future: docteurs, //new
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
                      if (userDetail.phone
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.nom
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.specialite
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.hopital
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
                        color: color2,
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
                                  children: MedecinItem(_searchResult, context),
                                ))
                            : new LazyLoadScrollView(
                                isLoading: isLoading,
                                onEndOfPage: () => _loadMore(),
                                child: ListView(
                                  // This next line does the trick.
                                  scrollDirection: Axis.vertical,
                                  children: MedecinItem(snapshot.data!.cast<Medecin>(), context),
                                )),
                      ),
                    ],
                  );
                }
              }
          }

        });
  }
}
