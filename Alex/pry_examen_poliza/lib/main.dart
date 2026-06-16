import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/policy_view_model.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PolicyViewModel()..fetchPolicies()),
      ],
      child: MaterialApp(
        title: 'Gestión de Pólizas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}