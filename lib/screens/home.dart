import 'package:flutter/material.dart';
import 'book_history_screen.dart';
import 'explore_screen.dart';
import '../widgets/home/booking_card.dart';
import '../widgets/home/section_header.dart';
import '../widgets/home/sport_category_button.dart';
import '../widgets/home/featured_card.dart';
import '../widgets/home/promotion_card.dart';
import '../widgets/home/review_card.dart';
import '../widgets/home/how_it_works_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToExplore(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExploreScreen()),
    );
  }

  void _navigateToBookings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BookingHistoryScreen()),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You can later add a custom drawer implementation here if needed.
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Hero Section
            SliverAppBar(
              expandedHeight: 300,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'lib/assets/basketball.jpeg',
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
                                .displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _navigateToExplore(context),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 46,
                      left: 10,
                      child: IconButton(
                        onPressed: () {
                          // Insert logic for opening your manual drawer
                        },
                        icon: const Icon(Icons.menu),
                        iconSize: 30,
                      ),
                    )
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
                    // Upcoming Bookings
                    Column(
                      children: [
                        SectionHeader(
                          title: "Upcoming Bookings",
                          onSeeAll: () => _navigateToBookings(context),
                        ),
                        const BookingCard(
                          courtName: "4b Sporting Club",
                          date: "Today • 4:00 PM",
                          duration: "2 hours",
                          price: "\$45",
                          image: 'lib/assets/basketball.jpeg',
                        ),
                        const BookingCard(
                          courtName: "StreetBall Club",
                          date: "Tomorrow • 3:30 PM",
                          duration: "1.5 hours",
                          image: 'lib/assets/basketball.jpeg',
                          price: "\$30",
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Sports Categories
                    Column(
                      children: [
                        const SectionHeader(title: "Sports Categories"),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              SportCategoryButton(
                                icon: Icons.sports_soccer,
                                label: "Football",
                              ),
                              SportCategoryButton(
                                icon: Icons.sports_basketball,
                                label: "Basketball",
                              ),
                              SportCategoryButton(
                                icon: Icons.sports_tennis,
                                label: "Tennis",
                              ),
                              SportCategoryButton(
                                icon: Icons.sports_volleyball,
                                label: "Volleyball",
                              ),
                              SportCategoryButton(
                                icon: Icons.sports,
                                label: "More",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Recommended Venues
                    Column(
                      children: [
                        SectionHeader(
                          title: "Recommended Venues",
                          onSeeAll: () => _navigateToExplore(context),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              FeaturedCard(
                                image: 'assets/stadium1.jpg',
                                title: "4b Sporting Club",
                                location: "Qayaa • 2km",
                                rating: 4.8,
                              ),
                              FeaturedCard(
                                image: 'assets/stadium2.jpg',
                                title: "StreetBall Club",
                                location: "Qayaa • 5km",
                                rating: 4.6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Special Offers
                    Column(
                      children: [
                        const SectionHeader(title: "Special Offers"),
                        PromotionCard(
                          image: 'lib/assets/basketball.jpeg',
                          title: "30% Off Evening Bookings",
                          description: "Book between 8PM - 11PM and save!",
                          onTap: () => _showOfferDetails(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Recent Reviews
                    Column(
                      children: [
                        const SectionHeader(title: "Recent Reviews"),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              ReviewCard(
                                user: "Alex Johnson",
                                comment:
                                    "Fantastic facilities and friendly staff!",
                                rating: 5.0,
                                image: 'assets/user1.jpg',
                              ),
                              ReviewCard(
                                user: "Sarah Wilson",
                                comment:
                                    "Well-maintained courts, highly recommend!",
                                rating: 4.5,
                                image: 'assets/user2.jpg',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // How It Works
                    Column(
                      children: [
                        const SectionHeader(title: "How It Works"),
                        const SizedBox(height: 16),
                        const HowItWorksSection(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Premium CTA
                    _buildPremiumCta(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
}
