import 'dart:convert';

class Employe {
  String hopital;
  String horaire;
  String localisation;
  var idhospi;
  var status;

  Employe(
      {required this.hopital,
      required this.horaire,
      required this.localisation,
      this.idhospi,
      this.status});

  factory Employe.fromJson(Map<String, dynamic> json) => Employe(
      hopital: json['hopital'],
      horaire: json['horaire'],
      localisation: json['localisation'],
      idhospi: json['idhospi'],
      status: json['status']);

  @override
  String toString() {
    return '${this.horaire}';
  }
}
