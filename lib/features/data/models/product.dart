class Product {
  const Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  final int? id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] is int) ? json['id'] as int : (json['id']?.toString() != null ? int.tryParse(json['id'].toString()) : null),
      title: json['title']?.toString() ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      
    };
  }
}
