import 'package:afui/afui.dart';
import 'package:creator_tracker/models/creator_draft_model.dart';
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

  final CreatorDraft draft = CreatorDraft();

  late PageController pageController;

  int selectedStep = 1;

  @override
  void initState() {
    super.initState();
    selectedStep = widget.selectedStep;
    pageController = PageController(initialPage: selectedStep - 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void goToStep(int step) {
    setState(() {
      selectedStep = step;
    });

    pageController.animateToPage(
      step - 1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing.s2,
            vertical: context.spacing.s2,
          ),
          child: Column(
            children: [

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onSelected: (_) {
                      goToStep(step);
                    },
                  );
                }),
              ),

              SizedBox(height: context.spacing.s5),

              Text(stepTitle(selectedStep)),

              SizedBox(height: context.spacing.s6),

              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      selectedStep = index + 1;
                    });
                  },
                  children: [
                
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: context.spacing.s4),
                      child: CreatorForm(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: context.spacing.s4),
                      child: OutReach(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: context.spacing.s4),
                      child: Deals(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: context.spacing.s4),
                      child: ProductTracking(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: context.spacing.s4),
                      child: Content(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: context.spacing.s4),
                      child: Payment(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: context.spacing.s4),
                      child: Notes(draft: draft),
                    ),
                
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

String stepTitle(int step) {

  switch (step) {
    case 1:
      return "Creator";
    case 2:
      return "Outreach";
    case 3:
      return "Deals";
    case 4:
      return "Product Tracking";
    case 5:
      return "Content";
    case 6:
      return "Payments";
    case 7:
      return "Notes";
    default:
      return "";
  }
}

class CreatorForm extends StatelessWidget {

  final CreatorDraft draft;

  const CreatorForm({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          AppTextField(
            hintText: 'Name',
            onChanged: (v) => draft.name = v,
          ),

          AppTextField(
            hintText: 'Followers',
            onChanged: (v) => draft.followers = int.tryParse(v),
          ),

          AppTextField(
            hintText: 'phone number',
            onChanged: (v) => draft.phone = v,
          ),

          AppTextField(
            hintText: 'email',
            onChanged: (v) => draft.email = v,
          ),

          AppTextField(
            hintText: 'address',
            onChanged: (v) => draft.address = v,
          ),

          AppTextField(
            hintText: 'location',
            onChanged: (v) => draft.location = v,
          ),

          AppDropdown(
            hintText: 'Platform',
            items: const [
              DropdownMenuItem(value: 'instagram', child: Text('Instagram')),
              DropdownMenuItem(value: 'facebook', child: Text('Facebook')),
              DropdownMenuItem(value: 'youtube', child: Text('Youtube')),
            ],
            onChanged: (value) {
              draft.platform = value;
            },
          ),

          AppDropdown(
            hintText: 'Niche',
            items: const [
              DropdownMenuItem(value: 'food', child: Text('Food')),
              DropdownMenuItem(value: 'tech', child: Text('Tech')),
              DropdownMenuItem(value: 'lifestyle', child: Text('Lifestyle')),
            ],
            onChanged: (value) {
              draft.niche = value;
            },
          ),

          AppDropdown(
            hintText: 'Engagement Rate',
            items: const [
              DropdownMenuItem(value: 'low', child: Text('Low')),
              DropdownMenuItem(value: 'mid', child: Text('Mid')),
              DropdownMenuItem(value: 'high', child: Text('High')),
            ],
            onChanged: (value) {
              draft.engagementRate = value;
            },
          ),

        ],
      ),
    );
  }
}

class OutReach extends StatelessWidget {

  final CreatorDraft draft;

  const OutReach({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          AppDropdown(
            hintText: 'Status',
            items: const [
              DropdownMenuItem(value: 'message sent', child: Text('Message Sent')),
              DropdownMenuItem(value: 'replied', child: Text('Replied')),
            ],
            onChanged: (value) {
              draft.outreachStatus = value;
            },
          ),

          AppDateField(
            hintText: 'First Message Date',
            onChanged: (v) => draft.firstMessageDate = v,
          ),

          AppDateField(
            hintText: 'Last Message Date',
            onChanged: (v) => draft.lastFollowupDate = v,
          ),

          AppDateField(
            hintText: 'Next Followup Date',
            onChanged: (v) => draft.nextFollowupDate = v,
          ),

          AppDropdown(
            hintText: 'Communication Channel',
            items: const [
              DropdownMenuItem(value: 'instagram', child: Text('Instagram')),
              DropdownMenuItem(value: 'whatsapp', child: Text('Whatsapp')),
            ],
            onChanged: (value) {
              draft.communicationChannel = value;
            },
          ),

        ],
      ),
    );
  }
}

class Deals extends StatelessWidget {

  final CreatorDraft draft;

  const Deals({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          AppTextField(
            hintText: 'Asked Price',
            onChanged: (v) => draft.askedPrice = double.tryParse(v),
          ),

          AppTextField(
            hintText: 'Final Price',
            onChanged: (v) => draft.finalPrice = double.tryParse(v),
          ),

          AppTextField(
            hintText: 'Deliverables',
            onChanged: (v) => draft.deliverables = v,
          ),

          AppTextField(
            hintText: 'Product Names (comma separated)',
            onChanged: (v) => draft.productName = v,
          ),

          AppDropdown(
            hintText: 'Collaboration Type',
            items: const [
              DropdownMenuItem(value: 'barter', child: Text('Barter')),
              DropdownMenuItem(value: 'paid', child: Text('Paid + Product')),
            ],
            onChanged: (value) {
              draft.collaborationType = value;
            },
          ),

        ],
      ),
    );
  }
}

class ProductTracking extends StatelessWidget {

  final CreatorDraft draft;

  const ProductTracking({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          AppTextField(
            hintText: 'Product Name',
            onChanged: (v) => draft.productName = v,
          ),

          AppTextField(
            hintText: 'Status',
            onChanged: (v) => draft.productStatus = v,
          ),

          AppTextField(
            hintText: 'Tracking Number',
            onChanged: (v) => draft.trackingNumber = v,
          ),

          AppDropdown(
            hintText: 'Courier',
            items: const [
              DropdownMenuItem(value: 'dtdc', child: Text('DTDC')),
              DropdownMenuItem(value: 'delhivery', child: Text('Delhivery')),
            ],
            onChanged: (value) {
              draft.courier = value;
            },
          ),

          AppDateField(
            hintText: 'Dispatch Date',
            onChanged: (v) => draft.dispatchDate = v,
          ),

          AppDateField(
            hintText: 'Delivery Date',
            onChanged: (v) => draft.deliveryDate = v,
          ),

        ],
      ),
    );
  }
}

class Content extends StatelessWidget {

  final CreatorDraft draft;

  const Content({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          AppDropdown(
            hintText: 'Content Received',
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) {
              draft.contentReceived = value;
            },
          ),

          AppDropdown(
            hintText: 'Content Approved',
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) {
              draft.contentApproved = value;
            },
          ),

          AppDropdown(
            hintText: 'Ad Permission',
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) {
              draft.adPermission = value;
            },
          ),

          AppDateField(
            hintText: 'Posting Date',
            onChanged: (v) => draft.postingDate = v,
          ),

        ],
      ),
    );
  }
}

class Payment extends StatelessWidget {

  final CreatorDraft draft;

  const Payment({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          AppTextField(
            hintText: 'Amount Paid',
            onChanged: (v) => draft.amount = double.tryParse(v),
          ),

          AppTextField(
            hintText: 'Invoice Number',
            onChanged: (v) => draft.invoiceNumber = v,
          ),

          AppDropdown(
            hintText: 'Status',
            items: const [
              DropdownMenuItem(value: 'paid', child: Text('Paid')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
            ],
            onChanged: (value) {
              draft.paymentStatus = value;
            },
          ),

          AppDropdown(
            hintText: 'Payment Method',
            items: const [
              DropdownMenuItem(value: 'upi', child: Text('UPI')),
              DropdownMenuItem(value: 'bank', child: Text('Bank Transfer')),
            ],
            onChanged: (value) {
              draft.paymentMethod = value;
            },
          ),

          AppDateField(
            hintText: 'Payment Date',
            onChanged: (v) => draft.paymentDate = v,
          ),

        ],
      ),
    );
  }
}

class Notes extends StatelessWidget {

  final CreatorDraft draft;

  const Notes({super.key, required this.draft});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [

          AppTextField(
            hintText: 'Notes',
            onChanged: (v) => draft.note = v,
          ),

          SizedBox(height: context.spacing.s6),

          ElevatedButton(
            onPressed: () {
              print(draft.toMap());
            },
            child: const Text("Save"),
          ),

        ],
      ),
    );
  }
}