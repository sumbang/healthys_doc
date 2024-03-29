import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserCondition1 extends StatefulWidget {
  UserCondition1();

  @override
  UserCondition11 createState() => UserCondition11();
}

class UserCondition11 extends State<UserCondition1> {
  UserCondition11();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isChecked = true;
  bool _isSaving = true;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  void _submitForms() async {}

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    String langue = mySingleton.getLangue.toString();

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.black.withOpacity(1.0),
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  child: Builder(builder: (BuildContext context) {
                    return WebView(
                      initialUrl: Setting.serveurracine + "site/condition?lang="+langue,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                      onPageStarted: (String url) {
                        print('Page started loading: $url');
                      },
                      onPageFinished: (String url) {
                        print('Page finished loading: $url');
                      },
                      gestureNavigationEnabled: false,
                    );
                  }),
                ),
                Positioned(
                    top: 50,
                    left: 20,
                    //height: 75,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.grey,
                        child: new IconButton(
                          icon: new Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ))),
              ],
            )));
  }
}
