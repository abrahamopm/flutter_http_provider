import 'package:flutter/foundation.dart';
import 'package:flutter_http_provider/features/data/models/user.dart';
import 'package:flutter_http_provider/features/data/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({required UserRepository repository}) : _repository = repository;

  final UserRepository _repository;

  final List<User> _users = <User>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get users => List.unmodifiable(_users);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users
        ..clear()
        ..addAll(await _repository.getUsers());
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}