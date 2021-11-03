import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:healthys_medecin/models/Partenaire.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AssurancesFragment extends StatefulWidget {
  AssurancesFragment();

  @override
  AssurancesFragmentState createState() => new AssurancesFragmentState();
}

class AssurancesFragmentState extends State<AssurancesFragment> {
  AssurancesFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";
  String currentnom = "";
  String currentphoto = "";
  TabController _controller;

  Future<List<Partenaire>> datas;
  List<Partenaire> _searchResult = [];
  TextEditingController controller = new TextEditingController();

  List<int> data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;

  void initState() {
    super.initState();
    datas = getPartenaire();
  }

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

  List<Widget> PartenaireItem(List<Partenaire> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = new List<Widget>();

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Partenaire item = maliste[i];

        var listItem = new GestureDetector(
          onTap: () {
            /* Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new NewDetailPage(item)),
            );*/
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
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(item.nom.toUpperCase(),
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
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              Setting.serveurimage + '' + item.logo),
                        ),
                        flex: 1,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                allTranslations.text('phone_title') +
                                    " : " +
                                    item.contact,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                                allTranslations.text('email_title') +
                                    " : " +
                                    item.email,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                                allTranslations.text('pays_title1') +
                                    " : " +
                                    item.paysnom +
                                    " (" +
                                    item.ville +
                                    ")",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: Colors.black)),
                          ],
                        ),
                        flex: 3,
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 5.0,
                  color: Colors.transparent,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(item.description,
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

    return listElementWidgetList;
  }

  Future<List<Partenaire>> getPartenaire() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1;
    List<Partenaire> liste = List();

    Locale myLocale = Localizations.localeOf(context);

    var response =
        await http.get(Setting.apiracine + "partners?types=3", headers: {
      "Authorization": basicAuth,
      "Language": allTranslations.currentLanguage.toString()
    });

    print("DATA4 :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Partenaire.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return FutureBuilder<List<Partenaire>>(
        future: datas, //new
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

                    snapshot.data.forEach((userDetail) {
                      if (userDetail.nom
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.contact
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.email
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.ville
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.paysnom
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
                                  children:
                                      PartenaireItem(_searchResult, context),
                                ))
                            : new LazyLoadScrollView(
                                isLoading: isLoading,
                                onEndOfPage: () => _loadMore(),
                                child: ListView(
                                  // This next line does the trick.
                                  scrollDirection: Axis.vertical,
                                  children:
                                      PartenaireItem(snapshot.data, context),
                                )),
                      )
                    ],
                  );
                }
              }

              return Text('Result1: ${snapshot.data}');
            // You can reach your snapshot.data['url'] in here
          }

          return null;
        });
  }
}
