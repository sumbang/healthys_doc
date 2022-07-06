import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthys_medecin/config/Setting.dart';
import 'package:healthys_medecin/config/all_translations.dart'; import 'package:healthys_medecin/config/singleton.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfViewer extends StatefulWidget {
  String filename;
  PdfViewer(this.filename);

  @override
  PdfViewer1 createState() => PdfViewer1(this.filename);
}

class PdfViewer1 extends State<PdfViewer> {
  String filename;
  PdfViewer1(this.filename);

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  bool _isChecked = true;
  bool _isSaving = true;
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;
  bool loaded = false;
  String urlPDFPath = "";

  void initState() {
    requestPersmission();
    print("fichier : " + Setting.serveurpdf + "/" + filename);
    getFileFromUrl(Setting.serveurpdf + "/" + filename).then(
      (value) => {
        //   print("valeur fichier : "+value.path);
        setState(() {
          if (value != null) {
            urlPDFPath = value.path;
            loaded = true;
            exists = true;
          } else {
            exists = false;
          }
        })
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'dossier';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  Future<File> createFileOfPdfUrl(String url) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  Widget build(BuildContext context) {
    MySingleton mySingleton = new MySingleton();

    allTranslations.init(mySingleton.getLangue.toString());

    if (loaded) {
      print("PDF FIle : " + urlPDFPath);
      return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.transparent,
          leading: new IconButton(
            icon: new Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: PDFView(
          filePath: urlPDFPath,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          swipeHorizontal: true,
          nightMode: false,
          onError: (e) {
            //Show some error message or UI
          },
          onRender: (_pages) {
            setState(() {
              _totalPages = _pages;
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {
              _pdfViewController = vc;
            });
          },
          onPageChanged: (int page, int total) {
            setState(() {
              _currentPage = page;
            });
          },
          onPageError: (page, e) {},
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.chevron_left),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage > 0) {
                    _currentPage--;
                    _pdfViewController.setPage(_currentPage);
                  }
                });
              },
            ),
            Text(
              "${_currentPage + 1}/$_totalPages",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage < _totalPages - 1) {
                    _currentPage++;
                    _pdfViewController.setPage(_currentPage);
                  }
                });
              },
            ),
          ],
        ),
      );
    } else {
      if (exists) {
        print("PDF FIle 1 : " + urlPDFPath);
        //Replace with your loading UI
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(""),
            leading: new IconButton(
              icon: new Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Text(
            "Chargement..",
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        print("PDF FIle 2 : " + urlPDFPath);
        //Replace Error UI
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(""),
            leading: new IconButton(
              icon: new Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Text(
            "PDF Not Available",
            style: TextStyle(fontSize: 20),
          ),
        );
      }
    }
  }

  /*return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.white.withOpacity(1.0),
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Builder(builder: (BuildContext context) {
                    // TODO: implement build
                    return SingleChildScrollView(
                        child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Divider(
                              height: 100,
                              color: Colors.transparent,
                            ),
                            Divider(
                              height: 10.0,
                              color: Colors.transparent,
                            ),
                          ]),
                    ));
                  }),
                ),
                Positioned(
                    top: 50,
                    left: 20,
                    //height: 75,
                    child: new IconButton(
                      icon: new Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
              ],
            )));
  } */

}
