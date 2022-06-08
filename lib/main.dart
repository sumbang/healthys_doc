import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:healthys_medecin/lock/lock_screen.dart';
import 'package:healthys_medecin/pages/ChooseProfile.dart';
import 'package:splashscreen/splashscreen.dart';
import './pages/HomePage.dart';
import './pages/StartPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/all_translations.dart';


void main() {
  runApp(AppLock(
    builder: (args) => MyApp(),
    lockScreen: LockScreen(),
    enabled: true,
    backgroundLockLatency: const Duration(seconds: 30),
  ));
}
//void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  //final color = const Color(0xFFffffff);
  final color = const Color(0xFFcd005f);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bienvenue sur Healthy',
      theme: new ThemeData(
        // Add the 3 lines from here...
        primaryColor: color,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Tells the system which are the supported languages
      supportedLocales: allTranslations.supportedLocales(),
      home: HomePag(),
    );
  }
}

class HomePag extends StatefulWidget {
  @override
  HomePagState createState() => new HomePagState();
}

class HomePagState extends State<HomePag> {
  //final color = const Color(0xFFffffff);
  final color = const Color(0xFFcd005f);

  String token = "";

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      token = (prefs.getString("token") ?? "");
    });
  }

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds:
          token.toString().isEmpty ? new StartPage() : new ChooseProfilePage(),
      /*title: new Text(allTranslations.text('main_title'),
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black,
        ), textAlign: TextAlign.center,),*/
      image: Image.asset('img/doc.png'),
      backgroundColor: color,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 150.0,
      //onClick: ()=>print("Flutter Egypt"),
      loaderColor: Colors.blue,
    );
  }
}
