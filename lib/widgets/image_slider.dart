import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import '../screens/product_details_screen.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      
      setState(() {
        final productService = context.read<ProductService>();
        final products = productService.products;
        if (products.isEmpty) return;
        
        _currentIndex = (_currentIndex + 1) % products.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productService = context.watch<ProductService>();
    final products = productService.products;

    if (products.isEmpty) {
      return const SizedBox(height: 300);
    }

    return Container(
      height: 300,
      color: Colors.grey[900],
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Kép és kattintható terület
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: products[_currentIndex],
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Image.asset(
                        products[_currentIndex].images[0],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            color: Colors.grey[800],
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.white54, size: 64),
                                SizedBox(height: 16),
                                Text(
                                  'Kép betöltése sikertelen',
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                        cacheHeight: 600,
                        cacheWidth: 600,
                      ),
                    ),
                  ),
                ),
                
                // Navigációs gombok
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filled(
                      onPressed: () {
                        setState(() {
                          _currentIndex = (_currentIndex - 1) % products.length;
                          if (_currentIndex < 0) _currentIndex = products.length - 1;
                        });
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        setState(() {
                          _currentIndex = (_currentIndex + 1) % products.length;
                        });
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                // Termék neve
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            product: products[_currentIndex],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: Colors.black54,
                      child: Text(
                        products[_currentIndex].name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Indikátor pontok
          Container(
            height: 40,
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                products.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 