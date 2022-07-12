import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:healthys_medecin/config/singleton.dart';

import '../main.dart';


class ChooseLanguage extends StatelessWidget {
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new ChooseLanguage1(),
    );
  }
}

class ChooseLanguage1 extends StatefulWidget {
  ChooseLanguage1();

  @override
  ChooseLanguagePageState createState() => new ChooseLanguagePageState();
}

class ChooseLanguagePageState extends State<ChooseLanguage1> {
  ChooseLanguagePageState();

  final color = const Color(0xFFcd005f);
  final color2 = const Color(0xFF008dad);

  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(""),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: null,
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    itemExtent: 80,
                    children : [
                      Center(child : GestureDetector(onTap: (){
                            MySingleton mySingleton = new MySingleton();
                            mySingleton.setLangue("fr");
                          AppLock.of(context).enable();
                          AppLock.of(context).showLockScreen();
                             Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (_) => new MyApp()),
                            );
                      },child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(child: new Image.asset("img/flag_fr.png", height: 40,), flex: 1,),
                          SizedBox(width: 20,),
                          Flexible(child: Text("FRANCAIS", style: TextStyle(color: color2, fontSize: 18),),)
                        ],
                      ))),

                   
                      Center(child :  GestureDetector(onTap: (){
                           MySingleton mySingleton = new MySingleton();
                            mySingleton.setLangue("en");
                            
                          AppLock.of(context).enable();
                          AppLock.of(context).showLockScreen();
                             Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (_) => new MyApp()),
                            );
                      },child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(child: new Image.asset("img/flag_en.png", height: 40,), flex: 1,),
                          SizedBox(width: 20,),
                          Flexible(child: Text("ENGLISH  ", style: TextStyle(color: color2, fontSize: 18),),)
                        ],
                      ))),

                   
                        Center(child : GestureDetector(onTap: (){
                             MySingleton mySingleton = new MySingleton();
                            mySingleton.setLangue("es");
                            
                          AppLock.of(context).enable();
                          AppLock.of(context).showLockScreen();
                             Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (_) => new MyApp()),
                            );
                      },child:  Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(child: new Image.asset("img/flag_es.png", height: 40,), flex: 1,),
                          SizedBox(width: 20,),
                          Flexible(child: Text("ESPAÑA   ", style: TextStyle(color: color2, fontSize: 18),),)
                        ],
                      ))),

                    ]
                  )
              ),
            )));
  }
}
