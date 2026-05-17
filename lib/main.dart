import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_http_provider/core/network/http_provider.dart';
import 'package:flutter_http_provider/features/data/datasources/product_remote_datasource.dart';
import 'package:flutter_http_provider/features/data/repositories/product_repository.dart';
import 'package:flutter_http_provider/features/presentation/providers/product_provider.dart';
import 'package:flutter_http_provider/features/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpProvider = HttpProvider();

    return ChangeNotifierProvider(
      create: (_) => ProductProvider(
        repository: ProductRepository(
          remoteDatasource: ProductRemoteDatasource(client: httpProvider.client),
        ),
      )..loadProducts(),
      child: MaterialApp(
        title: 'Product Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}