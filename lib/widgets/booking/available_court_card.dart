import 'package:flutter/material.dart';
import 'package:time4play/widgets/gradient_border.dart';

class AvailableCourtCard extends StatelessWidget {
  const AvailableCourtCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      rightColor: Colors.redAccent,
      leftColor: const Color.fromARGB(255, 33, 40, 243),
      borderWidth: 2,
      child: Container(
        padding: EdgeInsets.all(12),
        width: double.infinity,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'court 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Indoor',
                  style: TextStyle(
                      // fontSize: 1,
                      ),
                ),
                Row(
                  children: [
                    Text(
                      '22:00 - 23:30',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '(90 mins)',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  '\$ 48.00',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
