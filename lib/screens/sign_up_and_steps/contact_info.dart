import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:time4play/services/country_service.dart';

class ContactInfoPage extends StatefulWidget {
  const ContactInfoPage({
    super.key,
    required this.goToNextStep,
    required this.countryController,
    required this.phoneController,
    required this.streetController,
    required this.postalCodeController,
    required this.cityController,
  });

  final Function goToNextStep;
  final TextEditingController countryController;
  final TextEditingController phoneController;
  final TextEditingController streetController;
  final TextEditingController postalCodeController;
  final TextEditingController cityController;

  @override
  State<ContactInfoPage> createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late Size size;
  String _selectedCallingCode = "";
  String _selectedCountryName = "";

  final CountryService _countryService = CountryService();

  void _formValidate() {
    if (_formKey.currentState!.validate()) {
      widget.goToNextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final Color cardBackground =
        isDarkMode ? Theme.of(context).cardColor : Colors.white;
    final Color borderColor = isDarkMode ? primaryColor : Colors.grey.shade300;
    final Color textFieldTextColor =
        isDarkMode ? onPrimaryColor : Colors.black87;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: [
                if (!isDarkMode)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? 'Country of Residence is required'
                        : null,
                    readOnly: true,
                    controller: widget.countryController,
                    decoration: _inputDecoration(
                        context, 'Country of Residence *', textFieldTextColor),
                    onTap: () async {
                      final result = await _openCountryResidencePicker();
                      if (result != null) {
                        setState(() {
                          _selectedCountryName = result;
                          widget.countryController.text = result;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await _openPhoneCodePicker();
                          if (result != null) {
                            setState(() {
                              _selectedCallingCode = result;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedCallingCode.isNotEmpty
                                ? _selectedCallingCode
                                : '+Code',
                            style: TextStyle(
                              color: textFieldTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          validator: (value) => value == null || value.isEmpty
                              ? 'Number is required'
                              : null,
                          controller: widget.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                              context, 'Phone Number *', textFieldTextColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? 'Street Name is required'
                        : null,
                    controller: widget.streetController,
                    decoration: _inputDecoration(
                        context, 'Street Name', textFieldTextColor),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? 'Postal Code is required'
                        : null,
                    controller: widget.postalCodeController,
                    decoration: _inputDecoration(
                        context, 'Postal Code', textFieldTextColor),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) => value == null || value.isEmpty
                        ? 'City is required'
                        : null,
                    controller: widget.cityController,
                    decoration:
                        _inputDecoration(context, 'City', textFieldTextColor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _formValidate,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: onPrimaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Next', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
      BuildContext context, String label, Color textColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor, fontSize: 14),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: textColor, width: 1),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: textColor.withOpacity(0.6)),
      ),
    );
  }

  Future<List<dynamic>> _fetchCountries() async {
    const url = 'https://restcountries.com/v3.1/all';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load countries');
    }
    return jsonDecode(response.body);
  }

  Future<String?> _openCountryResidencePicker() async {
    final countries = await _fetchCountries();
    return _showCountryModal(countries, 'Select Country of Residence');
  }

  Future<String?> _openPhoneCodePicker() async {
    final countries = await _fetchCountries();
    return _showCountryModal(countries, 'Select Phone Code', isPhone: true);
  }

  Future<String?> _showCountryModal(List<dynamic> countries, String title,
      {bool isPhone = false}) {
    String searchQuery = "";
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final filtered = countries.where((country) {
              final name = country['name']?['common'] ?? '';
              return name
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              height: size.height * 0.7,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search country...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) =>
                          setModalState(() => searchQuery = value),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          final name = country['name']?['common'] ?? 'N/A';
                          String label = name;

                          if (isPhone) {
                            try {
                              final root = country['idd']?['root'] ?? '';
                              final suffix =
                                  (country['idd']?['suffixes'] as List?)
                                          ?.first ??
                                      '';
                              label += ' ($root$suffix)';
                              return ListTile(
                                title: Text(label),
                                onTap: () =>
                                    Navigator.pop(context, '$root$suffix'),
                              );
                            } catch (_) {
                              return const SizedBox.shrink();
                            }
                          }

                          return ListTile(
                            title: Text(label),
                            onTap: () => Navigator.pop(context, name),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
