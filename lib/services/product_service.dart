import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/models/producto.dart';

class ProductService {
  final String baseUrl = "https://api-gateway-8wvg.onrender.com/api/productos";

  Future<List<Producto>> fetchProductos() async {
    final response = await http.get(Uri.parse("$baseUrl/lista"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 🔹 Si devuelve un array directo
      if (data is List) {
        return data.map((json) => Producto.fromJson(json)).toList();
      }

      // 🔹 Si devuelve un objeto con "content" (en caso de paginado)
      if (data is Map && data.containsKey("content")) {
        return (data["content"] as List)
            .map((json) => Producto.fromJson(json))
            .toList();
      }

      return [];
    } else {
      throw Exception("Error al cargar productos: ${response.statusCode}");
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
