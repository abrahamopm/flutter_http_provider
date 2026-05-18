import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_http_provider/products/services/product_service.dart';
import 'package:flutter_http_provider/products/providers/product_provider.dart';
import 'package:flutter_http_provider/products/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(
        service: ProductService(client: http.Client()),
      )..loadProducts(),
      child: MaterialApp(
        title: 'Product Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC18C7E),
            brightness: Brightness.light,
            primary: const Color(0xFFC18C7E),
            secondary: const Color(0xFFD4A373),
            surface: Colors.white,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFAF8F5),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 1.5,
            shadowColor: const Color(0xFF2E2A27).withValues(alpha: 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
              color: Color(0xFF2E2A27),
            ),
            iconTheme: IconThemeData(color: Color(0xFF2E2A27)),
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: const Color(0xFFFAF8F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            floatingLabelStyle: const TextStyle(color: Color(0xFFC18C7E)),
            labelStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8E3DD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8E3DD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFC18C7E), width: 1.5),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}