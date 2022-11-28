import 'dart:convert';

class Mconsultation2 {
  var id;
  String dateconsultation;
  String photo;
  String infirmiere;
  String patient;
  String phone;
  String motif;
  String diagnostic;
  String malade;
  String numero;

  Mconsultation2(
      {this.id,
      required this.photo,
      required this.dateconsultation,
      required this.infirmiere,
      required this.patient,
      required this.phone,
      required this.motif,
      required this.diagnostic,
      required this.malade,
      required this.numero});

  factory Mconsultation2.fromJson(Map<String, dynamic> json) => Mconsultation2(
      id: json['id'],
      photo: json['photo'],
      dateconsultation: json['dateconsultation'],
      infirmiere: json['infirmiere'],
      patient: json['patient'],
      phone: json['phone'],
      motif: json['motif'],
      diagnostic: json['diagnostic'],
      malade: json['malade'].toString(),
      numero: json['matricule'].toString());

  @override
  String toString() {
    return '${this.id.toString()} ${this.patient} ${this.motif} ${this.infirmiere.toString()}';
  }
}
