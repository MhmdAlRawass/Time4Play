import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time4play/widgets/gradient_border.dart';

class DateCard extends StatelessWidget {
  const DateCard({
    super.key,
    required this.date,
    required this.selectedDate,
  });

  final DateTime date;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final dayOfMonth = DateFormat('EEE').format(date);
    final month = DateFormat('MMM').format(date);
    bool isSelected = date.day == selectedDate.day;
    return Column(
      children: [
        GradientBorderContainer(
          rightColor: Colors.redAccent,
          leftColor: const Color.fromARGB(255, 33, 40, 243),
          borderWidth: isSelected ? 1 : 0,
          child: Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.4),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dayOfMonth.toUpperCase(),
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: GoogleFonts.inter().fontStyle,
                  ),
                ),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    fontStyle: GoogleFonts.inter().fontStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          month,
          style: TextStyle(
            // color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 14,
            // fontWeight: FontWeight.w500,
            fontStyle: GoogleFonts.inter().fontStyle,
          ),
        )
      ],
    );
  }
}
