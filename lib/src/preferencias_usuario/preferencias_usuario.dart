import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();
  SharedPreferences? _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get genero {
    return _prefs?.getInt('genero') ?? 1;
  }

  set genero(int value) {
    _prefs?.setInt('genero', value);
  }

  bool get colorSecundario {
    return _prefs?.getBool('colorSecundario') ?? false;
  }

  set colorSecundario(bool value) {
    _prefs?.setBool('colorSecundario', value);
  }

  String get token {
    return _prefs?.getString('token') ?? '';
  }

  set token(String value) {
    _prefs?.setString('token', value);
  }

  String get ultimaPagina {
    return _prefs?.getString('ultimaPagina') ?? 'home';
  }

  set ultimaPagina(String value) {
    _prefs?.setString('ultimaPagina', value);
  }
}
