import 'dart:convert';

import 'package:healthys_medecin/models/Profil.dart';

class Compte {
  var id;
  String nom;
  String login;
  String datnaiss;
  String paysid;
  String paysnom;
  String ville;
  String email;
  int sexeid;
  String sexenom;
  String quartier;
  String date;
  String biometrie;
  Profil profil;
  List<Profil> profils;

  Compte(
      {this.id,
      this.nom,
      this.login,
      this.datnaiss,
      this.paysid,
      this.paysnom,
      this.ville,
      this.email,
      this.sexeid,
      this.sexenom,
      this.quartier,
      this.date,
      this.biometrie,
      this.profil,
      this.profils});

  factory Compte.fromJson(Map<String, dynamic> json) => Compte(
      id: json['id'],
      nom: json['nom'],
      login: json['login'],
      datnaiss: json['datnaiss'],
      paysid: json['paysid'],
      paysnom: json['paysnom'],
      ville: json['ville'],
      email: json['email'],
      biometrie: json['biometrie'],
      sexeid: json['sexeid'],
      sexenom: json['sexenom'],
      quartier: json['quartier'],
      date: json['date'],
      profil: Profil.fromJson(json['profil']),
      profils:
          List<Profil>.from(json["profils"].map((x) => Profil.fromJson(x))));

  @override
  String toString() {
    return '${this.id.toString()} ${this.nom} ${this.date} ';
  }
}
