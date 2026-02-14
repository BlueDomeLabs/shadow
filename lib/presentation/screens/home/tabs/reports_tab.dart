// lib/presentation/screens/home/tabs/reports_tab.dart
// Reports tab placeholder for PDF health reports.

import 'package:flutter/material.dart';

/// Reports tab showing placeholder for health report generation.
class ReportsTab extends StatelessWidget {
  final String? profileName;

  const ReportsTab({super.key, this.profileName});

  @override
  Widget build(BuildContext context) {
    final titlePrefix = profileName != null ? "$profileName's " : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('${titlePrefix}Reports'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.summarize_outlined,
                  size: 100,
                  color: Colors.teal[200],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Health Reports',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Generate comprehensive health reports from your tracked data '
                'to share with your healthcare provider.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Coming Soon'),
                        content: const Text(
                          'PDF report generation will be available in a future update.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_chart),
                  label: const Text('Generate New Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
