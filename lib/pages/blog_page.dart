import 'package:flutter/material.dart';
import 'package:myapp/services/blog_service.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final BlogService _blogService = BlogService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _blogs = [];
  List<dynamic> _filteredBlogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBlogs();
    _searchController.addListener(_onSearch);
  }

  void _loadBlogs() async {
    try {
      final blogs = await _blogService.fetchBlogs();
      setState(() {
        _blogs = blogs;
        _filteredBlogs = blogs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error cargando blogs: $e");
    }
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBlogs = _blogs.where((blog) {
        final titulo = blog["titulo"].toString().toLowerCase();
        final contenido = blog["contenido"].toString().toLowerCase();
        return titulo.contains(query) || contenido.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blogs")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: "Buscar",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredBlogs.isEmpty
                      ? const Center(child: Text("No hay blogs"))
                      : ListView.builder(
                          itemCount: _filteredBlogs.length,
                          itemBuilder: (context, index) {
                            final blog = _filteredBlogs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ListTile(
                                title: Text(blog["titulo"] ?? "Sin título"),
                                subtitle: Text(
                                  blog["contenido"] ?? "Sin contenido",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
