import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'scan_page.dart';

class ResultsPage extends StatefulWidget {
  final String imageId;

  const ResultsPage({super.key, required this.imageId});

  @override
  // ignore: library_private_types_in_public_api
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  void _showNoObjectsDetectedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Objects Detected'),
          content: const Text(
              'The uploaded image did not contain any recognizable objects.'),
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
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadImage() async {
    try {
      final directory = await getExternalStorageDirectory();
      const fileName = 'image.png';
      final filePath = '${directory!.path}/$fileName';
      final response = await http.get(Uri.parse(_imageUrl!));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('Image downloaded to $filePath');

      // Show an AlertDialog to indicate successful download
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success!'),
            content: const Text('Image downloaded to Downloads folder'),
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
    } catch (e) {
      print('Exception occurred while downloading image: $e');
      // Handle error, e.g., show an error message
    }
  }

  Future<void> _fetchImage() async {
    try {
      final response = await http.get(
          Uri.parse('http://172.20.10.3:5000/get_image/${widget.imageId}'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('possible_shape')) {
          final imageUrl = responseData["possible_shape"];
          setState(() {
            _imageUrl = imageUrl;
          });
        } else {
          print('Image URL not found in response');
        }
      } else {
        print('Failed to fetch image data');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results Page'),
      ),
      body: Center(
        child: _imageUrl != null
            ? Column(
                children: [
                  Image.network(
                    _imageUrl!, // Display image from URL
                    fit: BoxFit.cover, // Adjust image to fit the screen
                    height: 450,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: const Size(297, 43),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      backgroundColor: const Color(0xFFFDB813),
                    ),
                    onPressed: _downloadImage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.download_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Dowload the image',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScanPage()),
                      );
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
                          'Go back and build something else',
                          style: TextStyle(
                            color: const Color(0xFFFDB813),
                            fontFamily: GoogleFonts.dmSans().fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
