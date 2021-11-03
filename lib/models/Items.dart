import 'dart:convert';

class MyItems {

  var id;
  String libelle;

  MyItems({this.id,this.libelle});

  factory MyItems.fromJson(Map<String, dynamic> json)=> MyItems(
      id: json['id'],
      libelle: json['libelle']
  );


  @override
  String toString() {
    return '${this.libelle}';
  }

}