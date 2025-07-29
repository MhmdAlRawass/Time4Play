import 'package:flutter/material.dart';

class AreaCard extends StatelessWidget {
  final String value;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkMode;

  const AreaCard({
    super.key,
    required this.value,
    this.isSelected = false,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : theme.primaryColor.withOpacity(0.4),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          value,
          style: TextStyle(
            color: isDarkMode
                ? isSelected
                    ? Colors.white
                    : Colors.grey[600]
                : isSelected
                    ? Colors.black
                    : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
