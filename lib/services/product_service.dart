import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/models/producto.dart';

class ProductService {
  final String baseUrl = "https://api-gateway-8wvg.onrender.com/api/productos";

  Future<List<Producto>> fetchProductos() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${AuthService.token}",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener productos: ${response.body}");
    }
  }

  Future<bool> createProducto(Producto producto) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AuthService.token}",
      },
      body: jsonEncode(producto.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateProducto(Producto producto) async {
    final url = Uri.parse("$baseUrl/${producto.id}");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AuthService.token}",
      },
      body: jsonEncode(producto.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteProducto(int id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer ${AuthService.token}",
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
