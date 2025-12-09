import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bfu/widget/button_widget.dart';
import 'package:bfu/widget/text_widget.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final TextEditingController _budgetController = TextEditingController(
    text: '5000',
  );
  String _riskTolerance = 'Moderate';
  String _investmentGoal = 'Long-term Growth';
  String _timeHorizon = '3-5 years';
  List<String> _preferredSectors = ['Technology', 'Healthcare'];
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    // Hide system navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
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
      body: Stack(
        children: [
          Column(
            children: [
              // HEADER WITH PROFILE
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 20,
                  20,
                  30,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Picture
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // INVESTMENT PREFERENCES HEADER
                        const Text(
                          'Investment Preferences',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // BUDGET CARD
                        Container(
                          padding: const EdgeInsets.all(20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4CAF50,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.attach_money,
                                      color: Color(0xFF4CAF50),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Investment Budget',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _budgetController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4CAF50),
                                ),
                                decoration: InputDecoration(
                                  prefixText: '\$ ',
                                  prefixStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  hintText: 'Enter amount',
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // RISK TOLERANCE
                        _buildSelectionCard(
                          icon: Icons.speed,
                          title: 'Risk Tolerance',
                          selectedValue: _riskTolerance,
                          options: ['Conservative', 'Moderate', 'Aggressive'],
                          onChanged: (value) {
                            setState(() => _riskTolerance = value!);
                          },
                        ),

                        const SizedBox(height: 16),

                        // INVESTMENT GOAL
                        _buildSelectionCard(
                          icon: Icons.flag_outlined,
                          title: 'Investment Goal',
                          selectedValue: _investmentGoal,
                          options: [
                            'Short-term Gains',
                            'Long-term Growth',
                            'Retirement',
                            'Passive Income',
                          ],
                          onChanged: (value) {
                            setState(() => _investmentGoal = value!);
                          },
                        ),

                        const SizedBox(height: 16),

                        // TIME HORIZON
                        _buildSelectionCard(
                          icon: Icons.schedule,
                          title: 'Time Horizon',
                          selectedValue: _timeHorizon,
                          options: [
                            'Less than 1 year',
                            '1-3 years',
                            '3-5 years',
                            '5+ years',
                          ],
                          onChanged: (value) {
                            setState(() => _timeHorizon = value!);
                          },
                        ),

                        const SizedBox(height: 16),

                        // PREFERRED SECTORS
                        Container(
                          padding: const EdgeInsets.all(20),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4CAF50,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.category_outlined,
                                      color: Color(0xFF4CAF50),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Preferred Sectors',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    [
                                      'Technology',
                                      'Healthcare',
                                      'Finance',
                                      'Energy',
                                      'Real Estate',
                                      'Consumer',
                                    ].map((sector) {
                                      final isSelected = _preferredSectors
                                          .contains(sector);
                                      return FilterChip(
                                        label: Text(sector),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              _preferredSectors.add(sector);
                                            } else {
                                              _preferredSectors.remove(sector);
                                            }
                                          });
                                        },
                                        selectedColor: const Color(
                                          0xFF4CAF50,
                                        ).withOpacity(0.2),
                                        checkmarkColor: const Color(0xFF4CAF50),
                                        labelStyle: TextStyle(
                                          color: isSelected
                                              ? const Color(0xFF4CAF50)
                                              : Colors.grey[700],
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ACTIVITY STATS
                        const Text(
                          'Your Activity',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Favorites',
                                '12',
                                Icons.favorite,
                                const Color(0xFFE91E63),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Recommendations',
                                '8',
                                Icons.lightbulb_outline,
                                const Color(0xFFFF9800),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // ACCOUNT SETTINGS
                        const Text(
                          'Account Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildMenuCard(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {},
                        ),

                        const SizedBox(height: 30),

                        // SAVE BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 12),
                                      Text('Preferences saved successfully'),
                                    ],
                                  ),
                                  backgroundColor: const Color(0xFF4CAF50),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save Preferences',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // SIGN OUT BUTTON
                        Container(
                          width: double.infinity,
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
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () => _showSignOutDialog(context),
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Color(0xFFE53935),
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFE53935),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // INSTAGRAM-STYLE BOTTOM NAV BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_outlined, Icons.home, "Home", 0),
                  _buildNavItem(
                    Icons.explore_outlined,
                    Icons.explore,
                    "Explore",
                    1,
                  ),
                  _buildNavItem(
                    Icons.article_outlined,
                    Icons.article,
                    "News",
                    2,
                  ),
                  _buildNavItem(
                    Icons.person_outline,
                    Icons.person,
                    "Profile",
                    3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
  ) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);

        if (index == 0) {
          Navigator.pop(context); // Go back to dashboard
        } else if (index == 1) {
          Navigator.pushNamed(context, '/explore');
        } else if (index == 2) {
          Navigator.pushNamed(context, '/news');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          isSelected ? filledIcon : outlinedIcon,
          color: isSelected ? Colors.black : Colors.grey,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildStatCard(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String selectedValue,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF4CAF50), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF4CAF50),
              ),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF4CAF50), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout, color: Color(0xFFE53935)),
              SizedBox(width: 12),
              Text('Sign Out'),
            ],
          ),
          content: const Text(
            'Are you sure you want to sign out of your account?',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Signed out successfully'),
                      ],
                    ),
                    backgroundColor: const Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
