import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'services/cart_service.dart';
import 'services/favorites_service.dart';
import 'services/product_service.dart';
import 'services/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/settings_service.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => FavoritesService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => SettingsService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Webshop',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.purple.shade300,
          secondary: Colors.deepPurple.shade300,
          tertiary: Colors.purple.shade200,
          surface: const Color(0xFF1E1E1E),
          surfaceContainer: const Color(0xFF121212),
          surfaceContainerHighest: Colors.deepPurple.shade900.withAlpha(128),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        chipTheme: ChipThemeData(
          selectedColor: Colors.purple.shade300,
          backgroundColor: Colors.deepPurple.shade900.withAlpha(77),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.purple.shade300.withAlpha(77),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigator(),
        '/login': (context) => const LoginScreen(),
        '/products': (context) => const ProductsScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = List.unmodifiable([
    const HomeScreen(),
    const ProductsScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ]);

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Főoldal',
          ),
          const NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Termékek',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text(cartService.itemCount.toString()),
              isLabelVisible: cartService.itemCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              label: Text(cartService.itemCount.toString()),
              isLabelVisible: cartService.itemCount > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Kosár',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class Termek {
  final String nev;
  final double ar;
  final String leiras;

  Termek(this.nev, this.ar, this.leiras);
}
