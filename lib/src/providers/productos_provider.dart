import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:validaciones/src/models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'package:validaciones/src/preferencias_usuario/preferencias_usuario.dart';

class ProductosProvider {
  final String _url =
      'https://flutter-productos-3dd4b-default-rtdb.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = Uri.parse('$_url/productos.json');

    final resp = await http.post(url, body: productoModelToJson(producto));
    print(json.decode(resp.body));
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = Uri.parse('$_url/productos.json?auth=${_prefs.token}');
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = [];

    decodedData.forEach((id, producto) {
      final prodTemp = ProductoModel.fromJson(producto);
      prodTemp.id = id;
      productos.add(prodTemp);
      print(producto);
    });

    return productos;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url =
        Uri.parse('$_url/productos/${producto.id}.json?auth=${_prefs.token}');
    final resp = await http.put(url, body: productoModelToJson(producto));
    print(json.decode(resp.body));
    return true;
  }

  Future<int> borrarProducto(String id) async {
    final url = Uri.parse('$_url/productos/$id.json?auth=${_prefs.token}');
    final resp = await http.delete(url);
    print(json.decode(resp.body));
    return 1;
  }

  Future<String> subirImagen(PickedFile image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/saturno-fun/image/upload?upload_preset=eqyvivzg');
    final mimeType = mime(image.path)!.split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200) {
      print('Algo salio mal');
      print(resp.body);
      return '';
    }

    final respData = json.decode(resp.body);
    print(respData);
    return respData['secure_url'];
  }
}
