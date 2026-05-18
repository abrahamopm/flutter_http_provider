import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_http_provider/products/providers/product_provider.dart';
import 'package:flutter_http_provider/products/models/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Fakestore',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: Color(0xFF2E2A27),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFC18C7E).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFC18C7E).withValues(alpha: 0.3)),
              ),
              child: const Text(
                'PROVIDER',
                style: TextStyle(
                  color: Color(0xFFC18C7E),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<ProductProvider>().loadProducts(),
            tooltip: 'Refresh Products',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC18C7E),
        foregroundColor: Colors.white,
        elevation: 4,
        onPressed: () async {
          final product = await _showProductFormDialog(context);
          if (product != null && context.mounted) {
            final provider = context.read<ProductProvider>();
            await provider.createProduct(product);
            if (context.mounted) {
              final error = provider.errorMessage;
              _showFeedback(context, error ?? 'Product created successfully!');
            }
          }
        },
        tooltip: 'Add Product',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              if (provider.products.isEmpty && !provider.isLoading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E2A27).withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 64),
                        const SizedBox(height: 12),
                        const Text(
                          'No products found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (provider.errorMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.loadProducts(),
                          child: const Text('Reload'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                RefreshIndicator(
                  color: const Color(0xFFC18C7E),
                  onRefresh: () => provider.loadProducts(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return ProductTile(product: product);
                    },
                  ),
                ),
              if (provider.isLoading)
                Positioned.fill(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: const Color(0xFFFAF8F5).withValues(alpha: 0.5),
                        child: const Center(
                          child: _SkeletonProductLoader(),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

void _showFeedback(BuildContext context, String message, {bool isError = false}) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
            color: isError ? Colors.redAccent : const Color(0xFFC18C7E),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF2E2A27),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isError ? Colors.redAccent.withValues(alpha: 0.2) : const Color(0xFFC18C7E).withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.all(16),
    ),
  );
}

Future<Product?> _showProductFormDialog(BuildContext context, {Product? existing}) {
  final titleController = TextEditingController(text: existing?.title ?? '');
  final priceController = TextEditingController(text: existing != null ? existing.price.toString() : '');
  final descriptionController = TextEditingController(text: existing?.description ?? '');
  final categoryController = TextEditingController(text: existing?.category ?? '');
  final imageController = TextEditingController(text: existing?.image ?? '');

  final formKey = GlobalKey<FormState>();

  return showDialog<Product?>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          existing == null ? 'Create Product' : 'Update Product',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF2E2A27)),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title', hintText: 'Enter title'),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Title required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price', hintText: 'Enter price'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Price required';
                    final parsed = double.tryParse(value);
                    if (parsed == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description', hintText: 'Enter description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (value.trim().length < 3) return 'Description too short';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category', hintText: 'Enter category'),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Category required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL', hintText: 'Enter image http(s) URL'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final uri = Uri.tryParse(value.trim());
                    if (uri == null || !(uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https'))) {
                      return 'Enter a valid http(s) URL';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC18C7E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final title = titleController.text.trim();
                final price = double.parse(priceController.text.trim());
                final description = descriptionController.text.trim();
                final category = categoryController.text.trim();
                final image = imageController.text.trim();

                final result = Product(
                  id: existing?.id,
                  title: title,
                  price: price,
                  description: description,
                  category: category,
                  image: image.isNotEmpty ? image : (existing?.image ?? ''),
                  rating: existing?.rating,
                );

                Navigator.of(context).pop(result);
              }
            },
            child: Text(existing == null ? 'Create' : 'Update', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}

Future<String?> _showTextInputDialog(
  BuildContext context, {
  required String title,
  required String label,
  String? initialValue,
}) {
  final controller = TextEditingController(text: initialValue ?? '');
  final formKey = GlobalKey<FormState>();

  return showDialog<String?>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2E2A27))),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: label, hintText: 'Enter new value'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Value required';
              if (value.trim().length > 250) return 'Too long';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC18C7E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E2A27).withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A373).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFD4A373).withValues(alpha: 0.25)),
                        ),
                        child: Text(
                          product.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            letterSpacing: 1.0,
                            color: Color(0xFFC18C7E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (product.rating != null) ...[
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFD4A373), size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${product.rating!.rate}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E2A27),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2E2A27),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFC18C7E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: Color(0xFFC18C7E), size: 20),
                  tooltip: 'Update (PUT)',
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFC18C7E).withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final updated = await _showProductFormDialog(context, existing: product);
                    if (updated != null && context.mounted) {
                      final provider = context.read<ProductProvider>();
                      await provider.updateProduct(updated);
                      if (context.mounted) {
                        final error = provider.errorMessage;
                        _showFeedback(context, error ?? 'Product updated successfully!');
                      }
                    }
                  },
                ),
                const SizedBox(height: 6),
                IconButton(
                  icon: const Icon(Icons.auto_fix_high_rounded, color: Color(0xFFD4A373), size: 20),
                  tooltip: 'Patch Title',
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A373).withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final newTitle = await _showTextInputDialog(
                      context,
                      title: 'Patch Title',
                      label: 'Title',
                      initialValue: product.title,
                    );
                    if (newTitle != null && newTitle.trim().isNotEmpty && context.mounted) {
                      final provider = context.read<ProductProvider>();
                      await provider.patchProduct(
                        product.id!,
                        {'title': newTitle.trim()},
                      );
                      if (context.mounted) {
                        final error = provider.errorMessage;
                        _showFeedback(context, error ?? 'Product title patched successfully!');
                      }
                    }
                  },
                ),
                const SizedBox(height: 6),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                  tooltip: 'Delete',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Product'),
                        content: Text('Delete "${product.title}"? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      final provider = context.read<ProductProvider>();
                      await provider.deleteProduct(product.id!);
                      if (context.mounted) {
                        final error = provider.errorMessage;
                        _showFeedback(context, error ?? 'Product deleted');
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonProductLoader extends StatefulWidget {
  const _SkeletonProductLoader();

  @override
  State<_SkeletonProductLoader> createState() => _SkeletonProductLoaderState();
}

class _SkeletonProductLoaderState extends State<_SkeletonProductLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0ECE6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0ECE6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0ECE6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0ECE6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
