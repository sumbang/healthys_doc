import 'dart:convert';

class Document {
  String titre;
  String patient;
  String datecreation;
  String fichier;

  Document({this.titre, this.patient, this.datecreation, this.fichier});

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
