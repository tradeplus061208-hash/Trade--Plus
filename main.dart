import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const TradePlusScreen(),
    );
  }
}

class CandleModel {
  final double open;
  final double high;
  final double low;
  final double close;
  final bool isMatched;

  CandleModel({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.isMatched = false,
  });
}

class TradePlusScreen extends StatefulWidget {
  const TradePlusScreen({Key? key}) : super(key: key);

  @override
  State<TradePlusScreen> createState() => _TradePlusScreenState();
}

class _TradePlusScreenState extends State<TradePlusScreen> {
  String selectedSymbol = 'XAUUSD';
  String selectedTimeframe = 'H1';
  bool isSearching = false;
  bool showResults = false;
  
  String? uploadedImageUrl;

  final List<String> symbols = ['XAUUSD', 'BTCUSD', 'EURUSD'];
  final List<String> timeframes = ['M1', 'M5', 'M15', 'M30', 'H1', 'H4', 'D1', 'W1', 'MN'];

  void _pickImageFromDevice() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedImageUrl = reader.result as String?;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chart ပုံ အောင်မြင်စွာ တင်ပြီးပါပြီ။'),
              duration: Duration(milliseconds: 1200),
            ),
          );
        });
      }
    });
  }

  List<CandleModel> generateMT5Candles() {
    List<CandleModel> candles = [];
    double currentPrice = 2030.0;

    for (int i = 0; i < 150; i++) {
      double open = currentPrice;
      double change = ((i % 7 == 0 || i % 11 == 0) ? -1 : 1) * ((i % 5 + 1) * 2.5);
      double close = open + change;

      double high = (open > close ? open : close) + (i % 3 + 1) * 1.8;
      double low = (open < close ? open : close) - (i % 4 + 1) * 1.5;

      bool isMatchedPattern = (i >= 50 && i <= 75);

      candles.add(CandleModel(
        open: open,
        high: high,
        low: low,
        close: close,
        isMatched: isMatchedPattern,
      ));

      currentPrice = close;
    }
    return candles;
  }

  final historicalMatches = [
    {
      "match": "94.5%", 
      "date": "2024-05-12 14:00", 
      "desc": "Strong bullish breakout pattern",
      "pastRange": "လွန်ခဲ့သော ၅၀ နာရီ",
      "futureRange": "ရှေ့သို့ နာရီ ၁၀၀"
    },
    {
      "match": "89.2%", 
      "date": "2023-11-04 09:30", 
      "desc": "Double bottom reversal match",
      "pastRange": "လွန်ခဲ့သော ၅၀ နာရီ",
      "futureRange": "ရှေ့သို့ နာရီ ၁၀၀"
    },
    {
      "match": "85.1%", 
      "date": "2023-08-19 16:45", 
      "desc": "Consolidation zone similarity",
      "pastRange": "လွန်ခဲ့သော ၅၀ နာရီ",
      "futureRange": "ရှေ့သို့ နာရီ ၁၀၀"
    },
  ];

  void _showExtendedChart(BuildContext context, Map<String, String> item) {
    final candles = generateMT5Candles();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Match: ${item['match']} ($selectedSymbol)",
                      style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Text("TF: $selectedTimeframe | Date: ${item['date']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Note: ${item['desc']}", style: const TextStyle(color: Colors.amber, fontSize: 11)),
                const SizedBox(height: 12),
                
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "◀️ ${item['pastRange']}", 
                          style: const TextStyle(color: Colors.cyanAccent, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text("|", style: TextStyle(color: Colors.grey)),
                      Expanded(
                        child: Text(
                          "${item['futureRange']} ▶️", 
                          style: const TextStyle(color: Colors.lightGreenAccent, fontSize: 11),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: const Color(0xFF060D18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InteractiveViewer(
                      panEnabled: true,
                      scaleEnabled: true,
                      minScale: 1.0,
                      maxScale: 5.0,
                      child: SizedBox(
                        width: 2500,
                        height: 280,
                        child: CustomPaint(
                          painter: MT5ChartPainter(candles: candles),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "👉 Swipe left/right for MT5 Real Candles (Past 50 & Future 100)",
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TradePlus - Live Pattern Finder',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Select Asset:", style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 6),
            Row(
              children: symbols.map((symbol) {
                final isSelected = selectedSymbol == symbol;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: isSelected
                              ? const Color(0xFF10B981)
                              : const Color(0xFF1E293B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: () => setState(() => selectedSymbol = symbol),
                        child: Text(
                          symbol, 
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            const Text("Select Timeframe:", style: TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: timeframes.map((tf) {
                  final isSelected = selectedTimeframe == tf;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: SizedBox(
                      height: 28,
                      child: ChoiceChip(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        label: Text(tf, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.grey)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF10B981),
                        backgroundColor: const Color(0xFF1E293B),
                        onSelected: (selected) => setState(() => selectedTimeframe = tf),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Uploaded Image View with Full Pan & Zoom Support
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Upload Chart Screenshot:", style: TextStyle(color: Colors.grey, fontSize: 11)),
                if (uploadedImageUrl != null)
                  TextButton.icon(
                    onPressed: _pickImageFromDevice,
                    icon: const Icon(Icons.refresh, size: 14, color: Color(0xFF10B981)),
                    label: const Text("Change Image", style: TextStyle(color: Color(0xFF10B981), fontSize: 11)),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: uploadedImageUrl == null ? _pickImageFromDevice : null,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF060D18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: uploadedImageUrl != null ? const Color(0xFF10B981) : Colors.grey.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: uploadedImageUrl == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.cloud_upload_outlined, size: 40, color: Color(0xFF10B981)),
                            SizedBox(height: 8),
                            Text("Tap to Choose Chart Image", style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        )
                      : InteractiveViewer(
                          // ဇူးမ်ဆွဲခြင်းနှင့် အပေါ်အောက်၊ ဘယ်ညာရွှေ့ခြင်း (Pan & Zoom) ကို အပြည့်အဝ ခွင့်ပြုထားသည်
                          panEnabled: true,
                          scaleEnabled: true,
                          minScale: 0.5,
                          maxScale: 6.0,
                          child: Center(
                            child: Image.network(
                              uploadedImageUrl!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            if (uploadedImageUrl != null)
              const Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Center(
                  child: Text(
                    "👉 You can now pinch-to-zoom and drag/pan freely in all directions.",
                    style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (uploadedImageUrl == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ကျေးဇူးပြု၍ Chart ပုံ အရင်တင်ပါ။')),
                  );
                  return;
                }
                setState(() {
                  isSearching = true;
                  showResults = false;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    isSearching = false;
                    showResults = true;
                  });
                });
              },
              icon: isSearching
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.search, color: Colors.white, size: 20),
              label: Text(
                isSearching ? "Searching Patterns..." : "Search Patterns",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            if (showResults) ...[
              const Text(
                "Best Historical Matches (Tap card for Full Screen):",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 12),
              ...historicalMatches.map((item) {
                final previewCandles = generateMT5Candles();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () => _showExtendedChart(context, item),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.6), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Match: ${item['match']}", 
                                style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "$selectedSymbol | $selectedTimeframe", 
                                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text("Date: ${item['date']}", style: const TextStyle(color: Colors.amber, fontSize: 12)),
                          Text("Desc: ${item['desc']}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          const SizedBox(height: 10),
                          
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: const Color(0xFF060D18),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: CustomPaint(
                              painter: MT5ChartPainter(candles: previewCandles),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              "🔍 Tap to view full screen interactive MT5 chart", 
                              style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class MT5ChartPainter extends CustomPainter {
  final List<CandleModel> candles;
  MT5ChartPainter({required this.candles});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final paintBullish = Paint()..color = const Color(0xFF00B57A)..style = PaintingStyle.fill;
    final paintBearish = Paint()..color = const Color(0xFFFF3B30)..style = PaintingStyle.fill;
    final paintHighlight = Paint()..color = const Color(0xFFFFB800)..style = PaintingStyle.fill;

    final wickBullish = Paint()..color = const Color(0xFF00B57A)..strokeWidth = 1.2;
    final wickBearish = Paint()..color = const Color(0xFFFF3B30)..strokeWidth = 1.2;
    final wickHighlight = Paint()..color = const Color(0xFFFFB800)..strokeWidth = 1.8;

    final gridPaint = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 0.5;
    for (double y = 0; y < size.height; y += 25) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    double minPrice = candles.first.low;
    double maxPrice = candles.first.high;
    for (var c in candles) {
      if (c.low < minPrice) minPrice = c.low;
      if (c.high > maxPrice) maxPrice = c.high;
    }

    double priceRange = (maxPrice - minPrice) == 0 ? 1.0 : (maxPrice - minPrice);
    double candleWidth = size.width / candles.length;

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = i * candleWidth + candleWidth / 2;

      double getY(double price) {
        return size.height - ((price - minPrice) / priceRange * (size.height - 30) + 15);
      }

      bool isBullish = c.close >= c.open;
      Paint bodyPaint = c.isMatched ? paintHighlight : (isBullish ? paintBullish : paintBearish);
      Paint wickPaint = c.isMatched ? wickHighlight : (isBullish ? wickBullish : wickBearish);

      double highY = getY(c.high);
      double lowY = getY(c.low);
      double openY = getY(c.open);
      double closeY = getY(c.close);

      canvas.drawLine(Offset(x, highY), Offset(x, lowY), wickPaint);

      double top = openY < closeY ? openY : closeY;
      double bottom = openY > closeY ? openY : closeY;
      double bodyHeight = bottom - top;
      if (bodyHeight < 2.0) bodyHeight = 2.0;

      double rectWidth = (candleWidth * 0.65).clamp(3.0, 10.0);
      canvas.drawRect(
        Rect.fromLTWH(x - rectWidth / 2, top, rectWidth, bodyHeight),
        bodyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
