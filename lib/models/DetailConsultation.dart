import 'dart:convert';

class DetailConsultation {

  var id;
  String motifs;
  String dateconsultation;
  String diagnostic;
  String ordonnance;
  String histoire;
  String examen;
  String resultat;
  String conclusion;
  String scan1;
  String scan2;
  String resultat1;
  String diagnostic1;
  String mise1;

  DetailConsultation({this.id,this.motifs,this.dateconsultation,this.diagnostic,this.ordonnance,this.histoire,this.examen,this.resultat,this.conclusion,this.scan1,this.scan2,this.resultat1,this.diagnostic1,this.mise1});

  factory DetailConsultation.fromJson(Map<String, dynamic> json)=> DetailConsultation(
      id: json['id'],
      motifs: json['motifs'],
      dateconsultation: json['dateconsultation'],
      ordonnance: json['ordonnance'],
      histoire: json['histoire'],
      examen: json['examen'],
      resultat: json['resultat'],
      conclusion: json['conclusion'],
      diagnostic: json['diagnostic'],
      scan1: json['scan1'],
      scan2: json['scan2'],
      resultat1: json['resultat1'],
      diagnostic1: json['diagnostic1'],
      mise1: json['mise1']
  );


  @override
  String toString() {
    return '${this.id.toString()} ${this.motifs} ${this.examen} ${this.diagnostic.toString()}';
  }

}