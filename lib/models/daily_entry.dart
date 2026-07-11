import 'package:hive/hive.dart';

/// Ein einzelner "1 % besser"-Eintrag für einen Kalendertag.
///
/// Bewusst simpel gehalten: nur Datum + Text. Keine Kategorien,
/// keine Tags, keine Projekte – das widerspräche dem Kernprinzip
/// der App (radikale Einfachheit).
class DailyEntry {
  final DateTime date;
  final String text;

  const DailyEntry({
    required this.date,
    required this.text,
  });

  DailyEntry copyWith({DateTime? date, String? text}) {
    return DailyEntry(
      date: date ?? this.date,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'text': text,
      };

  factory DailyEntry.fromJson(Map<String, dynamic> json) => DailyEntry(
        date: DateTime.parse(json['date'] as String),
        text: json['text'] as String,
      );
}

/// Manuell geschriebener Hive-TypeAdapter.
///
/// Bewusst manuell statt per build_runner generiert: dadurch ist das
/// Projekt sofort lauffähig, ohne zwingend Codegen ausführen zu müssen.
class DailyEntryAdapter extends TypeAdapter<DailyEntry> {
  @override
  final int typeId = 1;

  @override
  DailyEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyEntry(
      date: fields[0] as DateTime,
      text: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyEntryAdapter && runtimeType == other.runtimeType;
}
