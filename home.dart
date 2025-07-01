import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    Uint8List? imageBytes; // this thing right here is a list of bytes (basically collections, we will store img as bytes instead of files)
    img.Image? originalImage; // this will be the original image, it could only be Image? originalImage too, but we r importing it 'as immg'


  Future<void> pickImage() async {
    final picker = ImagePicker(); // create an instance
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery); // get the image in XFile format 
    if (picked != null) {
      final bytes = await picked.readAsBytes(); // convert to bytes
      final decoded = img.decodeImage(bytes); // get decoded img
      setState(() { // re render screen to show the image
        imageBytes = bytes;
        originalImage = decoded;
      });
    }
  }

    void applyGrayscale() {
      if (originalImage != null) {
        final gray = img.grayscale(originalImage!);
        setState(() {
          originalImage = gray; // now set the img to gray image
          imageBytes = Uint8List.fromList(img.encodeJpg(gray));
        });
      }
    }
    void rotate90() {
      if (originalImage != null) {
        final rotated = img.copyRotate(originalImage!, 90);
        setState(() {
          originalImage = rotated;
          imageBytes = Uint8List.fromList(img.encodeJpg(rotated));
        });
      }
    }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
             Center(
          child: imageBytes == null
              ? const Text("No image selected")
              : Image.memory(imageBytes!),
        ),
            InkWell(
               onTap:  () async {
                  await pickImage();
               },
              child: Container(
  color: Colors.black, 
  child: Text("Pick Image", style: TextStyle(color: Colors.white)),
),
            ),
            InkWell(
               onTap:  () async {
                  applyGrayscale();
               },
              child: Container(
  color: Colors.black, 
  child: Text("Gray Scale", style: TextStyle(color: Colors.white)),
),
            ),
            InkWell(
               onTap:  () async {
                  rotate90();
               },
              child: Container(
  color: Colors.black, 
  child: Text("Rotate 90 degrees", style: TextStyle(color: Colors.white)),
),
            ),
          ],
        ),
      ),
    );
  }
}
