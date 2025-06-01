import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Reward')),
      body: Center(
        child: Scratcher(
          brushSize: 40,
          threshold: 50,
          color: Colors.grey,
          onThreshold: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You revealed your reward! 🎉')),
            );
          },
          child: Container(
            height: 200,
            width: 300,
            color: Colors.amber[100],
            alignment: Alignment.center,
            child: const Text(
              '🎁 10% OFF on your next purchase!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
