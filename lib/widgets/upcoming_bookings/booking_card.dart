import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:time4play/widgets/gradient_border.dart';

class BookingCard extends StatelessWidget {
  final String companyName;
  final String date;
  final String duration;
  final String price;
  final String image;
  final bool isDarkMode;
  final bool isLoading;

  const BookingCard({
    super.key,
    required this.companyName,
    required this.date,
    required this.duration,
    required this.price,
    required this.image,
    required this.isDarkMode,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: isDarkMode ? const Color(0xFF232A3E) : Colors.grey[300]!,
        highlightColor:
            isDarkMode ? const Color(0xFF393E5C) : Colors.grey[100]!,
        child: GradientBorderContainer(
          leftColor: Colors.grey.withOpacity(0.5),
          rightColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          borderWidth: 2,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1D283A)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 15, width: 120, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Container(
                          height: 12, width: 100, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Container(height: 12, width: 80, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GradientBorderContainer(
      leftColor: Colors.grey.withOpacity(0.5),
      rightColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      borderWidth: 2,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF1D283A)
              : Theme.of(context).colorScheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Placeholder(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      date,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "$duration | $price",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
