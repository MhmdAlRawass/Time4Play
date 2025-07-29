import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:time4play/models/booking.dart';
import 'package:time4play/providers/venues_provider.dart';
import 'package:time4play/screens/venues/sports.dart';
import 'package:time4play/services/php_image_service.dart';
import 'package:time4play/widgets/gradient_border.dart';
import 'package:time4play/widgets/venues/filter_venue_sheet.dart';

class VenuesPage extends ConsumerStatefulWidget {
  const VenuesPage({
    super.key,
    required this.switchScreen,
    this.selectedSport,
  });

  final void Function(int) switchScreen;
  final String? selectedSport;

  @override
  ConsumerState<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends ConsumerState<VenuesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _venuesController;
  late Animation<double> _bookingsFadeAnimation;
  late Size size;

  List<String> listOfImages = [
    'lib/assets/images/companies/company_2.jpg',
    'lib/assets/images/companies/4b-stadium.jpg',
    'lib/assets/images/companies/company_4.webp',
    'lib/assets/images/companies/company_3.jpg',
  ];

  List<String> selectedAreas = [];
  List<String> selectedSports = [];

  final List<String> availableAreas = [
    'Saida',
    'Beirut',
    'Tripoli',
    'Sarafand',
    'Tyr',
  ];
  final List<String> availableSports = [
    'Football',
    'Basketball',
    'Padel',
  ];

  bool _isSearching = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedSport != null && widget.selectedSport != 'All') {
      selectedSports.add(widget.selectedSport!);
    }
    _venuesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bookingsFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _venuesController, curve: Curves.easeIn),
    );
    _venuesController.forward();
  }

  @override
  void dispose() {
    _venuesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterVenuesSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return FilterVenuesSheet(
          onApplyFilters: (areas, sports) {
            setState(() {
              selectedAreas = areas;
              selectedSports = sports;
            });
          },
          availableAreas: availableAreas,
          availableSports: availableSports,
          initialSelectedAreas: selectedAreas,
          initialSelectedSports: selectedSports,
        );
      },
    );
  }

  List<Company> _filterCompanies(
    List<Company> companies,
    Map<String, List<Sport>> sportsMap,
  ) {
    final query = _searchQuery.toLowerCase();

    return companies.where((company) {
      if (selectedAreas.isNotEmpty &&
          !selectedAreas.any((area) =>
              company.address.toLowerCase().contains(area.toLowerCase()))) {
        return false;
      }

      if (selectedSports.isNotEmpty) {
        final sports = sportsMap[company.id] ?? [];
        if (!sports.any((sport) => selectedSports.contains(sport.name))) {
          return false;
        }
      }

      if (query.isNotEmpty) {
        final title = company.name.toLowerCase();
        final location = company.address.toLowerCase();
        return title.contains(query) || location.contains(query);
      }

      return true;
    }).toList();
  }

  Future<void> _onVenueTap(String companyId, Company company) async {
    final sportsMap = ref.read(companySportsMapProvider).asData?.value ?? {};
    final sports = sportsMap[companyId] ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SportsPage(
          sportsList: sports,
          company: company,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    final isIos = Platform.isIOS;

    return PreferredSize(
      preferredSize: Size(double.infinity, size.height * 0.151),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => widget.switchScreen(0),
                  icon: Icon(
                    isIos
                        ? Icons.arrow_back_ios_new_outlined
                        : Icons.arrow_back,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSearching
                        ? TextField(
                            controller: _searchController,
                            cursorColor:
                                isDarkMode ? Colors.white : Colors.black87,
                            autocorrect: false,
                            autofocus: true,
                            enableSuggestions: false,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search venues",
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.black.withOpacity(0.7),
                              ),
                              border: InputBorder.none,
                            ),
                          )
                        : Text(
                            'Available Venues',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchQuery = "";
                      _searchController.clear();
                    } else {
                      _isSearching = true;
                    }
                  }),
                  icon: Icon(
                    _isSearching ? Icons.clear : Icons.search,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _filterVenuesSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
                label: const Text('Filter Venues'),
                icon:
                    const Icon(Icons.filter_list_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _fetchImage(String companyId, int index) async {
    // companyId = 'cDbPL1gbR1KzIDFsY40K';
    final url =
        'http://localhost/time4play-backend/get_images.php?companyID=$companyId';
    // 'https://time4play.atwebpages.com/get_images.php?companyID=$companyId';

    try {
      List<String> imageUrls = await PhpImageService.getImageUrls(url);
      print('fetched images: $imageUrls');
      return imageUrls[0];
    } catch (e) {
      print('Error fetching images: $e');
    }
    // return 'lib/assets/images/home/4b-stadium.jpg';
    return listOfImages[index];
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final venuesAsync = ref.watch(companyProvider);
    final sportsMapAsync = ref.watch(companySportsMapProvider);
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(isDarkMode),
      body: SafeArea(
        child: FadeTransition(
          opacity: _bookingsFadeAnimation,
          child: venuesAsync.when(
            data: (companies) {
              return sportsMapAsync.when(
                data: (sportsMap) {
                  final filtered = _filterCompanies(companies, sportsMap);
                  if (filtered.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildVenuesList(filtered, isDarkMode);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No venues found matching your criteria",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenuesList(List<Company> venues, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: venues
            .map((venue) =>
                _buildVenueCard(venue, isDarkMode, venues.indexOf(venue)))
            .toList(),
      ),
    );
  }

  Widget _buildVenueCard(Company venue, bool isDarkMode, int index) {
    return FutureBuilder<String>(
      future: _fetchImage(venue.id, index),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        String imageUrl =
            snapshot.data ?? 'lib/assets/images/home/4b-stadium.jpg';

        print('Image Url "$imageUrl');

        bool isNetworkImage = imageUrl.startsWith('http');

        return GestureDetector(
          onTap: () => _onVenueTap(venue.id, venue),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: GradientBorderContainer(
              leftColor: Colors.redAccent,
              rightColor: const Color.fromARGB(255, 33, 40, 243),
              borderWidth: 2,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: isNetworkImage
                                  ? FadeInImage.assetNetwork(
                                      placeholder:
                                          'lib/assets/images/placeholder.png',
                                      image: imageUrl,
                                      fit: BoxFit.cover,
                                      fadeInDuration:
                                          const Duration(milliseconds: 300),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 300),
                                    )
                                  : Image.asset(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        left: 12,
                        child: Text(
                          venue.name,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            color: isDarkMode
                                ? Colors.white
                                : Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            venue.address,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
