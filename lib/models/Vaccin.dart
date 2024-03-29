import 'dart:convert';

class Vaccin {
  var id;
  String nom;
  String importance;
  String date;
  String periode;
  var prise;
  String personne;

  Vaccin(
      {this.id,
     required  this.nom,
     required  this.importance,
     required  this.date,
     required  this.periode,
      this.prise,
    required   this.personne});

  factory Vaccin.fromJson(Map<String, dynamic> json) => Vaccin(
      id: json['id'],
      nom: json['nom'],
      importance: json['importance'],
      date: json['date'],
      periode: json['periode'],
      prise: json['prise'],
      personne: json['personne']);

  @override
  String toString() {
    return '${this.id.toString()} ${this.nom} ${this.importance} ${this.prise.toString()}';
  }
}
