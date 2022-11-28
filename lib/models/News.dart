import 'dart:convert';

class News {
  var id;
  String titre;
  String description;
  String date;
  String contenu;
  String image;

  News(
      {this.id,
     required  this.titre,
      required this.description,
      required this.date,
      required this.contenu,
      required this.image});

  factory News.fromJson(Map<String, dynamic> json) => News(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      date: json['date'],
      contenu: json['contenu'],
      image: json['image']);

  @override
  String toString() {
    return '${this.id.toString()} ${this.titre} ${this.description} ${this.image.toString()}';
  }
}
