import 'dart:convert';

class Meeting {
  var id;
  var idprofil;
  var idcentresoins;
  var idmedecin;
  String datemeeting;
  var statut;
  String symptome;
  String docname;
  String hopital;
  String notes;

  Meeting(
      {this.id,
      this.idprofil,
      this.idcentresoins,
      this.idmedecin,
      this.datemeeting,
      this.statut,
      this.symptome,
      this.docname,
      this.hopital,
      this.notes});

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        id: json['id'],
        idprofil: json['idprofil'],
        idcentresoins: json['hopital'],
        idmedecin: json['idmedecin'],
        datemeeting: json['datemeeting'],
        statut: json['statut'],
        symptome: json['symptome'],
        docname: json['docname'],
        hopital: json['hopital'],
        notes: json['notes'],
      );

  @override
  String toString() {
    return '${this.id.toString()} }';
  }
}
