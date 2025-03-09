import 'package:flutter/material.dart';

class StepTile extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;

  const StepTile({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.blue.shade800,
          child: Text(
            stepNumber.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Text(description, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ],
    );
  }
}
