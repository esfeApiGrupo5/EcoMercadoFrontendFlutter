import 'package:flutter/material.dart';
import 'package:myapp/models/pokemon.dart';
import 'package:myapp/services/pokeapi_service.dart';

// Importamos las nuevas pantallas
import 'login_page.dart';
import 'register_page.dart';
import 'blog_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeAPI App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Cambiamos home por initialRoute
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/pokemon': (context) => const PokemonListScreen(),
        '/blog': (context) => const BlogPage(),
      },
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<Pokemon>> _pokemonList;

  @override
  void initState() {
    super.initState();
    _pokemonList = PokeApiService().fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemonList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('URL')),
                ],
                rows: snapshot.data!.map((pokemon) {
                  return DataRow(
                    cells: [
                      DataCell(Text(pokemon.name)),
                      DataCell(Text(pokemon.url)),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
