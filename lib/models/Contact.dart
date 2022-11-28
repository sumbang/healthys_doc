import 'dart:convert';

class Contact {
  String nom;
  String phone;
  String pays;
  String urgence;

  Contact({required this.nom, required this.phone, required this.pays, required this.urgence});

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
