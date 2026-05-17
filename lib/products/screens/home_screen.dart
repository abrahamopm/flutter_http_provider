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
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.products.isEmpty) {
            return Center(child: Text(provider.errorMessage!));
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadProducts(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ProductTile(product: product);
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: Image.network(
            product.image,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
          ),
        ),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('\$${product.price} - ${product.category}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              tooltip: 'Update (PUT)',
              onPressed: () {
                final updatedProduct = Product(
                  id: product.id,
                  title: '${product.title} (Updated)',
                  price: product.price,
                  description: product.description,
                  category: product.category,
                  image: product.image,
                );
                context.read<ProductProvider>().updateProduct(updatedProduct);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product Updated (PUT)')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.auto_fix_high, size: 20),
              tooltip: 'Patch',
              onPressed: () {
                context.read<ProductProvider>().patchProduct(
                  product.id!,
                  {'title': '${product.title} (Patched)'},
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product Patched')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              tooltip: 'Delete',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Product'),
                    content: const Text('Are you sure you want to delete this product?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && context.mounted) {
                  context.read<ProductProvider>().deleteProduct(product.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product Deleted')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
