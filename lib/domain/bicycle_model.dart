class Bicycle {
  final String productId;
  final String productName;
  final String description;
  final int pricePerHour;
  List<dynamic> images;
  //---------------------------------------
  // have 3 images sample
  //
  // images = [
  //   {'filePath': 'oooo','url'='oooo'},
  //   {'filePath': 'oooo','url'='oooo'},
  //   {'filePath': 'oooo','url'='oooo'}
  // ]
  //
  // save format is json
  //---------------------------------------

  Bicycle({
    required this.productId,
    required this.productName,
    required this.description,
    required this.pricePerHour,
    required this.images,
  });
}
