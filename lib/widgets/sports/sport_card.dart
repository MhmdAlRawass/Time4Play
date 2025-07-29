import 'package:flutter/material.dart';
import 'package:time4play/widgets/gradient_border.dart';

class SportCard extends StatelessWidget {
  const SportCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.isDarkMode,
  });

  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
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
                Hero(
                  tag: imageUrl,
                  child: Container(
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
                ),
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      name,
                      style: TextStyle(
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
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '\$ ${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' / Hr',
                            style: TextStyle(
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
                // Positioned(
                //   right: 0,
                //   child: IconButton(
                //     onPressed: () {},
                //     splashColor: Theme.of(context).colorScheme.primary,
                //     focusColor: Theme.of(context).colorScheme.primary,
                //     icon: Icon(Icons.favorite_outline),
                //     style: IconButton.styleFrom(
                //       backgroundColor: Colors.black38,
                //       overlayColor: Theme.of(context).colorScheme.primary,
                //     ),
                //   ),
                // ),
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
