import 'dart:convert';

class Programme {
  var id;
  String pays;
  String paysname;
  String titre;
  String description;
  String image;
  String message;
  String date;

  Programme(
      {this.id,
      this.pays,
      this.paysname,
      this.titre,
      this.description,
      this.image,
      this.message,
      this.date});

  factory Programme.fromJson(Map<String, dynamic> json) => Programme(
      id: json['id'],
      pays: json['pays'],
      paysname: json['paysname'],
      titre: json['titre'],
      description: json['description'],
      image: json['image'],
      message: json['message'],
      date: json['date']);

  @override
  String toString() {
    return '${this.id.toString()} }';
  }
}
