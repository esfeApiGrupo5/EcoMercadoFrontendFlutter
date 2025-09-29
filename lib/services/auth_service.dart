import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://usuarioapi-nflv.onrender.com";

  // 🔹 Datos globales del usuario
  static String? token;
  static String? nombre;
  static String? correo;

  // 🔹 Cerrar sesión
  static void logout() {
    token = null;
    nombre = null;
    correo = null;
  }

  /// LOGIN
  Future<String?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "correo": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 🔹 Guardamos token y datos del usuario directamente
      token = data["token"];
      nombre = data["nombre"];
      correo = data["correo"];

      return token;
    } else {
      throw Exception("Error en login: ${response.body}");
    }
  }

  /// REGISTER
  Future<bool> register(String nombreUser, String correoUser, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/registrar");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "nombre": nombreUser,
        "correo": correoUser,
        "password": password,
        "estado": 1,
        "idRol": 1
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Error en registro: ${response.body}");
    }
  }
}
