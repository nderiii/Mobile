import 'package:flutter/material.dart';
import 'package:bfu/services/stock_apis.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SEARCH BAR
            const SizedBox(height: 35),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search stocks, crypto...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //PORTFOLIO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 82, 178, 126),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Your Investment Power",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$3,245.76",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "+ \$154 today",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //TODAY'S TOP PICKS
            const Text(
              "Today's Suggestions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  suggestionCard("AAPL", "+2.4%", Colors.green),
                  suggestionCard("TSLA", "-1.1%", Colors.red),
                  suggestionCard("BTC", "+4.8%", Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // CRYPTO + STOCKS SECTIONS
            const Text(
              "Crypto Market",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            cryptoTile("Bitcoin (BTC)", "\$46,210", "+3.5%"),
            cryptoTile("Ethereum (ETH)", "\$2,740", "+1.7%"),

            const SizedBox(height: 20),
            const Text(
              "Stock Market",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            stockTile("Apple (AAPL)", "\$173.20", "+2.4%"),
            stockTile("Tesla (TSLA)", "\$189.15", "-1.1%"),
          ],
        ),
      ),
    );
  }

  // HORIZONTAL SUGGESTION CARDS
  Widget suggestionCard(String title, String change, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            change,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // CRYPTO ROW
  Widget cryptoTile(String name, String price, String change) {
    return ListTile(
      leading: const Icon(Icons.currency_bitcoin, size: 30),
      title: Text(name),
      subtitle: Text(price),
      trailing: Text(
        change,
        style: TextStyle(
          color: change.startsWith('+') ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // STOCK ROW
  Widget stockTile(String name, String price, String change) {
    return ListTile(
      leading: const Icon(Icons.show_chart, size: 30),
      title: Text(name),
      subtitle: Text(price),
      trailing: Text(
        change,
        style: TextStyle(
          color: change.startsWith('+') ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
