import 'package:hive/hive.dart';
part 'journel_entries.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String? notes;

  @HiveField(3)
  List<String> tags;

  @HiveField(4)
  String? description;

  JournalEntry({
    required this.title,
    required this.date,
    this.notes, required this.tags, required String description,
  });
}
