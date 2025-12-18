import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/news_apis.dart';

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

  // API Service instance
  final NewsApis _newsApis = NewsApis();

  // News data storage
  List<dynamic> allNews = [];
  List<dynamic> stockNews = [];
  List<dynamic> cryptoNews = [];
  bool isLoading = true;
  String? errorMessage;

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

    // Fetch news data from API
    _fetchNewsData();
  }

  /// Fetches news data from the Vantage API for different topics
  Future<void> _fetchNewsData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch stock and crypto news in parallel
      final results = await Future.wait([
        _newsApis.getNewsBySymbol('technology'),
        _newsApis.getNewsBySymbol('blockchain'),
      ]);

      setState(() {
        stockNews = results[0];
        cryptoNews = results[1];
        // Combine all news for "All" filter
        allNews = [...stockNews, ...cryptoNews];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load news: $e';
        isLoading = false;
      });
      print('Error fetching news: $e');
    }
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

  /// Filters news based on the selected filter
  List<dynamic> _getFilteredNews() {
    if (isLoading || errorMessage != null) return [];

    switch (selectedFilter) {
      case "Stocks":
        return stockNews;
      case "Crypto":
        return cryptoNews;
      case "Favorites":
        // Filter news that match favorite symbols
        return allNews.where((news) {
          final tickerSentiment = news['ticker_sentiment'] as List<dynamic>?;
          if (tickerSentiment == null) return false;
          return tickerSentiment.any(
            (ticker) => favoriteSymbols.contains(ticker['ticker'] as String?),
          );
        }).toList();
      case "All":
      default:
        return allNews;
    }
  }

  /// Formats timestamp to relative time
  String _getTimeAgo(String? timestamp) {
    if (timestamp == null) return 'Recently';
    try {
      final newsTime = DateTime.parse(timestamp);
      final difference = DateTime.now().difference(newsTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
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
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4CAF50),
                          ),
                        )
                      : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchNewsData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4CAF50),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchNewsData,
                          color: const Color(0xFF4CAF50),
                          child: _buildNewsList(),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the news list from API data
  Widget _buildNewsList() {
    final filteredNews = _getFilteredNews();

    if (filteredNews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No news available',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: filteredNews.length,
      itemBuilder: (context, index) {
        final newsItem = filteredNews[index];
        final title = newsItem['title'] as String? ?? 'No Title';
        final summary = newsItem['summary'] as String? ?? '';
        final source = newsItem['source'] as String? ?? 'Unknown Source';
        final timePublished = newsItem['time_published'] as String?;
        final bannerImage = newsItem['banner_image'] as String?;

        // Extract ticker information for category and change percent
        final tickerSentiment = newsItem['ticker_sentiment'] as List<dynamic>?;
        String category = 'Market';
        String? changePercent;
        bool isPositive = true;

        if (tickerSentiment != null && tickerSentiment.isNotEmpty) {
          final firstTicker = tickerSentiment[0];
          final ticker = firstTicker['ticker'] as String?;

          // Determine category based on ticker
          if (ticker != null) {
            if (['BTC', 'ETH', 'CRYPTO'].any((c) => ticker.contains(c))) {
              category = 'Crypto';
            } else {
              category = 'Stock';
            }
          }

          // Get sentiment score as percentage
          final sentimentScore =
              firstTicker['ticker_sentiment_score'] as double?;
          if (sentimentScore != null) {
            final percentChange = (sentimentScore * 100).toStringAsFixed(1);
            isPositive = sentimentScore >= 0;
            changePercent = '${isPositive ? '+' : ''}$percentChange%';
          }
        }

        // Check if this news is about a favorite symbol
        final isPriority =
            tickerSentiment?.any(
              (ticker) => favoriteSymbols.contains(ticker['ticker'] as String?),
            ) ??
            false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildNewsCard(
            title: title,
            source: source,
            time: _getTimeAgo(timePublished),
            category: category,
            description: summary,
            imageUrl: bannerImage,
            isPriority: isPriority,
            changePercent: changePercent,
            isPositive: isPositive,
            newsUrl: newsItem['url'] as String?,
          ),
        );
      },
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
    String? newsUrl,
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
