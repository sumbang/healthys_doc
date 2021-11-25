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
      this.datemeeting,
      this.heuremeeting,
      this.statut,
      this.symptome,
      this.docname,
      this.specialite,
      this.patientname,
      this.patientmatricule,
      this.notes});

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

