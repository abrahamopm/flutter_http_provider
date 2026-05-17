import 'dart:convert';

import 'package:flutter_http_provider/core/constants/api_constants.dart';
import 'package:flutter_http_provider/features/data/models/user.dart';
import 'package:http/http.dart' as http;

class UserRemoteDatasource {
  UserRemoteDatasource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<List<User>> getUsers({int page = 1}) async {
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}?page=$page'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch users: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final items = decoded['data'] as List<dynamic>;
    return items
        .map((dynamic item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<User> getUserById(int id) async {
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userById(id)}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return User.fromJson(decoded['data'] as Map<String, dynamic>);
  }

  Future<User> createUser(User user) async {
    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return User.fromJson(decoded);
  }

  Future<User> updateUser(User user) async {
    if (user.id == null) {
      throw ArgumentError('User id is required for updates.');
    }

    final response = await _client.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userById(user.id!)}'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return User.fromJson(decoded);
  }

  Future<void> deleteUser(int id) async {
    final response = await _client.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userById(id)}'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }
}