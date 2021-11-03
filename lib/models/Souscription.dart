import 'dart:convert';

class Souscription {
  String nom;
  String photo;
  String debut;
  String fin;
  var statut;
  String libelle;
  var duree;
  String numero;

  Souscription(
      {this.nom,
      this.libelle,
      this.debut,
      this.fin,
      this.duree,
      this.statut,
      this.numero,
      this.photo});

  factory Souscription.fromJson(Map<String, dynamic> json) => Souscription(
      nom: json['nom'],
      libelle: json['libelle'],
      photo: json['photo'],
      debut: json['debut'],
      fin: json['fin'],
      duree: json['duree'],
      statut: json['statut'],
      numero: json['numero']);

  @override
  String toString() {
    return '${this.nom.toString()} }';
  }
}
