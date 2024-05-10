//create a page that shows an image and under it its filename , it gets it from network (url) and make it pretty design)
// the image is a lego brick that is fetched from the drive
// the image is from the url: https://drive.google.com/uc?export=view&id=1(we use image.network)
// the filename is: lego_brick.png
// the filename is shown under the image
// the image is a lego brick

import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 150),
        child: Column(
          children: [
            Container(
                height: 300,
                width: double.infinity,
                child: Image.asset('assets/airplane.png',
                    fit: BoxFit.cover, width: double.infinity)),
            const SizedBox(height: 20),
            const Text('Airplane',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
