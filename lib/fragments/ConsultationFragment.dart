import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:healthys_medecin/models/Consultation.dart';
import 'package:healthys_medecin/pages/Consultation31.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConsultationFragment extends StatefulWidget {
  ConsultationFragment();

  @override
  ConsultationFragmentState createState() => new ConsultationFragmentState();
}

class ConsultationFragmentState extends State<ConsultationFragment> {
  ConsultationFragmentState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  String currentpatient = "";
  String token = "";

  void initState() {
    super.initState();
    consultations = getConsultation(1);
    consultations2 = getConsultation(2);
  }

  Uint8List bytes = Uint8List(0);

  List<int> data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;
  Future<List<Consultation>>? consultations;
  Future<List<Consultation>>? consultations2;
  List<Consultation> _searchResult = [];
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

  Future<List<Consultation>> getConsultation(int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String role = (prefs.getString('role') ?? '');
    String user = (prefs.getString('currentid') ?? '');
    String profil = (prefs.getString('currentnumero') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    List<Consultation> liste = [];

    var response = await http.get(
        Setting.apiracine +
            "consultations?role=" +
            role +
            "&p=" +
            profil +
            "&user=" +
            user +
            "&type=" +
            type.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA4 :" + role + " - " + profil + " - " + user);
    print("DATA4 :" + response.body.toString());

  
      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Consultation.fromJson(responseJson[i]));
      }

      return liste;
   
  }

  List<Widget> ConsultationItem(
      List<Consultation> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = <Widget>[];

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Consultation item = maliste[i];

        List<Widget> actions = <Widget>[];

        var listItem = new Container(
          padding: new EdgeInsets.all(0.0),
          child: new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (_) => new Consultation32(item.id.toString())),
              );
            },
            child: Card(
                elevation: 2,
                child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                              Setting.serveurimage + '' + item.photo),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    allTranslations.text('titre6_title') +
                                        " : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(item.dateconsultation,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    allTranslations.text('titre5_title') +
                                        " : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                    child: Text(item.motif,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16.0,
                                            color: Colors.black)))
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    allTranslations.text('titre7_title') +
                                        " : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(item.medecin,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    allTranslations.text('titre8_title') +
                                        " : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(item.phone,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    allTranslations.text('titre9_title') +
                                        " : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(item.specialite,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    allTranslations.text('titre10_title') +
                                        " : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(item.lieu,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ))
                      ],
                    ))),
          ),
          margin: const EdgeInsets.only(
              left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
        );

        listElementWidgetList.add(listItem);
      }
    }

    return listElementWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    return new Scaffold(
      body: new FutureBuilder<List<Consultation>>(
          future: consultations, //new
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
                        if (userDetail.dateconsultation
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            userDetail.infirmiere
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            userDetail.patient
                                .toString()
                                .toLowerCase()
                                .contains(text.toLowerCase()) ||
                            userDetail.motif
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
                                    children: ConsultationItem(
                                        _searchResult, context),
                                  ))
                              : new LazyLoadScrollView(
                                  isLoading: isLoading,
                                  onEndOfPage: () => _loadMore(),
                                  child: ListView(
                                    // This next line does the trick.
                                    scrollDirection: Axis.vertical,
                                    children: ConsultationItem(
                                        snapshot.data!.cast<Consultation>(), context),
                                  )),
                        )
                      ],
                    );
                  }
                }

                return Text('Result1: ${snapshot.data}');
              // You can reach your snapshot.data['url'] in here
            }

          
          }),
    );
  }
}
