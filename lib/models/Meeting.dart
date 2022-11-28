import 'dart:convert';

class Meeting {
  var id;
  var idprofil;
  var idcentresoins;
  var idmedecin;
  String datemeeting;
  String heuremeeting;
  String statut;
  String symptome;
  String docname;
  String specialite;
  String patientname;
  String patientmatricule;
  String notes;

  Meeting(
      {this.id,
      this.idprofil,
      this.idcentresoins,
      this.idmedecin,
      required this.datemeeting,
      required this.heuremeeting,
      required this.statut,
      required this.symptome,
      required this.docname,
     required  this.specialite,
      required this.patientname,
     required  this.patientmatricule,
     required  this.notes});

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        id: json['id'],
        idprofil: json['idprofil'],
        idcentresoins: json['hopital'],
        idmedecin: json['idmedecin'],
        datemeeting: json['datemeeting'],
        heuremeeting: json['heuremeeting'],
        statut: json['statut'].toString(),
        symptome: json['symptome'],
        docname: json['docname'],
        specialite: json['specialite'],
        patientname: json['patientname'],
        patientmatricule: json['patientmatricule'],
        notes: json['notes'],
      );

  @override
  String toString() {
    return '${this.id.toString()} }';
  }
}

