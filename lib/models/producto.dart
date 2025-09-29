class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;       
  final String categoria; 
  final String urlImagen; 

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
    required this.urlImagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json["id"],
      nombre: json["nombre"] ?? "Sin nombre",
      descripcion: json["descripcion"] ?? "",
      precio: (json["precio"] ?? 0).toDouble(),
      stock: json["stock"] ?? 0,                
      categoria: json["categoria"] ?? "",       
      urlImagen: json["urlImagen"] ?? "",       
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "descripcion": descripcion,
      "precio": precio,
      "stock": stock,          
      "categoria": categoria,   
      "urlImagen": urlImagen,   
    };
  }
}
