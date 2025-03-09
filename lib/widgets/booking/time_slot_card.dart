import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time4play/widgets/gradient_border.dart';

class TimeSlotCard extends StatelessWidget {
  const TimeSlotCard({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final timeFormatted = DateFormat('HH:mm').format(date);
    final size = MediaQuery.of(context).size;
    return GradientBorderContainer(
      rightColor: Colors.redAccent,
      leftColor: const Color.fromARGB(255, 33, 40, 243),
      borderWidth: 2,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        alignment: Alignment.center,
        width: (size.width - 40) / 8,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Text(
          timeFormatted,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
