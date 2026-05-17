class Rating {
  const Rating({
    required this.rate,
    required this.count,
  });

  final double rate;
  final int count;

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] is num) ? (json['rate'] as num).toDouble() : 0.0,
      count: (json['count'] is int) ? json['count'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'rate': rate,
      'count': count,
    };
  }
}

class Product {
  const Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
  });

  final int? id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] is int) ? json['id'] as int : null,
      title: json['title']?.toString() ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      rating: json['rating'] != null ? Rating.fromJson(json['rating'] as Map<String, dynamic>) : null,
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
      if (rating != null) 'rating': rating!.toJson(),
    };
  }
}
