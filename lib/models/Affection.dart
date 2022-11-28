import 'dart:convert';

class Affection {
  String code_affection;
  String lib_affection;
  var statut;

  Affection({required this.code_affection, required this.lib_affection, this.statut});

  factory Affection.fromJson(Map<String, dynamic> json) => Affection(
        code_affection: json['id'],
        lib_affection: json['nom'],
        statut: json['statut'],
      );

  @override
  String toString() {
    return '${this.lib_affection.toString()}';
  }
}
