import 'dart:convert';

class Soins {
  var id;
  String nom;
  var cat_id;
  String cat_nom;
  String code;
  String ref;

  Soins({this.id, this.nom, this.cat_id, this.cat_nom, this.code,this.ref});

  factory Soins.fromJson(Map<String, dynamic> json) => Soins(
        id: json['id'],
        nom: json['nom'],
        cat_id: json['cat_id'],
        cat_nom: json['cat_nom'],
        code: json['code'],
        ref: json['ref'],
      );

  @override
  String toString() {
    return '${this.nom.toString()}';
  }
}
