import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthys_medecin/config/all_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AutoDepistageFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    allTranslations.init(myLocale.languageCode.toString());

    // TODO: implement build
    return new Center(child: new Text(allTranslations.text('autod_title')));
  }
}
