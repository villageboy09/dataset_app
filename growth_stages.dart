import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<Map<String, String>> getGrowthStages(String cropName, DateTime sowingDate) {
  final List<Map<String, String>> growthStages = [];
  switch (cropName) {
    case 'Wheat':
      growthStages.add({
        'name': 'Germination',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 7))),
        'image': 'assets/images/seedling.png',
      });
      growthStages.add({
        'name': 'Tillering',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 21))),
        'image': 'assets/images/flower.png',
      });
      growthStages.add({
        'name': 'Stem Elongation',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 35))),
        'image': 'assets/images/panicle.png',
      });
      break;
    case 'Corn':
      growthStages.add({
        'name': 'Emergence',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 10))),
        'image': 'assets/images/seedling.png',
      });
      growthStages.add({
        'name': 'V6 Stage',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 30))),
        'image': 'assets/images/flower.png',
      });
      growthStages.add({
        'name': 'VT Stage',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 60))),
        'image': 'assets/images/panicle.png',
      });
      break;
    case 'Rice':
      growthStages.add({
        'name': 'Seeding',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 7))),
        'image': 'assets/images/seedling.png',
      });
      growthStages.add({
        'name': 'Tillering',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 21))),
        'image': 'assets/images/flower.png',
      });
      growthStages.add({
        'name': 'Panicle Initiation',
        'date': DateFormat('dd.MM.yyyy').format(sowingDate.add(const Duration(days: 45))),
        'image': 'assets/images/panicle.png',
      });
      break;
  }
  return growthStages;
}

class GrowthStageChip extends StatelessWidget {
  final String imagePath;
  final String stageName;
  final String stageDate;

  const GrowthStageChip({
    super.key,
    required this.imagePath,
    required this.stageName,
    required this.stageDate,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Image.asset(
        imagePath,
        width: 24,
        height: 24,
      ),
      label: Text(
        '$stageName: $stageDate',
        style: const TextStyle(fontFamily: 'GoogleFonts.poppins'),
      ),
    );
  }
}
