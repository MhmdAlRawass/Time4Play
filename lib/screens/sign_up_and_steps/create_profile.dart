import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time4play/screens/login/login_screen.dart';
import 'package:time4play/screens/sign_up_and_steps/contact_info.dart';
import 'package:time4play/screens/sign_up_and_steps/creating_profile_screen.dart';
import 'package:time4play/screens/sign_up_and_steps/finished_settingup.dart';
import 'package:time4play/screens/sign_up_and_steps/personal_info.dart';
import 'package:time4play/services/logout_service.dart';
import 'package:time4play/widgets/alert_overlay.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({
    super.key,
    this.emailController,
    this.passwordController,
    this.isGoogleSignIn = false,
    this.userId,
  });

  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final bool isGoogleSignIn;
  final String? userId;

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  late Size size;
  int stepsCounter = 0;
  // First Page
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  // Second Page
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  DateTime? dateOfBirth;

  bool _isLoading = false;

  void goToNextStep() {
    if (stepsCounter < 2) {
      setState(() {
        stepsCounter++;
      });
    }
  }

  void goToNextStepAndSignUp() {
    setState(() {
      _isLoading = true;
    });
    signUpToFirestore();
  }

  void signUpToFirestore() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    try {
      if (widget.isGoogleSignIn) {
        // Handle Google Sign-In
        await firestore.collection('customer').doc(widget.userId).set({
          'id': widget.userId,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'displayName': displayNameController.text,
          'dateOfBirth':
              Timestamp.fromDate(dateOfBirth ?? DateTime.now()), // Timestamp
          'country': countryController.text,
          'phoneNumber': phoneController.text,
          'streetAddress': streetController.text,
          'postalCode': postalCodeController.text,
          'city': cityController.text,
          'email': widget.emailController!.text,
          'gender' : genderController.text,
        });
      } else {
        // Regular email/password sign-up
        await auth.createUserWithEmailAndPassword(
          email: widget.emailController!.text,
          password: widget.passwordController!.text,
        );
        await firestore.collection('customer').doc(auth.currentUser!.uid).set({
          'id': auth.currentUser!.uid,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'displayName': displayNameController.text,
          'dateOfBirth':
              Timestamp.fromDate(dateOfBirth ?? DateTime.now()), // Timestamp
          'country': countryController.text,
          'phoneNumber': phoneController.text,
          'streetAddress': streetController.text,
          'postalCode': postalCodeController.text,
          'city': cityController.text,
          'email': widget.emailController!.text,
        });
      }

      setState(() {
        _isLoading = false;
        stepsCounter = 3;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AlertOverlay.show(
        context,
        e.toString(),
        duration: const Duration(seconds: 3),
      );
      print('Sign Up Error :$e');
    }
  }

  @override
  void initState() {
    super.initState();
    final picked = DateTime.now();
    dateController.text = "Select Date";
    // dateController.text = "${picked.day}/${picked.month}/${picked.year}";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    displayNameController.dispose();
    dateController.dispose();
    countryController.dispose();
    phoneController.dispose();
    streetController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    List<Widget> steps = [
      PersonalInfoPage(
        goToNextStep: goToNextStep,
        firstNameController: firstNameController,
        lastNameController: lastNameController,
        displayNameController: displayNameController,
        dateController: dateController,
        onDateSelected: (date) {
          setState(() {
            dateOfBirth = date;
          });
        },
        genderController: genderController,
      ),
      ContactInfoPage(
        goToNextStep: goToNextStepAndSignUp,
        countryController: countryController,
        phoneController: phoneController,
        streetController: streetController,
        postalCodeController: postalCodeController,
        cityController: cityController,
      ),
    ];

    if (_isLoading) {
      return const Scaffold(
        body: CreatingProfileScreen(),
      );
    }

    if (stepsCounter == 3) {
      return const Scaffold(
        body: FinishedProfile(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: widget.isGoogleSignIn && stepsCounter == 0
            ? null
            : IconButton(
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
            Expanded(
              child: steps[stepsCounter],
            ),
          ],
        ),
      ),
      floatingActionButton: widget.isGoogleSignIn
          ? FloatingActionButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                LogoutService().logout();
                await GoogleSignIn().signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
                setState(() {
                  _isLoading = false;
                });
              },
              child: Icon(
                Icons.logout,
              ),
            )
          : null,
    );
  }
}
