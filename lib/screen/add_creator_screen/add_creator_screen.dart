import 'package:afui/afui.dart';
import 'package:creator_tracker/widgets/app_datefield.dart';
import 'package:creator_tracker/widgets/app_dropdown.dart';
import 'package:creator_tracker/widgets/app_textfield.dart';
import 'package:flutter/material.dart';

class AddCreatorScreen extends StatefulWidget {
  final int selectedStep;
  const AddCreatorScreen({super.key, this.selectedStep = 1});

  @override
  State<AddCreatorScreen> createState() => _AddCreatorScreenState();
}

class _AddCreatorScreenState extends State<AddCreatorScreen> {
  int selectedStep = 1;

  @override
  void initState() {
    super.initState();
    selectedStep = widget.selectedStep;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: context.spacing.s5,
            vertical: context.spacing.s2,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(7, (index) {
                    final step = index + 1;
                    return ChoiceChip(
                      label: Text('$step'),
                      selected: selectedStep == step,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // rounded
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedStep = step;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: context.spacing.s5,),
                currentProcessTitle(selectedStep),
                SizedBox(height: context.spacing.s6,),
                currentForm(selectedStep),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget currentProcessTitle(int selectedStep) {
  switch (selectedStep) {
    case 1:
      return Center( child: Text("Creator"));
    case 2:
      return Center(child: Text("Outreach"));
    case 3:
      return Center(child: Text("Deals"));
    case 4:
      return Center(child: Text("Product Tracking"));
    case 5: 
      return Center(child: Text("Content"));
    case 6: 
      return Center(child: Text("Payments"));
    case 7: 
      return Center(child: Text("Notes"));
    default:
      return Center(child: Text('---'));
  }
}

Widget currentForm(int selectedStep){
  switch(selectedStep){
    case 1:
      return CreatorForm();
    case 2:
      return OutReach();
    case 3:
      return Deals();
    case 4:
      return ProductTracking();
    case 5: 
      return Content();
    case 6: 
      return Payment();
    case 7: 
      return Notes();
    default:
      return Column(
        children: [

        ],
      );
  }
}

class CreatorForm extends StatelessWidget {
  const CreatorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        AppTextField(hintText: 'Name'),
        AppTextField(hintText: 'Followers'),
        AppTextField(hintText: 'phone number'),
        AppTextField(hintText: 'email'),
        AppTextField(hintText: 'address'),
        AppTextField(hintText: 'location'),
        AppDropdown(hintText: 'Platform', items: [
          DropdownMenuItem(value: 'instagram', child: Text('Instagram'),),
          DropdownMenuItem(value: 'facebook', child: Text('Facebook')),
          DropdownMenuItem(value: 'youtube', child: Text('Youtube')),
        ], onChanged: (value){}),
        AppDropdown(hintText: 'Niche', items: [
          DropdownMenuItem(value: 'instagram', child: Text('Instagram'),),
          DropdownMenuItem(value: 'facebook', child: Text('Facebook')),
          DropdownMenuItem(value: 'youtube', child: Text('Youtube')),
        ], onChanged: (value){}),
        AppDropdown(hintText: 'Engagement Rate', items: [
          DropdownMenuItem(value: 'low', child: Text('Low'),),
          DropdownMenuItem(value: 'mid', child: Text('Mid')),
          DropdownMenuItem(value: 'high', child: Text('High')),
        ], onChanged: (value){})
      ]
    );
  }
}

class OutReach extends StatelessWidget {
  const OutReach({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDropdown(hintText: 'Status', items: [
          DropdownMenuItem(value: 'message sent',child: Text('message sent')),
          DropdownMenuItem(value: 'Replied',child: Text('Replied')),
        ], onChanged: (value){}),
        AppDateField(hintText: 'First Message Date', onChanged: (value){}),
        AppDateField(hintText: 'Last Message Date', onChanged: (value){}),
        AppDateField(hintText: 'Next Folloup Date', onChanged: (value){}),
        AppDropdown(hintText: 'Communication Channel', items: [
          DropdownMenuItem(value: 'instagram',child: Text('Instagram')),
          DropdownMenuItem(value: 'whatsapp',child: Text('Whatsapp')),
        ], onChanged: (value){}),

      ],
    );
  }
}

class Deals extends StatelessWidget {
  const Deals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(hintText: 'Asked Price'),
        AppTextField(hintText: 'Final Price'),
        AppTextField(hintText: 'Deliverables'),
        AppTextField(hintText: 'Product Names (end with , )'),
        AppDropdown(hintText: 'Collaboration Type', items: [
          DropdownMenuItem(value: 'barter', child: Text('Barter')),
          DropdownMenuItem(value: 'paid', child: Text('Paid + Product'))
        ], onChanged: (value){})
      ],
    );
  }
}

class ProductTracking extends StatelessWidget {
  const ProductTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppTextField(hintText: 'Product Name'),
      AppTextField(hintText: 'Status'),
      AppTextField(hintText: 'Tracking Number'),
      AppDropdown(hintText: 'Courier', items: [], onChanged: (value){}),
      AppDateField(hintText: 'Dispatch Date', onChanged: (value){}),
      AppDateField(hintText: 'Delivery Date', onChanged: (value){}),
    ],);
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDropdown(hintText: 'Content Received', items: [
          DropdownMenuItem(value: true, child: Text('Yes'),),
          DropdownMenuItem(value: false, child: Text('No')),
        ], onChanged: (value){}),
        
        AppDropdown(hintText: 'Content Approved', items: [
          DropdownMenuItem(value: true, child: Text('Yes'),),
          DropdownMenuItem(value: false, child: Text('No')),
        ], onChanged: (value){}),

        AppDropdown(hintText: 'Ad Permission', items: [
          DropdownMenuItem(value: true, child: Text('Yes'),),
          DropdownMenuItem(value: false, child: Text('No')),
        ], onChanged: (value){}),

        AppDateField(hintText: 'Posting Date', onChanged: (value){})
      ],
    );
  }
}

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(hintText: 'Amount Paid'),
        AppTextField(hintText: 'Invoice Number'),
        AppDropdown(hintText: 'Status', items: [], onChanged: (value){}),
        AppDropdown(hintText: 'Payment Method', items: [], onChanged: (value){}),
        AppDateField(hintText: 'Payment Date', onChanged: (value){}),
      ],
    );
  }
}


class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(hintText: 'Notes')
      ],
    );
  }
}