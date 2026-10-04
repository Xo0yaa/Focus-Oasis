import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Audio & Sound',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          
          // Ambient Sound Volume Slider
          ListTile(
            leading: const Icon(Icons.volume_up_outlined),
            title: const Text('Ambient Volume'),
            subtitle: Slider(
              value: _volume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: '${(_volume * 100).round()}%',
              onChanged: (val) => setState(() => _volume = val),
            ),
          ),
        ],
      ),
    );
  }
}