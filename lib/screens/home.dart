import 'package:flutter/material.dart';
import 'book_history_screen.dart';
import '../widgets/home/section_header.dart';
import '../widgets/home/sport_category_button.dart';
import '../widgets/home/featured_card.dart';
import '../widgets/home/promotion_card.dart';
import '../widgets/home/review_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.switchScreen,
  });

  final void Function(int) switchScreen;

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
      drawer: _buildDrawer(context),
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
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.redAccent,
                                  const Color.fromARGB(255, 33, 40, 243),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                "Find a Venue",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 56,
                      right: 16,
                      child: IconButton(
                        onPressed: () {
                          // Insert logic for opening your manual drawer
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(Icons.notifications_outlined),
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
                    //  Deleted
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
                          onSeeAll: () {
                            widget.switchScreen(1);
                          },
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              FeaturedCard(
                                image: 'lib/assets/images/home/4b-stadium.jpg',
                                title: "4b Sporting Club",
                                location: "Qayaa • 2km",
                                rating: 4.8,
                              ),
                              FeaturedCard(
                                image: 'lib/assets/images/home/stadium-2.jpg',
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
                          image: 'lib/assets/images/home/offer.jpg',
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('lib/assets/user_avatar.png'),
                ),
                const SizedBox(height: 8),
                Text(
                  "User Name",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  "user@example.com",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, "Home", () => _navigateToPage(0)),
          _buildDrawerItem(Icons.calendar_today, "My Bookings", () {}),
          _buildDrawerItem(Icons.favorite, "Favorite Venues", () {}),
          _buildDrawerItem(
              Icons.settings, "Settings", () => _navigateToPage(2)),
          _buildDrawerItem(Icons.help, "Help & Support", () {}),
          _buildDrawerItem(Icons.article, "Terms & Conditions", () {}),
          const Divider(),
          _buildDrawerItem(Icons.logout, "Logout", () {
            // Implement Logout Functionality
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      // _pageIndex = index;
    });
  }
}
