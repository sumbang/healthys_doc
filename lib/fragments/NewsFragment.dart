import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/News.dart';
import 'package:healthys_medecin/pages/NewDetailPage.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewsFragment extends StatefulWidget {
  NewsFragment();

  @override
  NewsFragmentState createState() => new NewsFragmentState();
}

class NewsFragmentState extends State<NewsFragment> {
  NewsFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";
  String currentnom = "";
  String currentphoto = "";
  TabController _controller;

  Future<List<News>> news;
  List<News> _searchResult = [];
  TextEditingController controller = new TextEditingController();

  List<int> data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;

  void initState() {
    super.initState();
    news = getNews();
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

  List<Widget> NewsItem(List<News> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = new List<Widget>();

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        News item = maliste[i];

        var listItem = new GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (_) => new NewDetailPage(item)),
            );
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
                (item.image.isNotEmpty)
                    ? Image.network(Setting.serveurimage1 + '' + item.image,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft)
                    : Container(),
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

  Future<List<News>> getNews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();
    List<News> liste = List();

    var response = await http.get(Setting.apiracine + "news", headers: {
      "Authorization": basicAuth,
      "Language": mySingleton.getLangue.toString(),
    });

    print("DATA4 :" + response.body.toString());

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(News.fromJson(responseJson[i]));
      }

      return liste;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return FutureBuilder<List<News>>(
        future: news, //new
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
                      if (userDetail.titre
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.description
                              .toString()
                              .toLowerCase()
                              .contains(text.toLowerCase()) ||
                          userDetail.date
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
                                  children: NewsItem(_searchResult, context),
                                ))
                            : new LazyLoadScrollView(
                                isLoading: isLoading,
                                onEndOfPage: () => _loadMore(),
                                child: ListView(
                                  // This next line does the trick.
                                  scrollDirection: Axis.vertical,
                                  children: NewsItem(snapshot.data, context),
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
