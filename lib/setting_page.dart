import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
const SettingsPage({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Pengaturan')),
body: Center(
child: Text(
'Fitur pengaturan belum tersedia.',
style: Theme.of(context).textTheme.bodyMedium,
),
),
);
}
}

