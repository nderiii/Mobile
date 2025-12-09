import 'package:flutter/material.dart';
import 'package:bfu/services/stock_apis.dart';
import 'package:bfu/pages/profilepage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  final StockApis api = StockApis();

  List<dynamic> allSymbols = [];
  Map<String, double?> prices = {};
  String searchQuery = "";
  bool isLoading = true;
  int _currentIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // User preferences (would come from profile in real app)
  final double investmentBudget = 5000.0;
  final String riskTolerance = 'Moderate';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    loadDashboard();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadDashboard() async {
    setState(() => isLoading = true);

    try {
      final symbols = await api.loadSymbols();
      allSymbols = symbols;
      prices = await api.fetchAllPricesParallel();
      _animationController.forward();
    } catch (e, s) {
      print("ERROR IN DASHBOARD: $e");
      print(s);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final filteredSymbols = allSymbols
        .where(
          (item) => item["symbol"].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35),

                        // HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome Back",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Investment Advisor",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.notifications_outlined),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // SEARCH BAR
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() => searchQuery = value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search stocks, crypto...",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // INVESTMENT BUDGET CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Your Investment Budget",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "\$5,000.00",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -1,
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
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF81C784),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Moderate Risk",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "8 Recommendations",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // QUICK STATS
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickStatCard(
                                'Favorites',
                                '12',
                                Icons.favorite,
                                const Color(0xFFE91E63),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildQuickStatCard(
                                'Watchlist',
                                '8',
                                Icons.visibility,
                                const Color(0xFF2196F3),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // RECOMMENDATIONS FOR YOU
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Recommended for You",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Based on your preferences",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("See All"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: buildRecommendationCards(),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // YOUR FAVORITES
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Color(0xFFE91E63),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Your Favorites",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("Manage"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...buildFavoriteTiles(),

                        const SizedBox(height: 32),

                        // TRENDING STOCKS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: Color(0xFF4CAF50),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Trending Stocks",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("View All"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...buildMarketTiles(type: "stock"),

                        const SizedBox(height: 24),

                        // TRENDING CRYPTO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.currency_bitcoin,
                                  color: Color(0xFFFF9800),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Trending Crypto",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("View All"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...buildMarketTiles(type: "crypto"),
                      ],
                    ),
                  ),

                  // FLOATING BOTTOM NAV BAR
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(Icons.home, "Home", 0),
                          _buildNavItem(Icons.explore, "Explore", 1),
                          _buildNavItem(Icons.article, "News", 2),
                          _buildNavItem(Icons.person_outline, "Profile", 3),
                        ],
                      ),
                    ),
                  ),
                ],
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
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profilepage()),
          );
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

  // QUICK STAT CARD
  Widget _buildQuickStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // BUILDERS
  List<Widget> buildRecommendationCards() {
    List<String> recommendations = ["AAPL", "MSFT", "GOOGL", "NVDA", "TSLA"];

    return recommendations.map((symbol) {
      final item = allSymbols.firstWhere(
        (e) => e["symbol"] == symbol,
        orElse: () => {"image": "", "name": symbol, "symbol": symbol},
      );

      return recommendationCard(
        item["symbol"],
        item["name"],
        item["image"],
        formatPrice(symbol),
        "Strong Buy", // This would be calculated based on user preferences
      );
    }).toList();
  }

  List<Widget> buildFavoriteTiles() {
    List<String> favorites = ["BTC", "ETH", "AAPL"];

    return favorites.map((symbol) {
      final item = allSymbols.firstWhere(
        (e) => e["symbol"] == symbol,
        orElse: () => {
          "image": "",
          "name": symbol,
          "symbol": symbol,
          "type": "crypto",
        },
      );

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(item["image"], width: 32, height: 32),
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE91E63),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            item["name"],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            item["symbol"],
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPrice(item["symbol"]),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "+3.2%",
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildMarketTiles({required String type}) {
    final filtered = allSymbols
        .where((s) => s["type"] == type)
        .take(3)
        .toList();

    return filtered.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(item["image"], width: 32, height: 32),
          ),
          title: Text(
            item["name"],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            item["symbol"],
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPrice(item["symbol"]),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "+2.4%",
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  String formatPrice(String symbol) {
    final p = prices[symbol];
    if (p == null) return "N/A";
    return "\$${p.toStringAsFixed(2)}";
  }

  Widget recommendationCard(
    String symbol,
    String name,
    String image,
    String price,
    String recommendation,
  ) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (image.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(image, width: 32, height: 32),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  recommendation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            symbol,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Price',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: Color(0xFF4CAF50),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
