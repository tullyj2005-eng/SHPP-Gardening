import 'package:flutter/material.dart';

class PlantDetailView extends StatelessWidget {
  final String plantName;

  const PlantDetailView({super.key, required this.plantName});

  // A local map for plant data - in a larger app, this could move to Firestore
  static const Map<String, Map<String, String>> plantCareData = {
    'Tomato': {
      'care': 'Requires at least 6-8 hours of sunlight. Water at the base of the plant to avoid leaf diseases. Support with a stake or cage.',
      'problems': 'Blossom end rot (lack of calcium), Aphids, and Overwatering leading to root rot.'
    },
    'Basil': {
      'care': 'Thrives in warm weather with well-drained soil. Pinch off the center stalks to prevent flowering and encourage bushier growth.',
      'problems': 'Downy mildew (yellowing leaves) and Fusarium wilt.'
    },
    // Add more plants as needed

    /// Ignore the above text this was an old snippet, the below is the new one 
  };

  @override
  Widget build(BuildContext context) {
    // Default data if the plant isn't in our map
    final info = plantCareData[plantName] ?? {
      'care': 'General care: Ensure proper sunlight and consistent watering schedules.',   //Have Katerina Translate this here 
      'problems': 'Watch for common pests like spider mites or signs of nutrient deficiency.'
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('$plantName Care Guide'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(Icons.wb_sunny, "How to Care"),
            Text(info['care']!, style: const TextStyle(fontSize: 16, height: 1.5)),
            
            const SizedBox(height: 30),
            
            _buildSectionHeader(Icons.report_problem, "Potential Problems"),
            Text(info['problems']!, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade800),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}