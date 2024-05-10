import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResultsPage extends StatefulWidget {
  final String imageId;

  const ResultsPage({Key? key, required this.imageId}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  Future<void> _fetchImage() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.136.162:5000/get_image/${widget.imageId}'));
      if (response.statusCode == 200) {
        setState(() {
          _imageData = response.bodyBytes;
        });
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
        title: Text('Results Page'),
      ),
      body: Center(
        child: _imageData != null
            ? Image.memory(
                _imageData!, // Display image from memory
                fit: BoxFit.cover, // Adjust image to fit the screen
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
