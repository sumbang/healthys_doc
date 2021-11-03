import 'Indice.dart';

class Indicateur {
  String label;
  List<Indice> child;

  Indicateur(this.label, this.child);

  @override
  String toString() {
    return '${this.label}';
  }
}
