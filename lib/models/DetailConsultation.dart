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
  var evolution;

  DetailConsultation({this.id,required this.motifs,required this.dateconsultation,required this.diagnostic,required this.ordonnance,required this.histoire,required this.examen,required this.resultat,required this.conclusion,required this.scan1,required this.scan2,required this.resultat1,required this.diagnostic1,required this.mise1,this.evolution});

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
      mise1: json['mise1'],
      evolution: json['evolution']
  );


  @override
  String toString() {
    return '${this.id.toString()} ${this.motifs} ${this.examen} ${this.diagnostic.toString()}';
  }

}