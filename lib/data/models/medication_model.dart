import 'package:json_annotation/json_annotation.dart';

part 'medication_model.g.dart';

@JsonSerializable()
class MedicationModel {
  final int id;
  final String name;
  final String description;
  final String dosage;
  final String frequency;
  final List<String> times;
  final bool isTaken;
  final DateTime? takenAt;
  final String? notes;
  final String color;
  final String shape;
  final bool isImportant;

  const MedicationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.isTaken,
    this.takenAt,
    this.notes,
    required this.color,
    required this.shape,
    this.isImportant = false,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) =>
      _$MedicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationModelToJson(this);

  MedicationModel copyWith({
    int? id,
    String? name,
    String? description,
    String? dosage,
    String? frequency,
    List<String>? times,
    bool? isTaken,
    DateTime? takenAt,
    String? notes,
    String? color,
    String? shape,
    bool? isImportant,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      isTaken: isTaken ?? this.isTaken,
      takenAt: takenAt ?? this.takenAt,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      shape: shape ?? this.shape,
      isImportant: isImportant ?? this.isImportant,
    );
  }

  @override
  String toString() {
    return 'MedicationModel(id: $id, name: $name, isTaken: $isTaken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}