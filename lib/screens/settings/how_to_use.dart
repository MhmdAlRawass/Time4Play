import 'package:flutter/material.dart';
import 'package:time4play/widgets/gradient_border.dart';
import 'package:time4play/widgets/settings/how_it_works_section.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'How It Works',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GradientBorderContainer(
            leftColor: Colors.grey.withOpacity(0.5),
            rightColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            borderWidth: 1,
            child: Container(
              padding: EdgeInsets.all(16).copyWith(right: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HowItWorksSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
