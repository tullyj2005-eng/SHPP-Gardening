import 'plants.dart'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_logic.dart';

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
            color: isDark 
                ? const Color(0xFF1A1C1E) 
                : (ThemeManager.isRedMode 
                    ? const Color.fromARGB(255, 120, 10, 0)
                    : Colors.green.shade50),
            child: ListView(
              children: [
                DrawerHeader(
                  child: Text(
                    'Κατηγορίες', 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                      color: (isDark || ThemeManager.isRedMode) ? Colors.white : Colors.black87,
                    )
                  )
                ),
                ListTile(
                  leading: Icon(
                    Icons.spa, 
                    color: ThemeManager.isRedMode 
                        ? Colors.white70 
                        : (isDark ? Colors.greenAccent : Colors.green),
                  ),
                  title: Text(
                    'Αρωματικά',
                    style: TextStyle(
                      color: (isDark || ThemeManager.isRedMode) ? Colors.white70 : Colors.black87
                    ),
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
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('plants')
                      .orderBy('createdAt', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    // Build dynamic plant cards from Firestore
                    List<Widget> dynamicCards = [];
                    if (snapshot.hasData) {
                      dynamicCards = snapshot.data!.docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final name = data['name'] ?? '';
                        return plantCard(
                          context,
                          name,
                          data['description'] ?? '',
                          data['howTo'] ?? '',
                          () => widget.onTrack(name),
                        );
                      }).toList();
                    }

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
                                'Αρωματικά', 
                                style: TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold, 
                                  color: ThemeManager.isRedMode
                                      ? const Color.fromARGB(255, 161, 16, 3)
                                      : (isDark ? Colors.greenAccent : Colors.green.shade900),
                                )
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 2, 
                                width: 100, 
                                color: ThemeManager.isRedMode
                                    ? const Color.fromARGB(255, 161, 16, 3).withOpacity(0.5)
                                    : (isDark ? Colors.greenAccent.withOpacity(0.5) : Colors.green.shade300),
                              ),
                            ],
                          ),
                        ),
                        _buildResponsiveGrid(constraints.maxWidth, [
                          // Hardcoded originals always shown first
                          mint(context, () => widget.onTrack('Μέντα')),
                          rosemary(context, () => widget.onTrack('Δεντρολίβανο')),
                          dittany(context, () => widget.onTrack('Δίκταμο')),
                          thyme(context, () => widget.onTrack('Θυμάρι')),
                          oregano(context, () => widget.onTrack('Ρίγανη')),
                          // Firestore-added plants appear after
                          ...dynamicCards,
                        ]),
                      ],
                    );
                  },
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