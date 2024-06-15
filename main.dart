// ignore_for_file: library_private_types_in_public_api

import 'package:cropsync_app/camera.dart';
import 'package:cropsync_app/growth_stages.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          "assets/images/icon.png",
          fit: BoxFit.fill,
        ),
        title: Text(
          'Select Crop and Status',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 50,),// Add some space here
            DropdownsAndButton(),
          ],
        ),
      ),
    );
  }
}


class DropdownsAndButton extends StatefulWidget {
  const DropdownsAndButton({super.key});

  @override
  _DropdownsAndButtonState createState() => _DropdownsAndButtonState();
}

class _DropdownsAndButtonState extends State<DropdownsAndButton> {
  String? _cropName;
  String? _healthStatus;
  DateTime? _selectedDate;

  final List<String> crops = [
    'Wheat',
    'Corn',
    'Rice',
    'Barley',
    'Pearl millet (Bajra)',
    'Finger millet (Ragi)',
    'Foxtail millet (Kangni)',
    'Chickpea (Chana)',
    'Lentils (Masoor)',
    'Pigeon pea (Arhar/Tur)',
    'Tomato',
    'Potato',
    'Onion',
    'Brinjal (Eggplant)',
    'Okra (Ladyfinger)',
    'Spinach (Palak)',
    'Mango',
    'Banana',
    'Guava',
    'Pomegranate',
    'Turmeric',
    'Chili',
    'Coriander',
    'Cumin'
  ];

  final List<String> healthStatuses = ['Healthy', 'Diseased'];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _buildDropdown(
            value: _cropName,
            items: crops,
            hint: 'Select Crop',
            onChanged: (String? newValue) {
              setState(() {
                _cropName = newValue;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildDropdown(
            value: _healthStatus,
            items: healthStatuses,
            hint: 'Select Health Status',
            onChanged: (String? newValue) {
              setState(() {
                _healthStatus = newValue;
              });
            },
          ),
          const SizedBox(height: 20),
          _buildDatePicker(context),
          const SizedBox(height: 20),
          if (_cropName != null && _healthStatus != null && _selectedDate != null)
            Expanded(
              child: SingleChildScrollView(
                child: _buildGrowthStageReminders(),
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_cropName != null && _healthStatus != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraPage(
                        cropName: _cropName!,
                        healthStatus: _healthStatus!,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.amberAccent,
                    content: Text(
                      'Please select crop, health status and date of sowing',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Take Picture',
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          iconSize: 24,
          isExpanded: true,
          style: GoogleFonts.poppins(color: Colors.black),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: GoogleFonts.poppins()),
            );
          }).toList(),
        ),
      ),
    );
  }

Widget _buildDatePicker(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null && pickedDate != _selectedDate) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
      child: Text(
        _selectedDate == null
            ? 'Select Date of Sowing (Optional)'
            : 'Selected Date: ${DateFormat('dd.MM.yyyy').format(_selectedDate!)}',
        style: GoogleFonts.poppins(),
      ),
    ),
  );
}

  Widget _buildGrowthStageReminders() {
  final growthStages = getGrowthStages(_cropName!, _selectedDate!);

  return Wrap(
    spacing: 8.0,
    runSpacing: 4.0,
    children: growthStages.map((stage) {
      return GrowthStageChip(
        imagePath: stage['image']!,
        stageName: stage['name']!,
        stageDate: stage['date']!,
      );
    }).toList(),
  );
}
}