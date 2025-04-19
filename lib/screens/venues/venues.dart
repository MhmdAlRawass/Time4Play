import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/providers/venues_provider.dart';
import 'package:time4play/screens/venues/sports.dart';
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

  PreferredSizeWidget _buildAppBar() {
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
    final venuesAsync = ref.watch(companyProvider);
    final sportsMapAsync = ref.watch(companySportsMapProvider);

    return Scaffold(
      appBar: _buildAppBar(),
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
                  return _buildVenuesList(filtered);
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

  Widget _buildVenuesList(List<Company> venues) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: venues.map((venue) => _buildVenueCard(venue)).toList(),
      ),
    );
  }

  Widget _buildVenueCard(Company venue) {
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
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage('lib/assets/images/home/4b-stadium.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 12,
                    child: Text(
                      venue.name,
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
  }
}
