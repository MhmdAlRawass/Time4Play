import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time4play/widgets/gradient_border.dart';

class TimeSlotCard extends StatelessWidget {
  const TimeSlotCard({
    super.key,
    required this.date,
    required this.selectedTime,
  });

  final DateTime date;
  final DateTime selectedTime;

  @override
  Widget build(BuildContext context) {
    final timeFormatted = DateFormat('HH:mm').format(date);
    final size = MediaQuery.of(context).size;
    bool isSelected = date.year == selectedTime.year &&
        date.month == selectedTime.month &&
        date.day == selectedTime.day &&
        date.hour == selectedTime.hour &&
        date.minute == selectedTime.minute;
    return GradientBorderContainer(
      rightColor: Colors.redAccent,
      leftColor: const Color.fromARGB(255, 33, 40, 243),
      borderWidth: isSelected ? 1 : 0,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        alignment: Alignment.center,
        width: (size.width - 40) / 8,
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(18),
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
