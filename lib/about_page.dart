import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
const AboutPage({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Tentang')),
body: const Center(
child: Text(
'Aplikasi Todo List sederhana dengan Flutter.\nMendukung tema gelap dan terang serta penyimpanan lokal.',
textAlign: TextAlign.center,
),
),
);
}
}