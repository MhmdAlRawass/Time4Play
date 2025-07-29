import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String user;
  final String comment;
  final double rating;
  final String image;

  const ReviewCard({
    super.key,
    required this.user,
    required this.comment,
    required this.rating,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: isDarkMode
          ? BoxDecoration(
              color: const Color(0xFF1D283A),
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(image),
                radius: 20,
                onBackgroundImageError: (exception, stackTrace) =>
                    const Icon(Icons.person),
              ),
              const SizedBox(width: 8),
              Text(
                user,
                style: TextStyle(
                  color: isDarkMode
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: TextStyle(
              color: isDarkMode
                  ? Colors.white70
                  : Theme.of(context).primaryColor.withOpacity(0.6),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: TextStyle(
                  color: isDarkMode
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
