import 'dart:convert';

class Contenu {
  String libelle;
  String valeur;
  String date;

  Contenu({required this.libelle, required this.valeur,required  this.date});

  factory Contenu.fromJson(Map<String, dynamic> json) => Contenu(
      libelle: json['libelle'].toString(),
      valeur: json['valeur'].toString(),
      date: json['date']);

  @override
  String toString() {
    return '{ ${this.libelle}, ${this.valeur}, ${this.date} }';
  }
}
