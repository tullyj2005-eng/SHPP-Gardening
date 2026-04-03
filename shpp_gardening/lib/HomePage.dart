import 'package:flutter/material.dart';
import 'main.dart'; // Ensure this points to where TrackedPlant is defined

class HomeScreen extends StatelessWidget {
  final List<TrackedPlant> tracked;

  const HomeScreen({super.key, required this.tracked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row( 
        children: [
          // --- SIDEBAR (Account & Settings) ---
          Container(
            width: 150, 
            color: Colors.green.shade50,
            child: Column(
              children: [
                // 1. ACCOUNT SECTION
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.green.shade800),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.green),
                  ),
                  accountName: const Text("Guest Student"),
                  accountEmail: const Text("Tap to Sign In"),
                ),

                // 2. JOIN CLASS SECTION
                ListTile(
                  leading: const Icon(Icons.group_add, color: Colors.green),
                  title: const Text('Join Teacher\'s Class'),
                  subtitle: const Text('Enter class code'),
                  onTap: () {
                    // Logic for joining a class pop-up would go here
                  },
                ),
                
                const Divider(), 

                // SETTINGS SECTION
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: const Text('Settings'),
                  onTap: () {
                    // Logic to open settings
                  },
                ),

                const Spacer(), // Pushes the version info to the bottom
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("v1.0.0", style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),

          // --- MAIN CONTENT (Your Plant Cards) ---
          Expanded(
            child: Scaffold( 
              appBar: AppBar(
                title: const Text("My Garden"),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              body: tracked.isEmpty
                  ? const Center(child: Text("No plants being tracked yet."))
                  : ListView.builder(
                      itemCount: tracked.length,
                      itemBuilder: (context, index) {
                        final plant = tracked[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(plant.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("Progress: ${(plant.waterProgress * 100).toInt()}%"),
                            trailing: const Icon(Icons.water_drop, color: Colors.blue),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}