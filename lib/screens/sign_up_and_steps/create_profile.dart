import 'package:flutter/material.dart';
import 'package:time4play/screens/sign_up_and_steps/contact_info.dart';
import 'package:time4play/screens/sign_up_and_steps/finished_settingup.dart';
import 'package:time4play/screens/sign_up_and_steps/personal_info.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  late Size size;
  int stepsCounter = 0;

  void goToNextStep() {
    if (stepsCounter < 2) {
      setState(() {
        stepsCounter++;
      });
      print(stepsCounter);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    List<Widget> steps = [
      PersonalInfoPage(goToNextStep: goToNextStep),
      ContactInfoPage(goToNextStep: goToNextStep),
      FinishedProfile(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Theme.of(context).platform == TargetPlatform.iOS
                ? Icons.arrow_back_ios_new
                : Icons.arrow_back,
          ),
          onPressed: () {
            if (stepsCounter > 0) {
              setState(() {
                stepsCounter--;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: steps[stepsCounter]),
          ],
        ),
      ),
    );
  }
}
