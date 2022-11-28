import 'dart:convert';

class Docteur {
  var id;
  String nom;
  String prenom;
  String phone;
  String specialite;

  Docteur({this.id, required this.nom, required  this.prenom, required this.phone,required  this.specialite});

  factory Docteur.fromJson(Map<String, dynamic> json) => Docteur(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      phone: json['phone'],
      specialite: json['specialite']);

  @override
  String toString() {
    return '${this.nom} ${this.prenom} (${this.specialite})';
  }
}
