import 'package:flutter/material.dart';
import 'package:journex/utils/theme/jornex_colors.dart';
import '../model/journal_entries.dart';
import 'package:intl/intl.dart';

class JournalCardWidget extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const JournalCardWidget({
    super.key,
    required this.entry,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  IconData getIcon(String? name) {
    switch (name) {
      case 'work':
        return Icons.work;
      case 'home':
        return Icons.home;
      case 'favorite':
        return Icons.favorite;
      case 'alarm':
        return Icons.access_alarm;
      case 'coffee':
        return Icons.emoji_food_beverage;
      default:
        return Icons.label;
    }
  }

  @override
  Widget build(BuildContext context) {

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: AppColors.primaryContainerLight,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode? AppColors.backgroundDark:AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(entry.iconName),
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),

              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:  AppColors.backgroundDark,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('MMM d').format(entry.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEdit?.call();
                            } else if (value == 'delete') {
                              onDelete?.call();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                          icon:  Icon(Icons.more_vert, size: 18,color: isDarkMode? AppColors.backgroundDark:AppColors.primaryDark,),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      entry.description ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
