import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spk_saw/home_page.dart';
import 'package:spk_saw/provider/saw_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final sawProvider = SawProvider();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => sawProvider,
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pendukung Keputusan SAW',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
