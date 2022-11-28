import 'dart:convert';

class Prescription {
  var id;
  String patient;
  var consultation;
  var soin;
  var qte;
  var posologie;
  String datep;

  Prescription(
      {this.id,
      required this.patient,
      this.consultation,
      this.soin,
      this.qte,
      this.posologie,
      required this.datep});

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
      id: json['id'],
      patient: json['patient'],
      consultation: json['consultation'],
      soin: json['soin'],
      qte: json['qte'],
      posologie: json['posologie'],
      datep: json['datep']);

  @override
  String toString() {
    return '${this.id.toString()} }';
  }
}
