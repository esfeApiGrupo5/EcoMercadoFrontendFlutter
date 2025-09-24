import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://usuarioapi-nflv.onrender.com";

  // 🔹 Token en memoria (puedes luego moverlo a SharedPreferences)
  static String? token;

  /// LOGIN
  Future<String?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/login");

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final bodyJson = jsonEncode({
      "correo": email,
      "password": password,
    });

    // Debug
    print("LOGIN URL: $url");
    print("Headers: $headers");
    print("Body: $bodyJson");

    final response = await http.post(url, headers: headers, body: bodyJson);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      token = data["token"]; // 🔑 Guardamos el token aquí
      print("Token guardado: $token");
      return token;
    } else {
      throw Exception("Error en login: ${response.body}");
    }
  }

  /// REGISTER
  Future<bool> register(String nombre, String correo, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/registrar");

    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final bodyJson = jsonEncode({
      "nombre": nombre,
      "correo": correo,
      "password": password,
      "estado": 1,
      "idRol": 1
    });

    print("REGISTER URL: $url");
    print("Headers: $headers");
    print("Body: $bodyJson");

    final response = await http.post(url, headers: headers, body: bodyJson);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Registro exitoso: ${response.body}");
      return true;
    } else {
      throw Exception("Error en registro: ${response.body}");
    }
  }
}
