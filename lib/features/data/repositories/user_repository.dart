import 'package:flutter_http_provider/features/data/datasources/user_remote_datasource.dart';
import 'package:flutter_http_provider/features/data/models/user.dart';

class UserRepository {
  UserRepository({required UserRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  final UserRemoteDatasource _remoteDatasource;

  Future<List<User>> getUsers({int page = 1}) => _remoteDatasource.getUsers(page: page);

  Future<User> getUserById(int id) => _remoteDatasource.getUserById(id);

  Future<User> createUser(User user) => _remoteDatasource.createUser(user);

  Future<User> updateUser(User user) => _remoteDatasource.updateUser(user);

  Future<void> deleteUser(int id) => _remoteDatasource.deleteUser(id);
}