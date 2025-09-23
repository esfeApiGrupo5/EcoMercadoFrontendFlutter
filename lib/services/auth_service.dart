import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://usuarioapi-nflv.onrender.com";

  Future<String?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "correo": email, // 👈 Ojo, aquí ya corrigiste bien
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    } else {
      throw Exception("Error en login: ${response.body}");
    }
  }

  Future<bool> register(String nombre, String correo, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/register");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "nombre": nombre,
        "correo": correo,
        "password": password,
        "estado": 1,
        "idRol": 1,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true; // registro exitoso
    } else {
      throw Exception("Error en registro: ${response.body}");
    }
  }
}
