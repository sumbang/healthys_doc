import 'dart:convert';

class Content {

  String libelle;
  String valeur;
  var groupe;
  var famille;

  Content({this.libelle, this.valeur, this.groupe, this.famille});

  factory Content.fromJson(Map<String, dynamic> json)=> Content(
      libelle: json['libelle'].toString(),
      valeur: json['valeur'].toString(),
      groupe: json['groupe'],
      famille: json['famille']
  );

  @override
  String toString() {
    return '{ ${this.libelle}, ${this.valeur}, ${this.groupe} }';
  }

}
