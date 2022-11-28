import 'dart:convert';

class Partenaire {
  var id;
  String nom;
  String description;
  String paysid;
  String paysnom;
  String ville;
  String logo;
  String contact;
  String email;

  Partenaire(
      {this.id,
     required  this.nom,
     required  this.description,
     required  this.paysid,
     required  this.paysnom,
     required  this.ville,
     required  this.logo,
     required  this.contact,
     required  this.email});

  factory Partenaire.fromJson(Map<String, dynamic> json) => Partenaire(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      paysid: json['paysid'],
      paysnom: json['paysnom'],
      ville: json['ville'],
      logo: json['logo'],
      contact: json['contact'],
      email: json['email']);

  @override
  String toString() {
    return '${this.id.toString()} ${this.nom} ${this.description} ${this.logo.toString()}';
  }
}
