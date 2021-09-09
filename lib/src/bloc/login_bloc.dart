import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:validaciones/src/bloc/validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream,
          (ultimoEmailValido, ultimoPasswordValido) {
        if ((ultimoEmailValido == _emailController.value) &&
            (ultimoPasswordValido == _passwordController.value)) {
          return true;
        } else {
          return false;
        }
      });

  String get ultimoEmailIngresado =>
      _emailController.hasValue ? _emailController.value : '';
  String get ultimoPasswordIngresado =>
      _emailController.hasValue ? _emailController.value : '';

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
