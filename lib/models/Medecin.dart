import 'dart:convert';

import 'Employe.dart';

class Medecin {
  var id;
  String nom;
  String phone;
  String email;
  String adresse;
  String specialite;
  String photo;
  List<Employe> emplois;

  Medecin(
      {this.id,
      this.nom,
      this.phone,
      this.email,
      this.adresse,
      this.specialite,
      this.photo,
      this.emplois});

  factory Medecin.fromJson(Map<String, dynamic> json) => Medecin(
      id: json['id'],
      nom: json['nom'],
      phone: json['phone'],
      email: json['email'],
      adresse: json['adresse'],
      specialite: json['specialite'],
      photo: json['photo'],
      emplois:
          List<Employe>.from(json["employe"].map((x) => Employe.fromJson(x))));

  @override
  String toString() {
    return '${this.id.toString()} ${this.nom} }';
  }
}
