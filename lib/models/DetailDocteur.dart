import 'dart:convert';

class DetailDocteur {
  var id;
  String nom;
  String prenom;
  String phone;
  String phone2;
  String specialite;
  String email;
  String datnaiss;
  String adresse;
  String hopital;
  String horaire;
  String photo;

  DetailDocteur(
      {this.id,
      required this.nom,
     required  this.prenom,
     required  this.phone,
      required this.phone2,
     required  this.specialite,
     required  this.email,
      required this.datnaiss,
      required this.adresse,
     required  this.hopital,
     required  this.horaire,
     required  this.photo});

  factory DetailDocteur.fromJson(Map<String, dynamic> json) => DetailDocteur(
        id: json['id'],
        nom: json['nom'],
        prenom: json['prenom'],
        phone: json['phone'],
        phone2: json['phone2'],
        specialite: json['specialite'],
        email: json['email'],
        datnaiss: json['datnaiss'],
        adresse: json['adresse'],
        hopital: json['hopital'],
        horaire: json['horaire'],
        photo: json['photo'],
      );

  @override
  String toString() {
    return '${this.nom} ${this.prenom} (${this.specialite})';
  }
}
