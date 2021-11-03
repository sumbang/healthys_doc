import 'dart:convert';

class Assurance {
  var id;
  String assureur;
  String police;
  String couverture;
  String plafond;
  String prime;
  String echeance;
  var profil;
  String assure;

  Assurance(
      {this.id,
      this.assureur,
      this.police,
      this.couverture,
      this.plafond,
      this.prime,
      this.echeance,
      this.profil,
      this.assure});

  factory Assurance.fromJson(Map<String, dynamic> json) => Assurance(
      id: json['id'],
      assureur: json['assureur'],
      police: json['police'],
      couverture: json['couverture'],
      plafond: json['plafond'],
      prime: json['prime'],
      echeance: json['echeance'],
      profil: json['profil'],
      assure: json['assure']);

  @override
  String toString() {
    return '${this.id.toString()} ${this.police} ${this.assureur} ${this.profil.toString()}';
  }
}
