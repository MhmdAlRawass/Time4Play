import 'package:flutter/material.dart';
import 'package:time4play/widgets/gradient_border.dart';

class BookingCard extends StatelessWidget {
  final String companyName;
  final String date;
  final String duration;
  final String price;
  final String image;

  const BookingCard({
    super.key,
    required this.companyName,
    required this.date,
    required this.duration,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      leftColor: Colors.grey.withOpacity(0.5),
      rightColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      borderWidth: 2,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1D283A),
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
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(date, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 5),
                    Text("$duration | $price",
                        style: const TextStyle(color: Colors.white70)),
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
