import 'dart:convert';

class Medicament {
  var id;
  String nom;
  String forme;
  String quantite;
  String prix;

  Medicament({this.id, this.nom, this.forme, this.quantite, this.prix});

  factory Medicament.fromJson(Map<String, dynamic> json) => Medicament(
        id: json['id'],
        nom: json['nom'],
        forme: json['forme'],
        quantite: json['quantite'],
        prix: json['prix'],
      );

  @override
  String toString() {
    return '${this.nom.toString()}';
  }
}
