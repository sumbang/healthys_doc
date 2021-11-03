import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AssuranceFragment extends StatelessWidget {
  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    // TODO: implement build
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: new Icon(
          Icons.folder,
          color: Colors.grey,
          size: 200.0,
        )),
        SizedBox(
          height: 10.0,
        ),
        Center(
            child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            allTranslations.text('emptyassurance'),
            style: TextStyle(
                fontSize: 18.0,
                height: 1.5,
                color: Colors.black,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        )),
        SizedBox(
          height: 10.0,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: new Center(
              child: new InkWell(
                onTap: () {},
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
                      allTranslations.text('addcontrat').toUpperCase(),
                      style: new TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),

        /* new Image.asset(myLocale.languageCode.toString() == "es"?'img/assurance.jpg':'img/assurance1.jpg',
            alignment: Alignment.topCenter,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("ASSUREUR :  ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blue)),
                  ),flex: 1,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("Axa Cameroun",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0, color: Colors.black)),
                  ),flex: 1,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("NUMERO DE POLICIE :  ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blue)),
                  ),flex: 1,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("364857570",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0, color: Colors.black)),
                  ),flex: 1,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("COUVERTURE :  ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blue)),
                  ),flex: 1,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("80%",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0, color: Colors.black)),
                  ),flex: 1,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("PLAFOND DISPONIBLE :  ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blue)),
                  ),flex: 1,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("250 000 F.CFA",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0, color: Colors.black)),
                  ),flex: 1,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("PRIME :  ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blue)),
                  ),flex: 1,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("40 000 F.CFA",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0, color: Colors.black)),
                  ),flex: 1,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("ECHEANCE CONTRAT :  ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.blue)),
                  ),flex: 1,
                ),
                new Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 5.0, bottom: 5.0),
                    child: Text("12/11/2020",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0, color: Colors.black)),
                  ),flex: 1,
                )
              ],
            ),
          ), */
      ],
    );
  }
}
