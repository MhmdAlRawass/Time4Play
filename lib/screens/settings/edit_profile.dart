import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/providers/customer_provider.dart';
import 'package:time4play/services/customer_service.dart';
import 'package:time4play/widgets/alert_overlay.dart';
import 'package:time4play/widgets/gradient_border.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // Personal Info Controllers
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _personalPhoneController =
      TextEditingController();

  // Contact Info Controllers
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _personalPhoneController.dispose();
    _countryController.dispose();
    _contactPhoneController.dispose();
    _streetNameController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // Reusable text field builder.
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    bool isGender = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: isGender ? false : readOnly,
        onTap: onTap,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: FloatingLabelBehavior.always
            // border: const OutlineInputBorder(),
            ),
      ),
    );
  }

  DateTime _parseDate(String input) {
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {}
    return DateTime.now(); // fallback or handle better
  }

  void _saveProfile() async {
    final customer = ref.watch(customerProvider).value;
    if (customer == null) return;

    try {
      final updatedCustomer = Customer(
        id: customer.id,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        displayName: _displayNameController.text.trim(),
        email: customer.email,
        phoneNumber: _personalPhoneController.text.trim(),
        country: _countryController.text.trim(),
        city: _cityController.text.trim(),
        dateOfBirth: _parseDate(_dobController.text),
        gender: _genderController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
      );

      setState(() {
        _isLoading = true;
      });
      await CustomerService.updateCustomer(updatedCustomer);

      setState(() {
        _isLoading = false;
      });

      AlertOverlay.show(
        context,
        'Profile updated successfully',
        isError: false,
      );
    } catch (e) {
      AlertOverlay.show(
        context,
        'Error occured while updating profile',
        isError: true,
      );
    }
  }

  // Build User Image Section with a modern gradient border and edit icon.
  Widget _buildUserImageSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.blueAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('lib/assets/images/profile_default.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt,
                    size: 20, color: Theme.of(context).primaryColor),
                onPressed: () {
                  // Implement image picker functionality here
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  // Build Personal Info Container
  Widget _buildPersonalInfoSection() {
    return GradientBorderContainer(
      leftColor: Colors.grey.withOpacity(0.5),
      rightColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      borderWidth: 1,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Personal Info",
              //   style: Theme.of(context)
              //       .textTheme
              //       .titleMedium
              //       ?.copyWith(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),
              _buildTextField(
                  label: "Display Name", controller: _displayNameController),
              _buildTextField(
                  label: "First Name", controller: _firstNameController),
              _buildTextField(
                  label: "Last Name", controller: _lastNameController),
              _buildTextField(
                label: "Date of Birth",
                controller: _dobController,
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now().subtract(const Duration(days: 365 * 18)),
                    firstDate: _dobController.text.isNotEmpty
                        ? DateTime.parse(_dobController.text)
                        : DateTime.now()
                            .subtract(const Duration(days: 365 * 18)),
                    lastDate: DateTime.now(),
                  );
                  _dobController.text =
                      "${picked?.day}/${picked?.month}/${picked?.year}";
                },
              ),
              _buildTextField(
                label: "Gender",
                controller: _genderController,
                isGender: true,
                readOnly: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: 200,
                          // color: Theme.of(context).scaffoldBackgroundColor,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  title: const Text("Male"),
                                  onTap: () {
                                    _genderController.text = 'Male';
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text("Female"),
                                  onTap: () {
                                    _genderController.text = 'Female';
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text("N/A"),
                                  onTap: () {
                                    _genderController.text = 'N/A';
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              _buildTextField(
                label: "Phone Number",
                controller: _personalPhoneController,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Contact Info Container
  Widget _buildContactInfoSection() {
    return GradientBorderContainer(
      leftColor: Colors.grey.withOpacity(0.5),
      rightColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      borderWidth: 1,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Contact Info",
              //   style: Theme.of(context)
              //       .textTheme
              //       .titleMedium
              //       ?.copyWith(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),
              _buildTextField(
                  label: "Country of Residence",
                  controller: _countryController),
              _buildTextField(
                label: "Phone Number",
                controller: _contactPhoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                  label: "Street Name", controller: _streetNameController),
              _buildTextField(
                  label: "Postal Code", controller: _postalCodeController),
              _buildTextField(label: "City", controller: _cityController),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerAsync = ref.watch(customerProvider);

    return customerAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error loading customer: $error')),
      ),
      data: (customer) {
        // Populate controllers once
        if (_displayNameController.text.isEmpty) {
          _displayNameController.text = customer.displayName;
          _firstNameController.text = customer.firstName;
          _lastNameController.text = customer.lastName;
          _dobController.text =
              "${customer.dateOfBirth.day}/${customer.dateOfBirth.month}/${customer.dateOfBirth.year}";
          _genderController.text = customer.gender;
          _personalPhoneController.text = customer.phoneNumber;

          _countryController.text = customer.country;
          _contactPhoneController.text = customer.phoneNumber;
          _cityController.text = customer.city;
          // Optionally add street/postal if added to model
        }

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text("Edit Profile"),
                centerTitle: true,
                elevation: 0.5,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              body: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).colorScheme.surface.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Personal Info"),
                        _buildPersonalInfoSection(),
                        const SizedBox(height: 20),
                        _buildSectionHeader("Contact Info"),
                        _buildContactInfoSection(),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }

// Cleaner section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
