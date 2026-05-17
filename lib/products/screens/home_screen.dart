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
        title: const Text('Fake Store CRUD'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProductProvider>().loadProducts(),
            tooltip: 'Refresh Products',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final product = await _showProductFormDialog(context);
          if (product != null) {
            await context.read<ProductProvider>().createProduct(product);
            if (context.mounted) {
              final error = context.read<ProductProvider>().errorMessage;
              _showFeedback(context, error ?? 'Product created!');
            }
          }
        },
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              if (provider.isLoading && provider.products.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (provider.errorMessage != null && provider.products.isEmpty)
                Center(child: Text(provider.errorMessage!))
              else
                RefreshIndicator(
                  onRefresh: () => provider.loadProducts(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return ProductTile(product: product);
                    },
                  ),
                ),
              if (provider.isLoading && provider.products.isNotEmpty)
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
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
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.redAccent : Colors.indigo,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12),
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
        title: Text(existing == null ? 'Create Product' : 'Update Product'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Title required' : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Price required';
                    final parsed = double.tryParse(value);
                    if (parsed == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null; // optional
                    if (value.trim().length < 3) return 'Description too short';
                    return null;
                  },
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Category required' : null,
                ),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null; // optional
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
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
            child: Text(existing == null ? 'Create' : 'Update'),
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
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Value required';
              if (value.trim().length > 250) return 'Too long';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: const Text('OK'),
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
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              product.image,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
            ),
          ),
          title: Text(
            product.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.1,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Update (PUT)',
                onPressed: () async {
                  final updated = await _showProductFormDialog(context, existing: product);
                  if (updated != null) {
                    await context.read<ProductProvider>().updateProduct(updated);
                    if (context.mounted) {
                      final error = context.read<ProductProvider>().errorMessage;
                      _showFeedback(context, error ?? 'Product updated successfully!');
                    }
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.auto_fix_high_outlined),
                tooltip: 'Patch',
                onPressed: () async {
                  final newTitle = await _showTextInputDialog(
                    context,
                    title: 'Patch Title',
                    label: 'Title',
                    initialValue: product.title,
                  );
                  if (newTitle != null && newTitle.trim().isNotEmpty) {
                    await context.read<ProductProvider>().patchProduct(
                      product.id!,
                      {'title': newTitle.trim()},
                    );
                    if (context.mounted) {
                      final error = context.read<ProductProvider>().errorMessage;
                      _showFeedback(context, error ?? 'Product title patched!');
                    }
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                tooltip: 'Delete',
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Product'),
                      content: Text('Delete "${product.title}"? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await context.read<ProductProvider>().deleteProduct(product.id!);
                    if (context.mounted) {
                      final error = context.read<ProductProvider>().errorMessage;
                      _showFeedback(context, error ?? 'Product deleted');
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
