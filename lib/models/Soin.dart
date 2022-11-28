import 'dart:convert';

class Soin {
  var id;
  String libelle;

  Soin({this.id,required  this.libelle});

  factory Soin.fromJson(Map<String, dynamic> json) => Soin(
        id: json['id'],
        libelle: json['libelle'],
      );

  @override
  String toString() {
    return '${this.id.toString()} }';
  }
}
