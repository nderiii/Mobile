import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 2;
  String selectedFilter = "All";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock favorite stocks/crypto
  final List<String> favoriteSymbols = ["AAPL", "BTC", "ETH", "TSLA"];

  @override
  void initState() {
    super.initState();
    // Hide system navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Restore system navigation bar when leaving
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            Column(
              children: [
                // HEADER SECTION
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).padding.top + 20,
                    20,
                    20,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Market News",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Stay updated with latest trends",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // FILTER CHIPS
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip("All"),
                            const SizedBox(width: 8),
                            _buildFilterChip("Favorites"),
                            const SizedBox(width: 8),
                            _buildFilterChip("Stocks"),
                            const SizedBox(width: 8),
                            _buildFilterChip("Crypto"),
                            const SizedBox(width: 8),
                            _buildFilterChip("Trending"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // NEWS FEED
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    children: [
                      // Priority Section - Favorites
                      if (selectedFilter == "All" ||
                          selectedFilter == "Favorites") ...[
                        _buildSectionHeader(
                          "Your Favorites",
                          "Priority updates",
                          Icons.favorite,
                          const Color(0xFFE91E63),
                        ),
                        const SizedBox(height: 12),
                        _buildNewsCard(
                          title: "Apple Announces New AI Features",
                          source: "AAPL",
                          time: "2 hours ago",
                          category: "Stock",
                          description:
                              "Apple Inc. unveils groundbreaking AI integration across all devices...",
                          imageUrl: "assets/images/apple.png",
                          isPriority: true,
                          changePercent: "+2.4%",
                          isPositive: true,
                        ),
                        const SizedBox(height: 12),
                        _buildNewsCard(
                          title: "Bitcoin Hits New Monthly High",
                          source: "BTC",
                          time: "4 hours ago",
                          category: "Crypto",
                          description:
                              "Bitcoin surges past key resistance level as institutional interest grows...",
                          imageUrl: "assets/images/bitcoin.png",
                          isPriority: true,
                          changePercent: "+5.2%",
                          isPositive: true,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Trending News
                      if (selectedFilter == "All" ||
                          selectedFilter == "Trending") ...[
                        _buildSectionHeader(
                          "Trending Now",
                          "Hot topics",
                          Icons.whatshot,
                          const Color(0xFFFF9800),
                        ),
                        const SizedBox(height: 12),
                        _buildNewsCard(
                          title: "Tech Sector Shows Strong Growth",
                          source: "Market Watch",
                          time: "5 hours ago",
                          category: "Stock",
                          description:
                              "Technology stocks lead market rally with impressive gains...",
                          imageUrl: null,
                          isPriority: false,
                          changePercent: "+1.8%",
                          isPositive: true,
                        ),
                        const SizedBox(height: 12),
                        _buildNewsCard(
                          title: "Ethereum 2.0 Update Progress",
                          source: "ETH",
                          time: "6 hours ago",
                          category: "Crypto",
                          description:
                              "Major milestone reached in Ethereum's transition to proof-of-stake...",
                          imageUrl: null,
                          isPriority: false,
                          changePercent: "+3.1%",
                          isPositive: true,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // General Market News
                      if (selectedFilter == "All" ||
                          selectedFilter == "Stocks") ...[
                        _buildSectionHeader(
                          "Stock Market",
                          "Latest updates",
                          Icons.trending_up,
                          const Color(0xFF2196F3),
                        ),
                        const SizedBox(height: 12),
                        _buildNewsCard(
                          title: "Federal Reserve Maintains Interest Rates",
                          source: "Bloomberg",
                          time: "8 hours ago",
                          category: "Stock",
                          description:
                              "Fed keeps rates steady amid economic stability concerns...",
                          imageUrl: null,
                          isPriority: false,
                          changePercent: null,
                          isPositive: true,
                        ),
                        const SizedBox(height: 12),
                        _buildNewsCard(
                          title: "Energy Sector Faces Volatility",
                          source: "CNBC",
                          time: "10 hours ago",
                          category: "Stock",
                          description:
                              "Oil prices fluctuate as global demand patterns shift...",
                          imageUrl: null,
                          isPriority: false,
                          changePercent: "-1.2%",
                          isPositive: false,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Crypto News
                      if (selectedFilter == "All" ||
                          selectedFilter == "Crypto") ...[
                        _buildSectionHeader(
                          "Cryptocurrency",
                          "Digital assets",
                          Icons.currency_bitcoin,
                          const Color(0xFFFF9800),
                        ),
                        const SizedBox(height: 12),
                        _buildNewsCard(
                          title: "New Regulations Impact Crypto Trading",
                          source: "CoinDesk",
                          time: "12 hours ago",
                          category: "Crypto",
                          description:
                              "Government announces updated framework for digital asset exchanges...",
                          imageUrl: null,
                          isPriority: false,
                          changePercent: null,
                          isPositive: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String source,
    required String time,
    required String category,
    required String description,
    String? imageUrl,
    required bool isPriority,
    String? changePercent,
    required bool isPositive,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isPriority
            ? Border.all(
                color: const Color(0xFFE91E63).withOpacity(0.3),
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Navigate to news detail page
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: category == "Stock"
                            ? const Color(0xFF2196F3).withOpacity(0.1)
                            : const Color(0xFFFF9800).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: category == "Stock"
                              ? const Color(0xFF2196F3)
                              : const Color(0xFFFF9800),
                        ),
                      ),
                    ),
                    if (isPriority) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE91E63).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 10,
                              color: Color(0xFFE91E63),
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Favorite",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (changePercent != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          changePercent,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isPositive
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFE53935),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer
                Row(
                  children: [
                    Icon(Icons.source, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      source,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.bookmark_border,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // NAV ITEM
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);

        // Navigate to Profile page when Profile is selected
        if (index == 0) {
          Navigator.pop(context); // Go back to dashboard
        } else if (index == 1) {
          Navigator.pushNamed(context, '/explore');
        } else if (index == 3) {
          Navigator.pushNamed(context, '/profile');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
