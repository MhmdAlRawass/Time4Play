import 'package:flutter/material.dart';
import 'package:time4play/widgets/gradient_border.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
            labelText: label,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: FloatingLabelBehavior.always
            // border: const OutlineInputBorder(),
            ),
      ),
    );
  }

  // Save Profile Action
  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!")),
    );
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Personal Info",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
                    initialDate: DateTime(1990, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  _dobController.text =
                      "${picked?.day}/${picked?.month}/${picked?.year}";
                                },
              ),
              _buildTextField(label: "Gender", controller: _genderController),
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
              Text(
                "Contact Info",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveProfile,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        tooltip: 'Save Profile',
        child: const Icon(
          Icons.check,
          size: 30,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              _buildUserImageSection(),
              const SizedBox(height: 24),
              _buildPersonalInfoSection(),
              const SizedBox(height: 16),
              _buildContactInfoSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
