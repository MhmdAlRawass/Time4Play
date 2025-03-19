import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time4play/models/sport.dart';
import 'package:time4play/screens/sports.dart';
import 'package:time4play/widgets/gradient_border.dart';
import 'package:time4play/widgets/venues/filter_venue_sheet.dart';

class VenuesPage extends StatefulWidget {
  const VenuesPage({
    super.key,
    required this.switchScreen,
  });

  final void Function(int) switchScreen;

  @override
  State<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _venuesController;
  late Animation<double> _bookingsFadeAnimation;
  late Size size;

  final List<Sport> sportsList = [
    Sport(
      name: 'Football',
      price: 22,
      description: 'Professional football turf',
      imagePath: 'lib/assets/images/sports/football.png',
    ),
    Sport(
      name: 'Basketball',
      price: 21.33,
      description: 'Indoor basketball court',
      imagePath: 'lib/assets/images/sports/basketball.png',
    ),
    Sport(
      name: 'Padel',
      price: 15,
      description: 'International standard padel courts',
      imagePath: 'lib/assets/images/sports/padel.png',
    ),
    Sport(
      name: 'Cricket',
      price: 25,
      description: 'Cricket nets and practice pitches',
      imagePath: 'lib/assets/images/sports/cricket.png',
    ),
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

  // Search functionality
  bool _isSearching = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  // Venues data with sports information
  final List<Map<String, dynamic>> venues = [
    {
      "title": "4b Sporting Club",
      "location": "Saida, Lebanon",
      "sports": ["Football", "Basketball", "Padel"],
      "image": "lib/assets/images/home/4b-stadium.jpg"
    },
    {
      "title": "Play Arena",
      "location": "Beirut, Lebanon",
      "sports": ["Football", "Cricket"],
      "image": "lib/assets/images/home/4b-stadium.jpg"
    },
    {
      "title": "Decathlon Sports",
      "location": "Bannerghatta Road, Bangalore",
      "sports": ["Basketball", "Padel"],
      "image": "lib/assets/images/home/4b-stadium.jpg"
    },
    {
      "title": "XLR8 Indoor Sports",
      "location": "Whitefield, Bangalore",
      "sports": ["Cricket", "Padel"],
      "image": "lib/assets/images/home/4b-stadium.jpg"
    },
  ];

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

  List<Map<String, dynamic>> get _filteredVenues {
    final query = _searchQuery.toLowerCase();
    return venues.where((venue) {
      // Area filter
      if (selectedAreas.isNotEmpty &&
          !selectedAreas.any((area) =>
              venue["location"]!.toLowerCase().contains(area.toLowerCase()))) {
        return false;
      }

      // Sport filter
      if (selectedSports.isNotEmpty &&
          !selectedSports.any(
              (sport) => (venue["sports"] as List<String>).contains(sport))) {
        return false;
      }

      // Search query
      if (query.isNotEmpty) {
        final title = venue["title"]!.toLowerCase();
        final location = venue["location"]!.toLowerCase();
        return title.contains(query) || location.contains(query);
      }

      return true;
    }).toList();
  }

  PreferredSizeWidget _buildAppBar() {
    final isIos = Platform.isIOS;

    return PreferredSize(
      preferredSize: Size(double.infinity, size.height * 0.15),
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
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSearching
                        ? TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Search venues",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                              border: InputBorder.none,
                            ),
                          )
                        : const Text(
                            'Available Venues',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
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
                    color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _bookingsFadeAnimation,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _filteredVenues.isEmpty
                ? _buildEmptyState()
                : _buildVenuesList(),
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

  Widget _buildVenuesList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children:
            _filteredVenues.map((venue) => _buildVenueCard(venue)).toList(),
      ),
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SportsPage(
            sportsList: sportsList
                .where((sport) =>
                    (venue["sports"] as List<String>).contains(sport.name))
                .toList(),
          ),
        ),
      ),
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
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(venue["image"]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 12,
                    child: Text(
                      venue["title"],
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black38,
                      ),
                      icon: const Icon(Icons.star_border),
                      onPressed: () {},
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
                        venue["location"],
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
  }
}
