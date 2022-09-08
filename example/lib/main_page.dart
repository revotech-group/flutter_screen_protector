import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Screen Protector'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text('Screen Protector'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/prevent-screenshot');

              },
              child: const Text('Secure Screen'),
            ),
          ],
        ),
      ),
    );
  }


}
