import 'dart:convert';

class Profil {
  var id;
  var patient;
  String nom;
  String numero;
  String photo;
  String pin;
  var payer;
  var integral;

  Profil(
      {this.id,
      this.patient,
      this.nom,
      this.numero,
      this.photo,
      this.pin,
      this.payer,
      this.integral});

  factory Profil.fromJson(Map<String, dynamic> json) => Profil(
      id: json['id'],
      patient: json['patient'],
      nom: json['nom'],
      numero: json['numero'],
      photo: json['photo'],
      pin: json['pin'],
      payer: json['payer'],
      integral: json['integral']);

  @override
  String toString() {
    return '${this.id.toString()} ${this.nom} ${this.numero} ${this.patient.toString()}';
  }
}
