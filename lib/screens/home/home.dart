import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:time4play/models/booking.dart';
import 'package:time4play/providers/venues_provider.dart';
import 'package:time4play/screens/home/notification_history.dart';
import 'package:time4play/screens/login/login_screen.dart';
import 'package:time4play/screens/venues/sports.dart';
import 'package:time4play/services/logout_service.dart';
import '../../widgets/home/section_header.dart';
import '../../widgets/home/sport_category_button.dart';
import '../../widgets/home/featured_card.dart';
import '../../widgets/home/promotion_card.dart';
import '../../widgets/home/review_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.switchScreen,
  });

  final void Function(int, {String? selectedSport}) switchScreen;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _sportsSlideAnimation;
  late Animation<Offset> _recommendedSlideAnimation;
  late Animation<Offset> _offersSlideAnimation;
  late Animation<Offset> _reviewsSlideAnimation;
  late Animation<double> _premiumScaleAnimation;
  bool _isLoading = false;

  final List<String> availableSports = [
    'Football',
    'Basketball',
    'Padel',
    'All',
  ];

  final List<IconData> sportIcons = [
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_tennis,
    Icons.all_inclusive,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animation for the entire page
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Slide animations for each section
    _sportsSlideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _recommendedSlideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _offersSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    ));

    _reviewsSlideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    // Scale animation for the premium CTA
    _premiumScaleAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showOfferDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Special Offer"),
        content:
            const Text("30% discount applies to bookings between 8PM-11PM"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showPremiumOptions() {
    // Implement premium subscription logic here
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final venuesAsync = ref.watch(companyProvider);

    return Stack(
      children: [
        Scaffold(
          drawer: _buildDrawer(context),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                // Hero Section
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: size.height * 0.35,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'lib/assets/images/home/hero.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Placeholder(),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Find & Book the Best\nSports Venues Near You!",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  widget.switchScreen(1);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  "Find a Venue",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: 56,
                            right: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => NotificationHistory(),
                                      ),
                                    );
                                  },
                                  icon:
                                      const Icon(Icons.notifications_outlined),
                                  iconSize: 30,
                                ),
                                Builder(builder: (context) {
                                  return IconButton(
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    icon: Icon(Icons.menu),
                                    iconSize: 30,
                                  );
                                }),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Sports Categories
                        SlideTransition(
                          position: _sportsSlideAnimation,
                          child: Column(
                            children: [
                              const SectionHeader(title: "Sports Categories"),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: availableSports.length,
                                    itemBuilder: (ctx, index) {
                                      return GestureDetector(
                                        behavior: HitTestBehavior
                                            .opaque, // <- important
                                        onTap: () {
                                          print(availableSports[
                                              index]); // Debug check
                                          widget.switchScreen(
                                            1,
                                            selectedSport:
                                                availableSports[index],
                                          );
                                        },
                                        child: SportCategoryButton(
                                          icon: sportIcons[index],
                                          label: availableSports[index],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Recommended Venues
                        SlideTransition(
                          position: _recommendedSlideAnimation,
                          child: Column(
                            children: [
                              SectionHeader(
                                title: "Recommended Venues",
                                onSeeAll: () => widget.switchScreen(1),
                              ),
                              SizedBox(
                                height: 200,
                                child: venuesAsync.when(
                                  data: (data) {
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          data.length < 4 ? data.length : 4,
                                      itemBuilder: (context, index) {
                                        final venue = data[index];
                                        return GestureDetector(
                                          onTap: () {
                                            _onVenueTap(venue.id, venue);
                                          },
                                          child: FeaturedCard(
                                            image:
                                                'lib/assets/images/home/4b-stadium.jpg',
                                            title: venue.name,
                                            location: venue.address,
                                            // rating: venue.rating,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  error: (error, stackTrace) {
                                    return const Center(
                                      child: Text("Error loading venues"),
                                    );
                                  },
                                  loading: () {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Special Offers
                        SlideTransition(
                          position: _offersSlideAnimation,
                          child: Column(
                            children: [
                              const SectionHeader(title: "Special Offers"),
                              PromotionCard(
                                image: 'lib/assets/images/home/offer.jpg',
                                title: "Limited Time Offer",
                                description:
                                    "Book now and get a free coaching session!",
                                onTap: () => _showOfferDetails(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Recent Reviews
                        SlideTransition(
                          position: _reviewsSlideAnimation,
                          child: Column(
                            children: [
                              const SectionHeader(title: "Recent Reviews"),
                              SizedBox(
                                height: 200,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(-1, 0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: _controller,
                                        curve: const Interval(0.6, 1.0,
                                            curve: Curves.easeOut),
                                      )),
                                      child: const ReviewCard(
                                        user: "User 1",
                                        comment:
                                            "Fantastic facilities and friendly staff!",
                                        rating: 5.0,
                                        image: 'assets/user1.jpg',
                                      ),
                                    ),
                                    SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(-1, 0),
                                        end: Offset.zero,
                                      ).animate(CurvedAnimation(
                                        parent: _controller,
                                        curve: const Interval(0.7, 1.0,
                                            curve: Curves.easeOut),
                                      )),
                                      child: const ReviewCard(
                                        user: "User 2",
                                        comment:
                                            "Well-maintained courts, highly recommend!",
                                        rating: 4.5,
                                        image:
                                            'https://unsplash.com/photos/a-man-wearing-glasses-and-a-black-shirt-iEEBWgY_6lA',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Premium CTA
                        ScaleTransition(
                          scale: _premiumScaleAnimation,
                          child: _buildPremiumCta(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  Widget _buildPremiumCta() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            "Premium Membership",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            "Get exclusive discounts and access to premium venues!",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showPremiumOptions,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Subscribe Now", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).cardColor.withOpacity(0.8),
              child: Text(
                'MR',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            accountName: Text(
              "Mhmd",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            accountEmail: Text(
              "user@example.com",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Theme.of(context).iconTheme.color),
            title: Text("Home"),
            onTap: () {
              widget.switchScreen(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today,
                color: Theme.of(context).iconTheme.color),
            title: Text("My Bookings"),
            onTap: () {
              widget.switchScreen(2);
            },
          ),
          ListTile(
            leading:
                Icon(Icons.favorite, color: Theme.of(context).iconTheme.color),
            title: Text("Favorite Venues"),
            onTap: () {},
          ),
          ListTile(
            leading:
                Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
            title: Text("Settings"),
            onTap: () {
              widget.switchScreen(3);
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Theme.of(context).iconTheme.color),
            title: Text("Help & Support"),
            onTap: () {},
          ),
          ListTile(
            leading:
                Icon(Icons.article, color: Theme.of(context).iconTheme.color),
            title: Text("Terms & Conditions"),
            onTap: () {},
          ),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          ListTile(
            leading:
                Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
            title: Text("Logout"),
            onTap: () async {
              _setLoadingState(true);

              LogoutService().logout();
              await GoogleSignIn().signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
              _setLoadingState(false);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      // _pageIndex = index;
    });
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }
}
