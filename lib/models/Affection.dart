import 'dart:convert';

class Affection {
  String code_affection;
  String lib_affection;
  var statut;

  Affection({this.code_affection, this.lib_affection, this.statut});

  factory Affection.fromJson(Map<String, dynamic> json) => Affection(
        code_affection: json['code_affection'],
        lib_affection: json['lib_affection'],
        statut: json['statut'],
      );

  @override
  String toString() {
    return '${this.lib_affection.toString()}';
  }
}
