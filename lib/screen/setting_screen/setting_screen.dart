import 'package:afui/afui.dart';
import 'package:creator_tracker/service/settings_service.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool enableDeleting = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() {
    enableDeleting = SettingsService.enableDelete;
  }

  Future<void> updateDeleting(bool value) async {
    await SettingsService.setEnableDelete(value);

    setState(() {
      enableDeleting = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.af.spacing.s3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: context.af.spacing.s3),
                      Text(
                        'Settings',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SettingTile(
                        value: enableDeleting,
                        labal: 'Enable Deleting',
                        onChange: (value) {
                          updateDeleting(value ?? false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Text('by Afreed . v1.0.0',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.af.colors.border),),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String labal;
  final ValueChanged<bool?> onChange;
  final bool value;

  const SettingTile({
    super.key,
    required this.onChange,
    required this.labal,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.af.spacing.s3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(labal),
          Switch(value: value, onChanged: onChange),
        ],
      ),
    );
  }
}
