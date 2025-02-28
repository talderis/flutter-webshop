import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import 'order_details_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = context.watch<UserService>();
    final orders = userService.currentUser?.orderHistory ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendeléseim'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Még nincs rendelésed',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text('Rendelés #${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dátum: ${order.date.toString().substring(0, 10)}',
                        ),
                        Text(
                          'Összeg: ${order.total.toStringAsFixed(0)} Ft',
                        ),
                        Text(
                          'Státusz: ${order.status}',
                          style: TextStyle(
                            color: order.status == 'Teljesítve'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
                            order: order,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
} 