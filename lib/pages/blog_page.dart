import 'package:flutter/material.dart';
import 'package:myapp/services/blog_service.dart';
import 'blog_detail_page.dart';

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
      appBar: AppBar(
        title: const Text("EcoMercado - Blogs"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔍 Buscador
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Buscar blogs...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // 📑 Lista de blogs
                Expanded(
                  child: _filteredBlogs.isEmpty
                      ? const Center(child: Text("No hay blogs disponibles"))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80), // 👈 espacio extra para scroll
                          itemCount: _filteredBlogs.length,
                          itemBuilder: (context, index) {
                            final blog = _filteredBlogs[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 📝 Título
                                    Text(
                                      blog["titulo"] ?? "Sin título",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),

                                    // 📄 Contenido reducido
                                    Text(
                                      blog["contenido"] ?? "Sin contenido",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // 🔘 Botón "Ver detalles"
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BlogDetailPage(blog: blog),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.read_more),
                                        label: const Text("Ver detalles"),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
    );
  }
}
