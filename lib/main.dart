import 'package:flutter/material.dart';
import 'about_page.dart';
import 'setting_page.dart';

void main() {
runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
const TodoApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Todo App',
debugShowCheckedModeBanner: false,
themeMode: ThemeMode.system,
theme: ThemeData(
brightness: Brightness.light,
primarySwatch: Colors.teal,
fontFamily: 'Poppins',
textTheme: const TextTheme(
titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
),
),
darkTheme: ThemeData.dark().copyWith(
textTheme: const TextTheme(
titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
),
),
initialRoute: '/',
routes: {
'/': (context) => const HomePage(),
'/about': (context) => const AboutPage(),
'/settings': (context) => const SettingsPage(),
},
);
}
}

class HomePage extends StatelessWidget {
const HomePage({super.key});

@override
Widget build(BuildContext context) {
final textStyle = Theme.of(context).textTheme;
return Scaffold(
appBar: AppBar(title: const Text('Beranda')),
drawer: Drawer(
child: ListView(
padding: EdgeInsets.zero,
children: [
const DrawerHeader(
decoration: BoxDecoration(color: Colors.teal),
child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
),
ListTile(
title: const Text('Tentang'),
onTap: () => Navigator.pushNamed(context, '/about'),
),
ListTile(
title: const Text('Pengaturan'),
onTap: () => Navigator.pushNamed(context, '/settings'),
),
],
),
),
body: Center(
child: Text('Selamat datang di Aplikasi Todo!', style: textStyle.titleLarge),
),
);
}
}

