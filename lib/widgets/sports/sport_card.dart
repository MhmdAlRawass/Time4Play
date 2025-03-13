import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time4play/widgets/gradient_border.dart';

class SportCard extends StatelessWidget {
  const SportCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
  });

  final String name;
  final double price;
  final String description;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> imageUrls = {
      'football': 'lib/assets/images/venues/football.jpg',
      'basketball': 'lib/assets/images/venues/basketball.jpeg',
      'padel': 'lib/assets/images/venues/padel.jpg',
    };

    String imageUrl = imageUrls[name.toLowerCase()] ??
        'lib/assets/images/venues/football.jpg';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: GradientBorderContainer(
        rightColor: Colors.redAccent,
        leftColor: const Color.fromARGB(255, 33, 40, 243),
        borderWidth: 2,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      name,
                      style: GoogleFonts.inter(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Starting from',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '\$ ${price.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' / Hr',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {},
                    splashColor: Theme.of(context).colorScheme.primary,
                    focusColor: Theme.of(context).colorScheme.primary,
                    icon: Icon(Icons.favorite_outline),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black38,
                      overlayColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.location_on_outlined),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
