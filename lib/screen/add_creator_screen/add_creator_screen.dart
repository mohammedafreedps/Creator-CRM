import 'package:afui/afui.dart';
import 'package:flutter/material.dart';

class AddCreatorScreen extends StatefulWidget {
  const AddCreatorScreen({super.key});

  @override
  State<AddCreatorScreen> createState() => _AddCreatorScreenState();
}

class _AddCreatorScreenState extends State<AddCreatorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: context.spacing.s5,
            vertical: context.spacing.s2,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
                    Navigator.pop(context);
                  },)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
