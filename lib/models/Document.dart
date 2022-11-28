import 'dart:convert';

class Document {
  String titre;
  String patient;
  String datecreation;
  String fichier;

  Document({required this.titre, required this.patient, required this.datecreation, required this.fichier});

  factory Document.fromJson(Map<String, dynamic> json) => Document(
      titre: json['titre'],
      patient: json['patient'],
      datecreation: json['datecreation'],
      fichier: json['fichier']);

  @override
  String toString() {
    return '${this.patient}';
  }
}
