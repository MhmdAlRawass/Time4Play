import 'package:flutter/material.dart';
import '../home/step_tile.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StepTile(
          stepNumber: 1,
          title: "Choose a Venue",
          description: "Browse and select your desired sports venue.",
        ),
        const SizedBox(height: 10),
        const StepTile(
          stepNumber: 2,
          title: "Select Date & Time",
          description: "Pick a suitable time slot that fits your schedule.",
        ),
        const SizedBox(height: 10),
        const StepTile(
          stepNumber: 3,
          title: "Book & Play",
          description: "Confirm your booking and enjoy your game.",
        ),
      ],
    );
  }
}
