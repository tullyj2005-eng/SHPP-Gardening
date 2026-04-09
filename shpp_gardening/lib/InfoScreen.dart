
import 'Plants.dart'; 
import 'package:flutter/material.dart';


// --- INFO SCREEN ---
class InfoScreen extends StatefulWidget {
  // 1. ADD THIS LINE: It tells the screen it MUST receive the tracking function
  final Function(String) onTrack;
  
  // 2. ADD THIS CONSTRUCTOR: It maps the input to the variable above
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
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.green.shade50,
            child: ListView(
              children: [
                const DrawerHeader(child: Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ListTile(
                  leading: const Icon(Icons.spa),
                  title: const Text('Aromatics'),
                  onTap: _scrollToAromatics,
                ),
              ],
            ),
          ),
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
                          Text('Aromatics', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                          const SizedBox(height: 4),
                          Container(height: 2, width: 100, color: Colors.green.shade300),
                        ],
                      ),
                    ),
                    _buildResponsiveGrid(constraints.maxWidth, [
                      // 3. USE 'widget.onTrack' HERE: This reaches up to the main class
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