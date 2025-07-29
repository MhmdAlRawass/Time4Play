import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({
    super.key,
    required this.goToNextStep,
    required this.firstNameController,
    required this.lastNameController,
    required this.displayNameController,
    required this.dateController,
    required this.onDateSelected,
    required this.genderController,
  });

  final Function goToNextStep;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController displayNameController;
  final TextEditingController dateController;
  final TextEditingController genderController;
  final Function(DateTime) onDateSelected;

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late Size size;

  DateTime? selectedDate;
  final List<String> genderList = ['Male', 'Female', 'N/A'];
  String pickedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your first name'
                              : null,
                          controller: widget.firstNameController,
                          onChanged: (value) {
                            widget.displayNameController.text =
                                '${widget.firstNameController.text}${widget.lastNameController.text}';
                          },
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          decoration: _inputDecoration(
                              context, 'First Name *', isDarkMode),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your last name'
                              : null,
                          controller: widget.lastNameController,
                          onChanged: (value) {
                            widget.displayNameController.text =
                                '${widget.firstNameController.text}${widget.lastNameController.text}';
                          },
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          decoration: _inputDecoration(
                              context, 'Last Name *', isDarkMode),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your display name'
                              : null,
                          controller: widget.displayNameController,
                          autocorrect: false,
                          style: TextStyle(
                            color: isDarkMode ? Colors.cyanAccent : Colors.blue,
                          ),
                          decoration: _inputDecoration(
                                  context, 'Display Name *', isDarkMode)
                              .copyWith(
                            prefixText: '@',
                            prefixStyle: TextStyle(
                              color:
                                  isDarkMode ? Colors.cyanAccent : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: widget.dateController,
                          readOnly: true,
                          validator: (value) => value == null ||
                                  value.isEmpty ||
                                  value == 'Select Date'
                              ? 'Please enter your birthday'
                              : null,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          onTap: _pickDate,
                          decoration: _inputDecoration(
                              context, 'Date of Birth *', isDarkMode),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender *',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: genderList.length,
                          itemBuilder: (context, index) {
                            return _buildGenderButton(
                              context,
                              isDarkMode: isDarkMode,
                              onPressedGender: (value) {
                                setState(() {
                                  pickedGender = value;
                                  widget.genderController.text = pickedGender;
                                });
                              },
                              choosedGender: pickedGender,
                              value: genderList[index],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _validateForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Next'),
            ),
          )
        ],
      ),
    );
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      widget.goToNextStep();
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.dateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
        widget.onDateSelected(picked);
      });
    }
  }

  InputDecoration _inputDecoration(
      BuildContext context, String label, bool isDarkMode) {
    final Color labelColor = isDarkMode ? Colors.white70 : Colors.grey[800]!;
    final Color borderColor = isDarkMode ? Colors.white54 : Colors.grey;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: labelColor, fontSize: 14),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      border: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: borderColor),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: borderColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 0.5, color: borderColor),
      ),
    );
  }

  Widget _buildGenderButton(
    BuildContext context, {
    required bool isDarkMode,
    required Function(String) onPressedGender,
    required String choosedGender,
    required String value,
  }) {
    final bool isSelected = value == choosedGender;
    return GestureDetector(
      onTap: () => onPressedGender(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withRed(70),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
