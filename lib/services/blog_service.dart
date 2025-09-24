import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/services/auth_service.dart'; // para usar el token

class BlogService {
  final String baseUrl = "https://api-gateway-8wvg.onrender.com";

  /// Obtener todos los blogs
  Future<List<dynamic>> fetchBlogs() async {
    final url = Uri.parse("$baseUrl/api/blogs");

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${AuthService.token}", // token JWT
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Si la API devuelve un objeto con "content" (paginación)
      if (data is Map<String, dynamic> && data.containsKey("content")) {
        return data["content"];
      }

      // Si devuelve directamente una lista
      if (data is List) {
        return data;
      }

      throw Exception("Formato inesperado en la respuesta: $data");
    } else {
      throw Exception("Error al obtener blogs: ${response.body}");
    }
  }

  /// Crear un nuevo blog
  Future<bool> createBlog(String titulo, String contenido) async {
    final url = Uri.parse("$baseUrl/api/blogs");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${AuthService.token}",
      },
      body: jsonEncode({
        "titulo": titulo,
        "contenido": contenido,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Error al crear blog: ${response.body}");
    }
  }

  /// Eliminar un blog por ID
  Future<bool> deleteBlog(int id) async {
    final url = Uri.parse("$baseUrl/api/blogs/$id");

    final response = await http.delete(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${AuthService.token}",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception("Error al eliminar blog: ${response.body}");
    }
  }

  /// Actualizar un blog existente
  Future<bool> updateBlog(int id, String titulo, String contenido) async {
    final url = Uri.parse("$baseUrl/api/blogs/$id");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${AuthService.token}",
      },
      body: jsonEncode({
        "titulo": titulo,
        "contenido": contenido,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Error al actualizar blog: ${response.body}");
    }
  }
}
