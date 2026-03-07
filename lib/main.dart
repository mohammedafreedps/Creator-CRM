import 'package:creator_tracker/screen/home_screen/home_screen.dart';
import 'package:creator_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (_)=> );
        
      ],
      child: MaterialApp(
        darkTheme: AppTheme.dark(),
        theme: AppTheme.light(),
        themeMode: ThemeMode.system,
        title: 'Creator Tracking',
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
