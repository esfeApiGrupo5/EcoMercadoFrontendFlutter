import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/pokemon.dart';

class PokeApiService {
  final String _baseUrl = "https://pokeapi.co/api/v2/pokemon?limit=20";

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> results = data['results'];
      return results.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pokemon');
    }
  }
}
