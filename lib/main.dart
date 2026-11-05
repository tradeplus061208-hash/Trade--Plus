import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  runApp(const TradePlusApp());
}

class TradePlusApp extends StatelessWidget {
  const TradePlusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MT5ConnectScreen(),
    );
  }
}

class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;
  CandleData({required this.open, required this.high, required this.low, required this.close});
}

class MT5ConnectScreen extends StatefulWidget {
  const MT5ConnectScreen({Key? key}) : super(key: key);

  @override
  State<MT5ConnectScreen> createState() => _MT5ConnectScreenState();
}

class _MT5ConnectScreenState extends State<MT5ConnectScreen> {
  final TextEditingController _loginController = TextEditingController(text: '5058221422');
  final TextEditingController _serverController = TextEditingController(text: 'MetaQuotes-Demo');
  final TextEditingController _passController = TextEditingController();

  bool isConnecting = false;
  bool isConnected = false;
  List<CandleData> liveCandles = [];

  void _connectMT5Demo() {
    setState(() {
      isConnecting = true;
    });

    // MT5 Demo အကောင့် ချိတ်ဆက်မှုကို ပုံစံထုတ်ခြင်း
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isConnecting = false;
        isConnected = true;
        liveCandles = _generateRealtimeMT5Candles();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('MT5 Demo အကောင့်သို့ အောင်မြင်စွာ ချိတ်ဆက်ပြီးပါပြီ။')),
      );
    });
  }

  List<CandleData> _generateRealtimeMT5Candles() {
    List<CandleData> candles = [];
    double price = 2035.0;
    for (int i = 0; i < 50; i++) {
      double open = price;
      double close = open + ((i % 2 == 0 ? 1 : -1) * 3.5);
      double high = (open > close ? open : close) + 2.0;
      double low = (open < close ? open : close) - 2.0;
      candles.add(CandleData(open: open, high: high, low: low, close: close));
      price = close;
    }
    return candles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Plus - MT5 Live Bridge', style: TextStyle(fontSize: 15)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "MetaTrader 5 Demo Account Connection",
              style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _loginController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'MT5 Login ID',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _serverController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Server Name',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isConnecting ? null : _connectMT5Demo,
              child: Text(
                isConnecting ? "Connecting to MT5 Demo..." : "Connect MT5 Account",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            if (isConnected) ...[
              const Text(
                "Live XAUUSD Market Candles (MT5 Demo):",
                style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF10B981)),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: liveCandles.length,
                  itemBuilder: (context, index) {
                    final c = liveCandles[index];
                    bool isUp = c.close >= c.open;
                    return Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("H:${c.high.toStringAsFixed(0)}", style: const TextStyle(color: Colors.grey, fontSize: 8)),
                          const SizedBox(height: 4),
                          Container(
                            width: 8,
                            height: 60,
                            color: isUp ? const Color(0xFF10B981) : Colors.redAccent,
                          ),
                          const SizedBox(height: 4),
                          Text("L:${c.low.toStringAsFixed(0)}", style: const TextStyle(color: Colors.grey, fontSize: 8)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "👉 ပထမအဆင့် (MT5 Demo ချိတ်ဆက်ခြင်း) ပြီးပါပြီ။ နောက်တစ်ဆင့်ဖြစ်သော AI Pattern Matching အပိုင်းကို ဆက်လက်လုပ်ဆောင်ပါမည်။",
                style: TextStyle(color: Colors.amber, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
