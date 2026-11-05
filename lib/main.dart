import 'package:flutter/material.dart';

void main() {
  runApp(const TradePlusApp());
}

class TradePlusApp extends StatelessWidget {
  const TradePlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Plus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  double _balance = 24500.50;

  final List> _watchlist = [
    {'name': 'Bitcoin', 'symbol': 'BTC/USDT', 'price': r'$67,420.00', 'change': '+3.45%', 'isUp': true},
    {'name': 'Ethereum', 'symbol': 'ETH/USDT', 'price': r'$3,550.25', 'change': '+1.82%', 'isUp': true},
    {'name': 'Tesla', 'symbol': 'TSLA', 'price': r'$245.10', 'change': '-0.65%', 'isUp': false},
    {'name': 'Apple', 'symbol': 'AAPL', 'price': r'$182.30', 'change': '+0.92%', 'isUp': true},
    {'name': 'Gold', 'symbol': 'XAU/USD', 'price': r'$2,340.80', 'change': '+0.41%', 'isUp': true},
  ];

  void _executeTrade(String assetSymbol) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('Trade $assetSymbol', style: const TextStyle(color: Colors.white)),
        content: const Text(
          'Order executed successfully in simulation mode.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.trending_up, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text('Trade Plus', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Balance', style: TextStyle(color: Colors.white60, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    '\$${_balance.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Watchlist', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _watchlist.length,
              itemBuilder: (context, index) {
                final item = _watchlist[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: constنیز const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(item['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(item['symbol'], style: const TextStyle(color: Colors.white60)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item['price'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(item['change'], style: TextStyle(color: item['isUp'] ? Colors.green : Colors.red)),
                      ],
                    ),
                    onTap: () => _executeTrade(item['symbol']),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
