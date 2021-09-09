import 'dart:io';
import 'package:flutter/material.dart';
import 'package:validaciones/src/models/producto_model.dart';
import 'package:validaciones/src/providers/productos_provider.dart';
import 'package:validaciones/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';
import 'home_page.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();

  final productoProvider = new ProductosProvider();
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  final _picker = new ImagePicker();
  PickedFile? foto;

  @override
  Widget build(BuildContext context) {
    final prodData = ModalRoute.of(context)?.settings.arguments;

    if (prodData != null) {
      producto = prodData as ProductoModel;
    }

    return Scaffold(
        appBar: AppBar(title: Text('Producto'), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ]),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(15.0),
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      _mostrarFoto(),
                      _crearNombre(),
                      _crearPrecio(),
                      _crearDisponible(),
                      _crearBoton(context),
                    ])))));
  }

  Widget _mostrarFoto() {
    print('foto?.path: ${foto?.path}');
    print('producto.fotoUrl: ${producto.fotoUrl}');

    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl!),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          File(foto!.path),
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = await _picker.getImage(source: origen);

    if (foto != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }

  Widget _crearNombre() {
    return TextFormField(
        initialValue: producto.titulo,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: 'Producto'),
        onSaved: (value) => value == null ? null : producto.titulo = value,
        validator: (value) {
          if (value == null) return null;
          if (value.length < 3) {
            return 'Ingrese el nombre del producto';
          } else {
            return null;
          }
        });
  }

  Widget _crearPrecio() {
    return TextFormField(
        initialValue: producto.valor.toString(),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: 'Precio'),
        onSaved: (value) => {
              if (value != null) {producto.valor = double.parse(value)}
            },
        validator: (value) {
          if (value == null) return null;
          if (utils.isNumeric(value)) {
            return null;
          } else {
            return 'Sólo números';
          }
        });
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton(context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 5.0,
          backgroundColor: Colors.deepPurple,
          primary: Colors.white,
          fixedSize: Size.fromHeight(30.0)),
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando == true) ? null : _submit,
    );
  }

  void _submit() async {
    setState(() {
      _guardando = true;
    });

    if (!formKey.currentState!.validate()) return;

    formKey.currentState?.save();

    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto!);
    }

    if (producto.id == null) {
      await productoProvider.crearProducto(producto);
    } else {
      await productoProvider.editarProducto(producto);
    }
    mostrarSnackBar('Registro guardado');

    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new HomePage()));

    setState(() {
      _guardando = false;
    });
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
