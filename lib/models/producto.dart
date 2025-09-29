class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json["id"],
      nombre: json["nombre"] ?? "Sin nombre",
      descripcion: json["descripcion"] ?? "",
      precio: (json["precio"] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "descripcion": descripcion,
      "precio": precio,
    };
  }
}
