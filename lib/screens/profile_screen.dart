import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'order_history_screen.dart';
import 'products_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = context.watch<UserService>();

    if (!userService.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Nem vagy bejelentkezve',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Bejelentkezés',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final user = userService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: user.profileImage != null
                      ? NetworkImage(user.profileImage!)
                      : null,
                  child: user.profileImage == null
                      ? Text(
                          user.name[0],
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Egyenleg'),
            subtitle: Text(
              '${user.balance.toStringAsFixed(0)} Ft',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: FilledButton.tonal(
              onPressed: () {
                _showBalanceTopUpDialog(context);
              },
              child: const Text('Feltöltés'),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Szállítási cím'),
            subtitle: Text(user.address),
            trailing: const Icon(Icons.edit),
            onTap: () {
              _showEditDialog(
                context: context,
                title: 'Szállítási cím módosítása',
                initialValue: user.address,
                onSave: (value) {
                  userService.updateProfile(address: value);
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Telefonszám'),
            subtitle: Text(user.phoneNumber),
            trailing: const Icon(Icons.edit),
            onTap: () {
              _showEditDialog(
                context: context,
                title: 'Telefonszám módosítása',
                initialValue: user.phoneNumber,
                onSave: (value) {
                  userService.updateProfile(phoneNumber: value);
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Rendeléseim'),
            subtitle: Text('${user.orderHistory.length} rendelés'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Kedvencek'),
            subtitle: Text('${user.favoriteProducts.length} termék'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
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
          ListTile(
            leading: const Icon(Icons.local_offer),
            title: const Text('Kuponjaim'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kupon funkció hamarosan elérhető!'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Adatvédelem'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Adatvédelmi irányelvek'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'Az adatvédelmi irányelvek hamarosan elérhetőek lesznek.',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Rendben'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Segítség'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Segítség'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'Segítség és GYIK hamarosan elérhető.',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Rendben'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Kijelentkezés',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Kijelentkezés'),
                  content: const Text(
                    'Biztosan ki szeretnél jelentkezni?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Mégsem'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        await userService.logout();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Kijelentkezés'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Verzió: 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _showBalanceTopUpDialog(BuildContext context) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Egyenleg feltöltése'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Összeg (Ft)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kérjük, add meg az összeget';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Kérjük, adj meg egy érvényes összeget';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mégsem'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final amount = double.parse(controller.text);
                context.read<UserService>().addToBalance(amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Sikeresen feltöltöttél ${amount.toStringAsFixed(0)} Ft-ot',
                    ),
                  ),
                );
              }
            },
            child: const Text('Feltöltés'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required void Function(String) onSave,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ez a mező kötelező';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mégsem'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onSave(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Mentés'),
          ),
        ],
      ),
    );
  }
} 