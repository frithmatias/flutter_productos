import 'package:flutter/material.dart';

bool isNumeric(String str){
  if(str.isEmpty) return false; 
  final n = num.tryParse(str);
  return (n == null ) ? false : true;
}

void mostrarAlerta(BuildContext context, String msg){
  showDialog(
    context: context, 
    builder: ( context ) {
      return AlertDialog(
        title: Text('Información Incorrecta'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: Text('OK')
          )
        ]
      );
    }
  ); 
}