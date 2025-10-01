// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicationModel _$MedicationModelFromJson(Map<String, dynamic> json) =>
    MedicationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      times: (json['times'] as List<dynamic>).map((e) => e as String).toList(),
      isTaken: json['isTaken'] as bool,
      takenAt: json['takenAt'] == null
          ? null
          : DateTime.parse(json['takenAt'] as String),
      notes: json['notes'] as String?,
      color: json['color'] as String,
      shape: json['shape'] as String,
      isImportant: json['isImportant'] as bool? ?? false,
    );

Map<String, dynamic> _$MedicationModelToJson(MedicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'dosage': instance.dosage,
      'frequency': instance.frequency,
      'times': instance.times,
      'isTaken': instance.isTaken,
      'takenAt': instance.takenAt?.toIso8601String(),
      'notes': instance.notes,
      'color': instance.color,
      'shape': instance.shape,
      'isImportant': instance.isImportant,
    };
