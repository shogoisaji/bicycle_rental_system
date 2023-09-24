class Bicycle {
  final String productId;
  final String productName;
  final String description;
  List<dynamic> imageUrls;
  final int pricePerHour;

  Bicycle({
    required this.productId,
    required this.productName,
    required this.description,
    required this.imageUrls,
    required this.pricePerHour,
  });
}
