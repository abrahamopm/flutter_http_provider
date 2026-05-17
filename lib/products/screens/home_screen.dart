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
        onPressed: () {
          const mockProduct = Product(
            title: 'New Product',
            price: 29.99,
            description: 'A newly added mock product',
            category: 'electronics',
            image: 'https://i.pravatar.cc/150?u=mock',
          );
          context.read<ProductProvider>().createProduct(mockProduct);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Creating Mock Product...')),
          );
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

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

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
                  final updatedProduct = Product(
                    id: product.id,
                    title: '${product.title} (Updated)',
                    price: product.price,
                    description: product.description,
                    category: product.category,
                    image: product.image,
                  );
                  await context.read<ProductProvider>().updateProduct(updatedProduct);
                  if (context.mounted) {
                    final error = context.read<ProductProvider>().errorMessage;
                    _showFeedback(context, error ?? 'Product updated successfully!');
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.auto_fix_high_outlined),
                tooltip: 'Patch',
                onPressed: () async {
                  await context.read<ProductProvider>().patchProduct(
                    product.id!,
                    {'title': '${product.title} (Patched)'},
                  );
                  if (context.mounted) {
                    final error = context.read<ProductProvider>().errorMessage;
                    _showFeedback(context, error ?? 'Product title patched!');
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
