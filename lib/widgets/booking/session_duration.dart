import 'package:flutter/material.dart';

class SessionDuration extends StatefulWidget {
  const SessionDuration({super.key});

  @override
  _SessionDurationState createState() => _SessionDurationState();
}

class _SessionDurationState extends State<SessionDuration> {
  int selectedIndex = 0;
  final List<String> durations = ['60 min', '90 min', '120 min'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black38,
      ),
      child: Row(
        children: List.generate(durations.length, (index) {
          final isSelected = index == selectedIndex;
          BorderRadius radius = BorderRadius.circular(0);
          if (index == 0) {
            radius = BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            );
          } else if (index == 2) {
            radius = BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            );
          } else if (index == 1) {
            radius = BorderRadius.circular(0);
          }
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: radius,
                ),
                child: Center(
                  child: Text(
                    durations[index],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : null),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
