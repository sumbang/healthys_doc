import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Menu {

  var id;
  String libelle;
  String icone;

  Menu(this.id,this.libelle,this.icone);

  @override
  String toString() {
    return '${this.libelle}';
  }

}