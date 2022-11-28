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

  Abonnement({this.id,required this.photo,required this.nom,required this.abonnement,required this.debut,required this.fin,required this.profil,required this.payeur});

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