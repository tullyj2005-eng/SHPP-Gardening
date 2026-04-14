import 'plants.dart'; 
import 'package:flutter/material.dart';

// --- INFO SCREEN ---
class InfoScreen extends StatefulWidget {
  final Function(String) onTrack;
  
  const InfoScreen({super.key, required this.onTrack});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final GlobalKey _aromaticsKey = GlobalKey();

  void _scrollToAromatics() {
    Scrollable.ensureVisible(
      _aromaticsKey.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          // --- CATEGORY SIDEBAR ---
          Container(
            width: 200,
            // Theme-aware color logic
            color: isDark ? const Color(0xFF1A1C1E) : Colors.green.shade50,
            child: ListView(
              children: [
                DrawerHeader(
                  child: Text(
                    'Categories', 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    )
                  )
                ),
                ListTile(
                  leading: Icon(Icons.spa, color: isDark ? Colors.greenAccent : Colors.green),
                  title: Text(
                    'Aromatics',
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                  ),
                  onTap: _scrollToAromatics,
                ),
              ],
            ),
          ),
          
          // --- MAIN CONTENT ---
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Padding(
                      key: _aromaticsKey,
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aromatics', 
                            style: TextStyle(
                              fontSize: 26, 
                              fontWeight: FontWeight.bold, 
                              // Use light green in Dark Mode, dark green in Light Mode
                              color: isDark ? Colors.greenAccent : Colors.green.shade900
                            )
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 2, 
                            width: 100, 
                            color: isDark ? Colors.greenAccent.withOpacity(0.5) : Colors.green.shade300
                          ),
                        ],
                      ),
                    ),
                    _buildResponsiveGrid(constraints.maxWidth, [
                      mint(context, () => widget.onTrack('Mojito Mint')),
                      rosemary(context, () => widget.onTrack('Rosemary')),
                    ]),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResponsiveGrid(double maxWidth, List<Widget> children) {
    int columns = (maxWidth / 180).floor().clamp(1, 4);
    double spacing = 16.0;
    double itemWidth = (maxWidth - (spacing * (columns + 1))) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: children.map((card) => SizedBox(width: itemWidth, child: card)).toList(),
    );
  }
}