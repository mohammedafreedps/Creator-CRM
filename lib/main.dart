import 'package:creator_tracker/screen/home_screen/cubit/cubit/show_all_creator_cubit.dart';
import 'package:creator_tracker/screen/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afui/afui.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=> ShowAllCreatorCubit()),
        
      ],
      child: MaterialApp(
        darkTheme: AfTheme.dark(),
        theme: AfTheme.light(),
        themeMode: ThemeMode.system,
        title: 'Creator Tracking',
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
