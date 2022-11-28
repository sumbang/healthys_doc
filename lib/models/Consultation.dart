import 'dart:convert';

class Consultation {

  var id;
  String medecin;
  String phone;
  String motif;
  String specialite;
  String diagnostic;
  String lieu;
  String dateconsultation;
  String photo;

  Consultation({this.id,required this.medecin,required this.phone,required this.motif,required this.specialite,required this.diagnostic,required this.lieu,required this.dateconsultation,required this.photo});

  factory Consultation.fromJson(Map<String, dynamic> json)=> Consultation(
      id: json['id'],
      medecin: json['medecin'],
      phone: json['phone'],
      motif: json['motif'],
      specialite: json['specialite'],
      diagnostic: json['diagnostic'],
      lieu: json['lieu'],
      dateconsultation: json['dateconsultation'],
      photo: json['photo']
  );


  @override
  String toString() {
    return '${this.id.toString()} ${this.medecin} ${this.phone} ${this.diagnostic.toString()}';
  }

}