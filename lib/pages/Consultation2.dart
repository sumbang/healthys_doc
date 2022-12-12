import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import '../models/Consultation2.dart';
import 'CertificatPage.dart';
import 'Consultation3.dart';
import 'Consultation5.dart';
import 'Consultation6.dart';
import 'HomePage.dart';
import 'HomePageNew.dart';

class Consultation2 extends StatelessWidget {
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
      home: new Consultation_2(),
    );
  }
}

class Consultation_2 extends StatefulWidget {
  Consultation_2();

  @override
  ConsultationPageState createState() => new ConsultationPageState();
}

class ConsultationPageState extends State<Consultation_2> {
  ConsultationPageState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  Uint8List bytes = Uint8List(0);

  List<int> data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;
  Future<List<Mconsultation2>>? consultations;
  Future<List<Mconsultation2>>? consultations2;
  List<Mconsultation2> _searchResult = [];
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

  bool _isSaving = true;

  void _buildRapport(int consultation) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          allTranslations.text('progress_title'),
                          style: TextStyle(
                              color: color2, fontWeight: FontWeight.bold),
                        ),
                      )),
                  flex: 8,
                ),
                Flexible(
                    child: Container(
                        margin: EdgeInsets.only(top: 0.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                            icon: Icon(
                              Icons.close,
                              color: color,
                            ),
                            iconSize: 30.0,
                          ),
                        )),
                    flex: 1),
              ],
            ),
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

    print("token : " + token1);

    var res = await http.get(
        Setting.apiracine +
            "consultation/rapport/?id=" +
            consultation.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA : " + res.body.toString());

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

  Future<List<Mconsultation2>> getConsultation(int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token1 = (prefs.getString('token') ?? '');
    String role = (prefs.getString('role') ?? '');
    String user = (prefs.getString('currentid') ?? '');
    String profil = (prefs.getString('currentpatient') ?? '');

    String basicAuth = 'Bearer ' + token1; MySingleton mySingleton = new MySingleton();

    List<Mconsultation2> liste = [];

    var response = await http.get(
        Setting.apiracine +
            "consultations?role=" +
            role +
            "&user=" +
            user +
            "&type=" +
            type.toString(),
        headers: {
          "Authorization": basicAuth,
          "Language": mySingleton.getLangue.toString(),
        });

    print("DATA4 :" +
        role +
        " - " +
        profil +
        " - " +
        user +
        " - " +
        type.toString());
    print("DATA4 :" + response.body.toString());


      final responseJson = json.decode(response.body.toString());

      for (int i = 0; i < responseJson.length; i++) {
        liste.add(Mconsultation2.fromJson(responseJson[i]));
      }

      return liste;
  
  }

  void _viewConsultation(Mconsultation2 item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Options"),
            content: setup1AlertDialoadContainer1(item),
          );
        });
  }

  Widget setup1AlertDialoadContainer1(Mconsultation2 item) {
    List<Widget> maliste = [];

    maliste.add(new ListTile(
      leading: Icon(Icons.file_download),
      title: Text(
        allTranslations.text("z111"),
        style: TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        _buildRapport(item.id);
      },
    )); 
    
    maliste.add(new ListTile(
      leading: Icon(Icons.remove_red_eye_outlined),
      title: Text(
        allTranslations.text("z53"),
        style: TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (_) => new Consultation5(item.id.toString())),
        );
      },
    ));

    maliste.add(new ListTile(
      leading: Icon(Icons.update),
      title: Text(
        allTranslations.text("z54"),
        style: TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (_) => new Consultation6(item.id.toString())),
        );
      },
    ));

    /* maliste.add(new ListTile(
      leading: Icon(Icons.person_pin),
      title: Text(
        "Génerer un certificat médical",
        style: TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (_) => new CertificatPage(item.id.toString())),
        );
      },
    ));*/



    return Container(
        // height: double.parse(largeur.toString()), // Change as per your requirement
        height: 200.0,
        width: 300.0, // Change as per your requirement
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: maliste,
        ));
  }

  List<Widget> ConsultationItem(
      List<Mconsultation2> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = <Widget>[];

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Mconsultation2 item = maliste[i];

        List<Widget> actions = <Widget>[];
        var truedate = "";

        if (item.dateconsultation != null) {
         /* var d = item.dateconsultation.toString().split("-");
          truedate =
              d[2].toString() + "-" + d[1].toString() + "-" + d[0].toString();*/
              truedate = item.dateconsultation.toString();
        }

        var listItem = new Container(
          padding: new EdgeInsets.all(0.0),
          child: new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (_) => new Consultation3(
                        item.id.toString(), item.numero.toString())),
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
                              Setting.serveurimage1 + '' + item.photo),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(item.patient,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: color2)),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(allTranslations.text("z50")+": ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(item.numero,
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
                                    allTranslations.text('titre6_title') +
                                        " : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(truedate,
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
                                Text(allTranslations.text("z51")+": ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                    item.infirmiere == null
                                        ? ""
                                        : item.infirmiere,
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
                                    child: Text(
                                        item.motif == null ? "" : item.motif,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16.0,
                                            color: Colors.black))),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ))
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

  List<Widget> ConsultationItem1(
      List<Mconsultation2> maliste, BuildContext context) {
    List<Widget> listElementWidgetList = <Widget>[];

    if (maliste != null) {
      var lengthOfList = maliste.length;

      for (int i = 0; i < lengthOfList; i++) {
        Mconsultation2 item = maliste[i];

        var truedate = "";

        if (item.dateconsultation != null) {
         /* var d = item.dateconsultation.toString().split("-");
          truedate =
              d[2].toString() + "-" + d[1].toString() + "-" + d[0].toString();*/
              truedate = item.dateconsultation.toString();
        }

        List<Widget> actions = <Widget>[];

        var listItem = new Container(
          padding: new EdgeInsets.all(0.0),
          child: new GestureDetector(
            onTap: () {
              _viewConsultation(item);
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
                              Setting.serveurimage1 + '' + item.photo),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(item.patient,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: color)),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(allTranslations.text("z50")+" : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(item.numero,
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
                                    allTranslations.text('titre6_title') +
                                        " : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(truedate,
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
                                Text(allTranslations.text("z51")+" : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                    item.infirmiere == null
                                        ? ""
                                        : item.infirmiere,
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
                                    child: Text(
                                        item.motif == null ? "" : item.motif,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16.0,
                                            color: Colors.black))),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ))
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
  
  String perso = "";
  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      perso = (prefs.getString('currentperso') ?? "");
    });
  }

  void initState() {
    _loadUser();
    super.initState();
    consultations = getConsultation(1);
    consultations2 = getConsultation(2);
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
                title: Text(
                    allTranslations.text('mconsultation2_title').toUpperCase()),
                backgroundColor: color,
                elevation: 0,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
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
                  },
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: new Image.asset(
                        "img/prise-rdv2.png",
                        height: 25.0,
                        color: Colors.white,
                      ),
                      text: allTranslations.text('titre_title'),
                    ),
                    Tab(
                      icon: new Image.asset(
                        "img/prise-rdv.png",
                        height: 25.0,
                        color: Colors.white,
                      ),
                      text: allTranslations.text('titre2_title'),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  new FutureBuilder<List<Mconsultation2>>(
                      future: consultations, //new
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
                                      child: new LazyLoadScrollView(
                                          isLoading: isLoading,
                                          onEndOfPage: () => _loadMore(),
                                          child: ListView(
                                            // This next line does the trick.
                                            scrollDirection: Axis.vertical,
                                            children: ConsultationItem(
                                                snapshot.data!.cast<Mconsultation2>(), context),
                                          )),
                                    ),
                                  ],
                                );
                              }
                            }

                            return Text('Result1: ${snapshot.data}');
                          // You can reach your snapshot.data['url'] in here
                        }

                      }),
                  new FutureBuilder<List<Mconsultation2>>(
                      future: consultations2, //new
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return new Container(
                              child: new Center(
                                  //  child: Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.blueGrey),
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
                                      child: new LazyLoadScrollView(
                                          isLoading: isLoading,
                                          onEndOfPage: () => _loadMore(),
                                          child: ListView(
                                            // This next line does the trick.
                                            scrollDirection: Axis.vertical,
                                            children: ConsultationItem1(
                                                snapshot.data!.cast<Mconsultation2>(), context),
                                          )),
                                    ),
                                  ],
                                );
                              }
                            }

                            return Text('Result1: ${snapshot.data}');
                          // You can reach your snapshot.data['url'] in here
                        }

                     
                      }),
                ],
              ),
            )));
  }
}
