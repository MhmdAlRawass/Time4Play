// contact_info_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:time4play/providers/country_provider.dart';
import 'verify_page.dart';

class ContactInfoPage extends StatefulWidget {
  final Function goToNextStep;
  const ContactInfoPage({super.key, required this.goToNextStep});
  @override
  State<StatefulWidget> createState() {
    return _ContactInfoPageState();
  }
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late Size size;
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  // Selected calling code (for phone) and country name (for residence)
  String _selectedCallingCode = "";
  String _selectedCountryName = "";

  @override
  void dispose() {
    countryController.dispose();
    phoneController.dispose();
    streetController.dispose();
    postalCodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void _formValidate() {
    if (_formKey.currentState!.validate()) {
      widget.goToNextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Country of Residence is required';
                      }
                      return null;
                    },
                    readOnly: true,
                    controller: countryController,
                    decoration:
                        _inputDecoration(context, 'Country of Residence *'),
                    onTap: () async {
                      final result = await _openCountryResidencePicker();
                      if (result != null) {
                        setState(() {
                          _selectedCountryName = result;
                          countryController.text = result;
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
                            border: Border.all(
                                color: Theme.of(context).colorScheme.onPrimary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedCallingCode.isNotEmpty
                                ? _selectedCallingCode
                                : '+Code',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Number is required';
                            }
                            return null;
                          },
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration:
                              _inputDecoration(context, 'Phone Number *'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyPage(
                                phoneNumber:
                                    '$_selectedCallingCode ${phoneController.text}',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          overlayColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        child: Text('Verify'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Modern TextFormField for Street Name.
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Street Name is required';
                      }
                      return null;
                    },
                    controller: streetController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    decoration: _inputDecoration(context, 'Street Name'),
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                  const SizedBox(height: 20),
                  // Modern TextFormField for Postal Code.
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Postal Code is required, if not available, enter 0';
                      }
                      return null;
                    },
                    controller: postalCodeController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    decoration: _inputDecoration(context, 'Postal Code'),
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                  const SizedBox(height: 20),
                  // Modern TextFormField for City.
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'City is required';
                      }
                      return null;
                    },
                    controller: cityController,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    decoration: _inputDecoration(context, 'City'),
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _formValidate();
              },
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

  InputDecoration _inputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 14,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 0.5,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  /// Opens a modal bottom sheet to select the country of residence.
  /// Returns the country name.
  Future<String?> _openCountryResidencePicker() async {
    final countryProvider =
        Provider.of<CountryProvider>(context, listen: false);
    await countryProvider.fetchCountries();
    final countries = countryProvider.countries;
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FutureBuilder<List<dynamic>>(
          future: _fetchCountries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: size.height * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                height: size.height * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                height: size.height * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('No countries found'),
                ),
              );
            } else {
              final List<dynamic> countries = snapshot.data!;
              String searchQuery = "";
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  final List<dynamic> filteredCountries =
                      countries.where((country) {
                    final countryName = country['name']?['common'] ?? '';
                    return countryName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();

                  return Container(
                    height: size.height * 0.7,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Select Country of Residence',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search country...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredCountries.length,
                              itemBuilder: (context, index) {
                                final country = filteredCountries[index];
                                final countryName =
                                    country['name']?['common'] ?? 'N/A';
                                return ListTile(
                                  title: Text(countryName),
                                  onTap: () {
                                    Navigator.of(context).pop(countryName);
                                  },
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
            }
          },
        );
      },
    );
  }

  /// Opens a modal bottom sheet to select a phone calling code.
  /// Returns the calling code (e.g. "+961").
  Future<String?> _openPhoneCodePicker() async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FutureBuilder<List<dynamic>>(
          future: _fetchCountries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: size.height * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Container(
                height: size.height * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                height: size.height * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('No countries found'),
                ),
              );
            } else {
              final List<dynamic> countries = snapshot.data!;
              String searchQuery = "";
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  final List<dynamic> filteredCountries =
                      countries.where((country) {
                    final countryName = country['name']?['common'] ?? '';
                    return countryName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();

                  return Container(
                    height: size.height * 0.7,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Select Phone Code',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search country...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredCountries.length,
                              itemBuilder: (context, index) {
                                final country = filteredCountries[index];
                                final countryName =
                                    country['name']?['common'] ?? 'N/A';
                                String countryNumber = 'N/A';
                                try {
                                  if (country['idd'] != null &&
                                      country['idd']['root'] != null &&
                                      country['idd']['suffixes'] != null &&
                                      (country['idd']['suffixes'] as List)
                                          .isNotEmpty) {
                                    countryNumber =
                                        '${country['idd']['root']}${(country['idd']['suffixes'] as List)[0]}';
                                  }
                                } catch (e) {
                                  countryNumber = 'N/A';
                                }
                                return ListTile(
                                  title: Text('$countryName ($countryNumber)'),
                                  onTap: () {
                                    Navigator.of(context).pop(countryNumber);
                                  },
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
            }
          },
        );
      },
    );
  }

  /// Fetches the list of countries from the API.
  Future<List<dynamic>> _fetchCountries() async {
    const url = 'https://restcountries.com/v3.1/all';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load countries');
    }
    return jsonDecode(response.body);
  }
}
