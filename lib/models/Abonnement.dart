import 'dart:convert';

class Abonnement {

  var id;
  String photo;
  String nom;
  String abonnement;
  String debut;
  String fin;
  String profil;
  String payeur;

  Abonnement({this.id,this.photo,this.nom,this.abonnement,this.debut,this.fin,this.profil,this.payeur});

  factory Abonnement.fromJson(Map<String, dynamic> json)=> Abonnement(
      id: json['id'],
      photo: json['photo'],
      nom: json['nom'],
      abonnement: json['abonnement'],
      debut: json['debut'],
      fin: json['fin'],
      profil: json['profil'],
      payeur: json['payeur']
  );


  @override
  String toString() {
    return '${this.id.toString()} ${this.nom} ${this.payeur} ${this.profil.toString()}';
  }

}