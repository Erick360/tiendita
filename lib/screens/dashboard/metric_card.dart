import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isLoading;

  const MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            isLoading
                ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2)
            )
                : Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

