import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time4play/widgets/gradient_border.dart';

class TimeSlotCard extends StatelessWidget {
  const TimeSlotCard({
    super.key,
    required this.date,
    required this.selectedTime,
    this.isBooked = false,
  });

  final DateTime date;
  final DateTime selectedTime;
  final bool isBooked;

  @override
  Widget build(BuildContext context) {
    final timeFormatted = DateFormat('HH:mm').format(date);
    final size = MediaQuery.of(context).size;

    final bool isSelected = date.year == selectedTime.year &&
        date.month == selectedTime.month &&
        date.day == selectedTime.day &&
        date.hour == selectedTime.hour &&
        date.minute == selectedTime.minute;

    final backgroundColor = isBooked
        ? Colors.grey.withOpacity(0.3)
        : Theme.of(context).colorScheme.onSecondary.withOpacity(0.2);

    final textStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: isBooked ? Colors.grey.shade500 : Colors.white,
          decoration: isBooked ? TextDecoration.lineThrough : null,
        );

    return GradientBorderContainer(
      rightColor: Colors.redAccent,
      leftColor: const Color.fromARGB(255, 33, 40, 243),
      borderWidth: isSelected && !isBooked ? 1 : 0,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        alignment: Alignment.center,
        width: (size.width - 40) / 8,
        height: 30,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          timeFormatted,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
