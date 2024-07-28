import 'dart:convert';
import 'dart:typed_data'; // Import needed for Uint8List
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'results_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Uint8List? _imageData; // Change to Uint8List to hold image bytes
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageData == null
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/untitled8.png',
                        height: 450,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : Image.memory(
                    _imageData!, // Display image from memory
                    height: 450,
                    width: double.infinity,
                  ),
            _imageData == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(297, 43),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          backgroundColor: const Color(0xFFFDB813),
                          elevation: 0,
                        ),
                        onPressed: () => _selectImage(ImageSource.camera),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Take a Picture',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(297, 43),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              side: BorderSide(
                                color: Color(0xFFFDB813),
                                width: 1,
                              )),
                          elevation: 0,
                        ),
                        onPressed: () => _selectImage(ImageSource.gallery),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.photo_library_outlined,
                              color: Color(0xFFFDB813),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Upload from Gallery',
                              style: TextStyle(
                                color: const Color(0xFFFDB813),
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(297, 43),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          backgroundColor: const Color(0xFFFDB813),
                        ),
                        onPressed: _isProcessing ? null : _processImage,
                        child: _isProcessing
                            ? const CircularProgressIndicator(
                                color: Color(0xFFFDB813),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.shape_line_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    'See what you can build',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 7),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(297, 43),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          side: const BorderSide(
                            color: Color(0xFFFDB813),
                            width: 1,
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _imageData = null; // Clear selected image
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.arrow_back_outlined,
                              color: Color(0xFFFDB813),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'Choose another picture',
                              style: TextStyle(
                                color: const Color(0xFFFDB813),
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes(); // Read image bytes
      setState(() {
        _imageData = Uint8List.fromList(imageData); // Convert to Uint8List
      });
    }
  }

  Future<void> _processImage() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final url = Uri.parse('http://172.20.10.3:5000/process_image');
      final request = http.MultipartRequest('POST', url);
      final file = http.MultipartFile.fromBytes(
        'image',
        _imageData!,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(file);
      final response = await request.send();
 
      if (response.statusCode == 200) {
        // Image processed successfully
        final processedImageData = await utf8.decodeStream(response.stream);
        navigateToResultPage(processedImageData);
      } else if (response.statusCode == 404) {
        // Show dialog for 404 response
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Sorry!',
                style: TextStyle(
                  color: const Color(0xFFFDB813),
                  fontFamily: GoogleFonts.dmSans().fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: const Text(
                  "There's no shape you can build with those bricks, please try other ones."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: const Color(0xFFFDB813),
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            );
          },
        );
      } else if (response.statusCode == 500) {
        AlertDialog(
          title: Text(
            'Sorry!',
            style: TextStyle(
              color: const Color(0xFFFDB813),
              fontFamily: GoogleFonts.dmSans().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text("please take a valid picture with lego bricks"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: const Color(0xFFFDB813),
                    fontFamily: GoogleFonts.dmSans().fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
          ],
        );
        // Handle other error cases
      }
    } catch (e) {
      // Handle exception
      print('Exception occurred: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void navigateToResultPage(String imageId) {
    // Trim any whitespace from the imageId
    String trimmedImageId = imageId.trim();

    // Navigate to the result page and pass the trimmed image ID
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ResultsPage(imageId: trimmedImageId)));
  }
}
