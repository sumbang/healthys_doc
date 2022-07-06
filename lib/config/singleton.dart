class MySingleton {

    static final MySingleton _singleton = MySingleton._internal();

    String _langue = "";

    get getLangue => _langue;

    void setLangue(choix) {
      _langue = choix;
    }

    factory MySingleton() {
      return _singleton;
    }

    MySingleton._internal();

}