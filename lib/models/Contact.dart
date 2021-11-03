import 'dart:convert';

class Contact {
  String nom;
  String phone;
  String pays;
  String urgence;

  Contact({this.nom, this.phone, this.pays, this.urgence});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
      nom: json['nom'],
      phone: json['phone'],
      pays: json['pays'],
      urgence: json['urgence']);

  @override
  String toString() {
    return '${this.nom.toString()}';
  }
}
