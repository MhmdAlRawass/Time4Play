import 'package:flutter/material.dart';

class FeaturedCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  // final double rating;

  const FeaturedCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    // required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkImage =
        image.startsWith('http') || image.startsWith('https');
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: !isNetworkImage ? AssetImage(image) : NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(color: Colors.white70)),
                // const Spacer(),
                // // const Icon(Icons.star, color: Colors.amber, size: 16),
                // // Text(rating.toString(),
                // //     style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
