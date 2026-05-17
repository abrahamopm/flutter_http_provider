class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';

  static const String productsEndpoint = '/products';

  static String productById(int id) => '/products/$id';

  static const String productsCategories = '/products/categories';

  static String productsByCategory(String category) => '/products/category/$category';
}