import 'package:flutter/material.dart';
import 'package:bfu/services/stock_apis.dart';
import 'package:bfu/pages/profilepage.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  final StockApis api = StockApis();

  List<dynamic> allSymbols = [];
  Map<String, double?> prices = {};
  Set<String> favoriteSymbols = {}; // Track favorites
  String searchQuery = "";
  String selectedCategory = "All"; // All, Stocks, Crypto
  String sortBy = "Name"; // Name, Price, Change
  bool isLoading = true;
  int _currentIndex = 1;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    try {
      final symbols = await api.loadSymbols();
      allSymbols = symbols;
      prices = await api.fetchAllPricesParallel();
      _animationController.forward();
    } catch (e, s) {
      print("ERROR IN EXPLORE: $e");
      print(s);
    }

    setState(() => isLoading = false);
  }

  List<dynamic> getFilteredSymbols() {
    var filtered = allSymbols.where((item) {
      // Search filter
      if (searchQuery.isNotEmpty) {
        final symbol = item["symbol"].toString().toLowerCase();
        final name = item["name"].toString().toLowerCase();
        final query = searchQuery.toLowerCase();
        if (!symbol.contains(query) && !name.contains(query)) {
          return false;
        }
      }

      // Category filter
      if (selectedCategory != "All") {
        if (selectedCategory == "Stocks" && item["type"] != "stock") {
          return false;
        }
        if (selectedCategory == "Crypto" && item["type"] != "crypto") {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort
    if (sortBy == "Name") {
      filtered.sort((a, b) => a["name"].compareTo(b["name"]));
    } else if (sortBy == "Price") {
      filtered.sort((a, b) {
        final priceA = prices[a["symbol"]] ?? 0;
        final priceB = prices[b["symbol"]] ?? 0;
        return priceB.compareTo(priceA);
      });
    }

    return filtered;
  }

  void toggleFavorite(String symbol) {
    setState(() {
      if (favoriteSymbols.contains(symbol)) {
        favoriteSymbols.remove(symbol);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed $symbol from favorites'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        favoriteSymbols.add(symbol);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $symbol to favorites'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF4CAF50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredSymbols = getFilteredSymbols();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Stack(
                children: [
                  Column(
                    children: [
                      // HEADER SECTION
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
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
                                      "Explore Markets",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Browse and favorite assets",
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
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${favoriteSymbols.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // SEARCH BAR
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() => searchQuery = value);
                                },
                                decoration: const InputDecoration(
                                  hintText: "Search stocks or crypto...",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search, color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // CATEGORY CHIPS
                            Row(
                              children: [
                                _buildCategoryChip("All"),
                                const SizedBox(width: 8),
                                _buildCategoryChip("Stocks"),
                                const SizedBox(width: 8),
                                _buildCategoryChip("Crypto"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // FILTERS BAR
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${filteredSymbols.length} Assets',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Sort by: ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: sortBy,
                                  underline: const SizedBox(),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  items: ["Name", "Price", "Change"].map((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => sortBy = value!);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ASSET LIST
                      Expanded(
                        child: filteredSymbols.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No assets found',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try adjusting your search or filters',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  12,
                                  20,
                                  100,
                                ),
                                itemCount: filteredSymbols.length,
                                itemBuilder: (context, index) {
                                  final item = filteredSymbols[index];
                                  final isFavorite = favoriteSymbols.contains(
                                    item["symbol"],
                                  );

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: isFavorite
                                          ? Border.all(
                                              color: const Color(
                                                0xFFE91E63,
                                              ).withOpacity(0.3),
                                              width: 2,
                                            )
                                          : null,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Image.asset(
                                          item["image"],
                                          width: 32,
                                          height: 32,
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item["name"],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: item["type"] == "stock"
                                                  ? const Color(
                                                      0xFF2196F3,
                                                    ).withOpacity(0.1)
                                                  : const Color(
                                                      0xFFFF9800,
                                                    ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item["type"] == "stock"
                                                  ? "STOCK"
                                                  : "CRYPTO",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: item["type"] == "stock"
                                                    ? const Color(0xFF2196F3)
                                                    : const Color(0xFFFF9800),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        item["symbol"],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFE8F5E9,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  "+2.4%",
                                                  style: TextStyle(
                                                    color: Color(0xFF4CAF50),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFavorite
                                                  ? const Color(0xFFE91E63)
                                                  : Colors.grey,
                                            ),
                                            onPressed: () =>
                                                toggleFavorite(item["symbol"]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = category);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);

        if (index == 0) {
          Navigator.pop(context); // Go back to dashboard
        } else if (index == 3) {
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

  String formatPrice(String symbol) {
    final p = prices[symbol];
    if (p == null) return "N/A";
    return "\$${p.toStringAsFixed(2)}";
  }
}
