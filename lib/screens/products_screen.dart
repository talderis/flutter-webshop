import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../services/cart_service.dart';
import '../services/favorites_service.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  final String? initialCategory;

  const ProductsScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late String _selectedCategory;
  String _sortBy = 'Népszerű';
  RangeValues _priceRange = const RangeValues(0, 1000000);
  
  final List<String> _sortOptions = [
    'Népszerű',
    'Ár: Növekvő',
    'Ár: Csökkenő',
    'Legújabb',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Összes';
  }

  @override
  Widget build(BuildContext context) {
    final productService = context.watch<ProductService>();
    final cartService = context.watch<CartService>();
    final favoritesService = context.watch<FavoritesService>();

    var products = productService.getProductsByCategory(_selectedCategory);

    // Rendezés
    List<Product> sortedProducts = List.from(products);
    switch (_sortBy) {
      case 'Ár: Növekvő':
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Ár: Csökkenő':
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Legújabb':
        sortedProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      default: // Népszerű
        sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }

    // Árszűrés
    sortedProducts = sortedProducts.where((product) {
      return product.price >= _priceRange.start && 
             product.price <= _priceRange.end;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Termékek'),
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
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Categories.all.length + 1, // +1 az 'Összes' kategóriának
              itemBuilder: (context, index) {
                final category = index == 0 
                    ? 'Összes'
                    : Categories.all[index - 1].name;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: sortedProducts.isEmpty
                ? const Center(
                    child: Text('Nincs találat a megadott szűrési feltételekkel.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: sortedProducts.length,
                    itemBuilder: (context, index) {
                      final product = sortedProducts[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.purple.shade50,
                                      child: Image.asset(
                                        product.images.first,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 150,
                                            width: double.infinity,
                                            color: Colors.grey[200],
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.error_outline, color: Colors.grey[400], size: 40),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Kép betöltése sikertelen',
                                                  style: TextStyle(color: Colors.grey[600]),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        cacheHeight: 300,
                                        cacheWidth: 300,
                                      ),
                                    ),
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
                                  if (product.isOnSale)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Akció',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        if (product.isOnSale) ...[
                                          Text(
                                            '${product.salePrice!.toStringAsFixed(0)} Ft',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${product.price.toStringAsFixed(0)} Ft',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            '${product.price.toStringAsFixed(0)} Ft',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
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
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => const CartScreen(),
                                                      ),
                                                    );
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Szűrés és rendezés',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rendezés',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _sortOptions.map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: _sortBy == option,
                        onSelected: (selected) {
                          setState(() {
                            _sortBy = option;
                          });
                          this.setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Árkategória',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000000,
                    divisions: 100,
                    labels: RangeLabels(
                      '${_priceRange.start.round()} Ft',
                      '${_priceRange.end.round()} Ft',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                      this.setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Szűrők alkalmazása'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
              width: 50,
              height: 50,
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