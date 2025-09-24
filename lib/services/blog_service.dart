import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogService {
  final String baseUrl = "https://api-gateway-8wvg.onrender.com";

  /// Obtener todos los blogs
  Future<List<dynamic>> fetchBlogs() async {
    final url = Uri.parse("$baseUrl/api/blogs");

    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
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

    final response = await http.delete(url);

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
