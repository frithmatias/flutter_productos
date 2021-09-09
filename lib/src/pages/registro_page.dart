import 'package:flutter/material.dart';
import 'package:validaciones/src/bloc/login_bloc.dart';
import 'package:validaciones/src/bloc/provider.dart';
import 'package:validaciones/src/providers/usuario_provider.dart';
import 'package:validaciones/src/utils/utils.dart';

class RegistroPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _loginForm(context) {
    final bloc = Provider.of(context);

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      SafeArea(child: Container(height: 180.0)),
      Container(
          width: MediaQuery.of(context).size.width * .85,
          margin: EdgeInsets.symmetric(vertical: 30.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0)
              ]),
          child: Column(children: <Widget>[
            Text('Crear cuenta'),
            SizedBox(height: 60.0),
            _inputEmail(bloc),
            SizedBox(height: 30.0),
            _inputPassword(bloc),
            SizedBox(height: 30.0),
            _submitButton(bloc),
          ])),
      TextButton(
        child: Text('¿Ya tenés cuenta? Ingresa acá'),
        onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
      ),
      SizedBox(height: 100.0)
    ]));
  }

  Widget _inputEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText:
                    snapshot.error != null ? snapshot.error.toString() : null,
              ),
              onChanged: bloc.changeEmail,
            ));
      },
    );
  }

  Widget _inputPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                labelText: 'Contraseña',
                counterText: snapshot.data,
                errorText:
                    snapshot.error != null ? snapshot.error.toString() : null,
              ),
              onChanged: bloc.changePassword,
            ));
      },
    );
  }

  Widget _submitButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text(snapshot.data.toString())),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 0.0,
              primary: Colors.deepPurple,
              textStyle: TextStyle(color: Colors.blue, fontSize: 18)),
          onPressed:
              snapshot.data == true ? () => _register(bloc, context) : null,
        );
      },
    );
  }

  _register(LoginBloc bloc, context) async {
    print(
        'Registrando usuario con Email: ${bloc.ultimoEmailIngresado} Pass: ${bloc.ultimoPasswordIngresado}');

    final info = await usuarioProvider.nuevoUsuario(
        bloc.ultimoEmailIngresado, bloc.ultimoPasswordIngresado);

    if (info['ok']) {
      Navigator.pushNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['message']);
    }
  }

  Widget _crearFondo(context) {
    final fondoMorado = Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1),
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, .05)),
    );

    return Stack(children: <Widget>[
      fondoMorado,
      Positioned(child: circulo, top: 90.0, left: 30.0),
      Positioned(child: circulo, top: -40.0, right: -30.0),
      Positioned(child: circulo, bottom: -10.0, right: -10.0),
      Positioned(child: circulo, top: 20.0),
      Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
                SizedBox(width: double.infinity),
                Text('Matias Frith', style: TextStyle(color: Colors.white))
              ]))
    ]);
  }
}
