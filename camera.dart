// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


class CameraPage extends StatefulWidget {
  final String cropName;
  final String healthStatus;

  const CameraPage({required this.cropName, required this.healthStatus, super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  double _brightness = 0.5;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;

      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to initialize camera',
          style: GoogleFonts.poppins(),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }


Future<void> _takePicture() async {
  try {
    // Capture image using camera controller
    if (_controller == null || !_controller!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Camera not initialized',
          style: GoogleFonts.poppins(),
        ),
      ));
      return;
    }

    final image = await _controller!.takePicture();

    // Save the image to a custom directory
    Directory? selectedDirectory = await getExternalStorageDirectory();
    if (selectedDirectory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to get directory',
          style: GoogleFonts.poppins(),
        ),
      ));
      return;
    }

    final String? newDirectory = await FilePicker.platform.getDirectoryPath();
    if (newDirectory != null) {
      selectedDirectory = Directory(newDirectory);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'No directory selected',
          style: GoogleFonts.poppins(),
        ),
      ));
      return;
    }

    final String imagePath = path.join(
      selectedDirectory.path,
      '${widget.cropName}_${widget.healthStatus}_${DateTime.now().millisecondsSinceEpoch}.png',
    );

    await File(image.path).copy(imagePath);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.amberAccent,
      duration: Duration.zero,
      content: Text(
        'Picture saved: $imagePath',
        style: GoogleFonts.poppins(color:Colors.black),
      ),
    ));

    // Save the image to the gallery
    await GallerySaver.saveImage(imagePath);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.amberAccent,
      duration: const Duration(seconds: 1),
      content: Text(
        'Picture saved to gallery',
        style: GoogleFonts.poppins(color:Colors.black),
      ),
    ));
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar
    (
      backgroundColor: Colors.amberAccent,
      content: Text(
        'Error taking picture: $e',
        style: GoogleFonts.poppins(color:Colors.black),
      ),
    ));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Take a picture',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: 1, // Maintain a square aspect ratio
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CameraPreview(_controller!),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Slider(
                    value: _brightness,
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      setState(() {
                        _brightness = value;
                        _controller?.setExposureOffset(value * 2 - 1); // Adjust brightness
                      });
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _takePicture,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Capture Image',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
