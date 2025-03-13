import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time4play/widgets/gradient_border.dart';

class AvailableCourtCard extends StatelessWidget {
  const AvailableCourtCard({
    super.key,
    required this.timeSlot,
    required this.selectedDuration,
    required this.courtName,
    required this.isIndoor,
  });

  final DateTime timeSlot;
  final int selectedDuration;
  final String courtName;
  final bool isIndoor;

  @override
  Widget build(BuildContext context) {
    final startTime = timeSlot;
    final endTime = timeSlot.add(Duration(minutes: selectedDuration));

    final startTimeFormatted = DateFormat('HH:mm').format(startTime);
    final endTimeFormatted = DateFormat('HH:mm').format(endTime);

    final textTimeFormatted = '$startTimeFormatted - $endTimeFormatted';

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
                  courtName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isIndoor ? 'Indoor ☂️' : 'Outdoor ☀️',
                  style: TextStyle(
                      // fontSize: 1,
                      ),
                ),
                Row(
                  children: [
                    Text(
                      textTimeFormatted,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '($selectedDuration mins)',
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
