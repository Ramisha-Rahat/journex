import 'package:hive/hive.dart';
part 'journal_entries.g.dart';


@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? iconName;

  JournalEntry({
    required this.title,
    required this.date,
    this.description,
    this.iconName,
  });

  JournalEntry copyWith({
    String? title,
    DateTime? date,
    String? description,
    String? iconName,
  }) {
    return JournalEntry(
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
    );
  }
}
