import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../services/favorites_service.dart';
import 'product_details_screen.dart';
import 'products_screen.dart';
import '../widgets/image_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final productService = context.watch<ProductService>();
    final cartService = context.watch<CartService>();
    final favoritesService = context.watch<FavoritesService>();
    final onSaleProducts = productService.onSaleProducts;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Modern Webshop'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.shopping_bag,
                        size: 80,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(productService: productService),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductsScreen(
                        initialCategory: 'Kedvencek',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ImageSlider(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Kategóriák',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: Categories.all.length,
                    itemBuilder: (context, index) {
                      final category = Categories.all[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsScreen(
                                  initialCategory: category.name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.primary.withAlpha(204),
                                  Theme.of(context).colorScheme.secondary.withAlpha(204),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    category.icon,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Akciós termékek',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: onSaleProducts.length,
                      itemBuilder: (context, index) {
                        final product = onSaleProducts[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: SizedBox(
                            width: 200,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.purple.shade50,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(
                                        product: product,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Image.asset(
                                          product.images[0],
                                          height: 150,
                                          width: 200,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 150,
                                              width: 200,
                                              color: Colors.grey[200],
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.error_outline, color: Colors.grey[400], size: 40),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Kép betöltése sikertelen',
                                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          cacheHeight: 300,
                                          cacheWidth: 300,
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: IconButton(
                                            icon: Icon(
                                              favoritesService.isFavorite(product.id)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: favoritesService.isFavorite(product.id)
                                                  ? Colors.red
                                                  : null,
                                            ),
                                            onPressed: () {
                                              favoritesService.toggleFavorite(product);
                                            },
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.purple.shade50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '${product.price.toStringAsFixed(0)} Ft',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (product.salePrice != null) ...[
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${product.salePrice!.toStringAsFixed(0)} Ft',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    decoration: TextDecoration.lineThrough,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    size: 16,
                                                    color: Colors.amber,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    product.rating.toString(),
                                                    style: const TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add_shopping_cart),
                                                onPressed: () {
                                                  cartService.addItem(product);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        '${product.name} hozzáadva a kosárhoz',
                                                      ),
                                                      action: SnackBarAction(
                                                        label: 'Kosár megtekintése',
                                                        onPressed: () {
                                                          Navigator.of(context).pushNamed('/cart');
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: IconButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  final ProductService productService;

  ProductSearchDelegate({required this.productService});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Kezdj el gépelni a kereséshez...'),
      );
    }

    final results = productService.searchProducts(query);

    if (results.isEmpty) {
      return const Center(
        child: Text('Nincs találat'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(4),
            color: Colors.purple.shade50,
            child: Image.asset(
              product.images[0],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
              cacheHeight: 100,
              cacheWidth: 100,
            ),
          ),
          title: Text(product.name),
          subtitle: Text('${product.price.toStringAsFixed(0)} Ft'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }
} 