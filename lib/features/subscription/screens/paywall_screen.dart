import 'package:flutter/material.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BASELINE PULSE PRO')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Premium Feature'),
            SizedBox(height: 8),
            Text('Unlock advanced analytics, cloud sync controls, and export tools.'),
          ],
        ),
      ),
    );
  }
}
