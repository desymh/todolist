import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
const AboutPage({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Tentang')),
body: Center(
child: Text(
'Aplikasi ini dibuat dengan Flutter.\nMendukung tema dan custom font.',
style: Theme.of(context).textTheme.bodyMedium,
textAlign: TextAlign.center,
),
),
);
}
}