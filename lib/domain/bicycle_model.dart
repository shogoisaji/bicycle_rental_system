class Bicycle {
  final String id;
  final String name;
  final String description;
  final String image;
  final int price;

  Bicycle({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });

  factory Bicycle.fromJson(Map<String, dynamic> json) {
    return Bicycle(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
    );
  }
}
