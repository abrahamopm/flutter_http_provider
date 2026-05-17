class ApiConstants {
  static const String baseUrl = 'https://reqres.in/api';

  static const String usersEndpoint = '/users';

  static String userById(int id) => '/users/$id';
}