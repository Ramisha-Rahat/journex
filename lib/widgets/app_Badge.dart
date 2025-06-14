import 'package:flutter/material.dart';

class TagBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const TagBadge({
    Key? key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Optional: badge builder for predefined styles
TagBadge buildTag(String tag) {
  switch (tag.toLowerCase()) {
    case 'work':
      return const TagBadge(
        label: 'Work',
        backgroundColor: Color(0xFFD1FAE5),
        textColor: Color(0xFF065F46),
      );
    case 'family':
      return const TagBadge(
        label: 'Family',
        backgroundColor: Color(0xFFFEE2E2),
        textColor: Color(0xFFB91C1C),
      );
    case 'gratitude':
      return const TagBadge(
        label: 'Gratitude',
        backgroundColor: Color(0xFFDBEAFE),
        textColor: Color(0xFF1E3A8A),
      );
    default:
      return const TagBadge(
        label: 'Other',
        backgroundColor: Color(0xFFE5E7EB),
        textColor: Color(0xFF374151),
      );
  }
}
