import 'dart:convert';

class Indice {

  String libelle;
  String valeur;

  Indice({this.libelle,this.valeur});

  factory Indice.fromJson(Map<String, dynamic> json)=> Indice(
      libelle: json['label'],
      valeur: json['valeur']
  );

  @override
  String toString() {
    return '${this.libelle}';
  }

}