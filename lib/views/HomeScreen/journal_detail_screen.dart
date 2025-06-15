import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/journal_entries.dart';
import '../../utils/theme/jornex_colors.dart';
import 'addEntry.dart';
class JournalDetailScreen extends StatelessWidget {
  final JournalEntry entry;

  const JournalDetailScreen({Key? key, required this.entry}) : super(key: key);

  IconData getIcon(String? name) {
    switch (name?.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'home':
        return Icons.home;
      case 'favorite':
      case 'love':
        return Icons.favorite;
      case 'coffee':
      case 'food':
        return Icons.emoji_food_beverage;
      case 'travel':
        return Icons.flight;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.note;
    }
  }

  Color getIconColor(String? name) {
    switch (name?.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'home':
        return Colors.green;
      case 'food':
      case 'shopping':
        return Colors.lightGreenAccent;
      case 'favorite':
      case 'love':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = getIconColor(entry.iconName);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEntryScreen(entryToEdit: entry),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding:  EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getIcon(entry.iconName),
                    size: 32,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMMEEEEd().format(entry.date),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),


            if (entry.description != null && entry.description!.isNotEmpty) ...[
               Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode? AppColors.backgroundDark:AppColors.inputFillLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  entry.description!,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
    ]
        ]),
      ),
    );
  }
}
