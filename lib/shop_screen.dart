import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  final int waterPoints;
  final ValueChanged<int> onWaterPointsChanged;

  const ShopScreen({
    super.key,
    required this.waterPoints,
    required this.onWaterPointsChanged,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  // Available shop items for the Focus Oasis garden
  final List<Map<String, dynamic>> _shopItems = [
    {
      'name': 'Golden Watering Can',
      'description': 'Doubles water points earned per session for 24 hours.',
      'cost': 50,
      'owned': false,
      'icon': Icons.water_drop,
    },
    {
      'name': 'Cherry Blossom Seed',
      'description': 'Unlock a brand-new rare tree species for your garden.',
      'cost': 100,
      'owned': false,
      'icon': Icons.local_florist,
    },
    {
      'name': 'Cozy Lofi Background',
      'description': 'Relaxing rainy window theme for your focus dashboard.',
      'cost': 75,
      'owned': true,
      'icon': Icons.nightlight_round,
    },
    {
      'name': 'Stone Garden Lantern',
      'description': 'An ambient light accessory to decorate your oasis.',
      'cost': 40,
      'owned': false,
      'icon': Icons.wb_incandescent,
    },
  ];

  void _buyItem(int index) {
    final item = _shopItems[index];
    final cost = item['cost'] as int;

    if (item['owned'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already own this item!')),
      );
      return;
    }

    if (widget.waterPoints < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough Water Points! Complete more focus sessions.')),
      );
      return;
    }

    // Deduct points and mark item as owned
    setState(() {
      widget.onWaterPointsChanged(widget.waterPoints - cost);
      _shopItems[index]['owned'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully purchased ${item['name']}!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oasis Shop & Inventory'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          // Header balance summary
          Container(
            padding: const EdgeInsets.all(16.0),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Available Balance', style: theme.textTheme.titleMedium),
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.waterPoints} pts',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _shopItems.length,
              itemBuilder: (context, index) {
                final item = _shopItems[index];
                final isOwned = item['owned'] as bool;
                final cost = item['cost'] as int;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(item['icon'] as IconData, color: theme.colorScheme.primary),
                    ),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(item['description']),
                    ),
                    trailing: ElevatedButton(
                      onPressed: isOwned ? null : () => _buyItem(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOwned ? Colors.grey.shade300 : theme.colorScheme.primary,
                        foregroundColor: isOwned ? Colors.grey.shade700 : Colors.white,
                      ),
                      child: Text(isOwned ? 'Owned' : '$cost pts'),
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
}