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
     required  this.pays,
     required  this.paysname,
     required  this.titre,
     required  this.description,
     required  this.image,
     required  this.message,
     required  this.date});

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
