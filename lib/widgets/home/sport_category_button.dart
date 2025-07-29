import 'package:flutter/material.dart';

class SportCategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const SportCategoryButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      decoration: isDarkMode
          ? BoxDecoration(
              color: const Color(0xFF1D283A),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    // offset: Offset(0, 2),
                  ),
                ])
          : BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
            ),
      child: TextButton(
        onPressed: null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isDarkMode
                  ? Theme.of(context).colorScheme.onPrimary.withOpacity(1)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.9),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.6)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
