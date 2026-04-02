import 'package:afui/afui.dart';
import 'package:creator_tracker/models/creator_draft_model.dart';
import 'package:creator_tracker/screen/add_creator_screen/cubit/cubit/add_creator_cubit.dart';
import 'package:creator_tracker/screen/creator_details_screen/cubit/cubit/creator_details_cubit.dart';
import 'package:creator_tracker/screen/home_screen/cubit/show_all_creator/show_all_creator_cubit.dart';
import 'package:creator_tracker/utils/iso_string_to_datetime.dart';
import 'package:creator_tracker/widgets/app_datefield.dart';
import 'package:creator_tracker/widgets/app_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCreatorScreen extends StatefulWidget {
  final int selectedStep;
  final int? creatorId;
  final CreatorFullDetail? creatorFullDetail;
  const AddCreatorScreen({
    super.key,
    this.selectedStep = 1,
    this.creatorId,
    this.creatorFullDetail,
  });

  @override
  State<AddCreatorScreen> createState() => _AddCreatorScreenState();
}

class _AddCreatorScreenState extends State<AddCreatorScreen> {
  CreatorDraft draft = CreatorDraft();

  late PageController pageController;

  int selectedStep = 1;

  CreatorFullDetail? fullDetail;

  @override
  void initState() {
    super.initState();

    selectedStep = widget.selectedStep;
    pageController = PageController(initialPage: selectedStep - 1);
    fullDetail = widget.creatorFullDetail;
    draft.id = widget.creatorId;
    //-------------------------------------------------------------
    draft.name = fullDetail?.creator.name;
    draft.followers = fullDetail?.creator.followers;
    draft.phone = fullDetail?.creator.phone;
    draft.email = fullDetail?.creator.email;
    draft.address = fullDetail?.creator.address;
    draft.location = fullDetail?.creator.location;
    draft.platform = fullDetail?.creator.platform;
    draft.niche = fullDetail?.creator.niche;
    draft.engagementRate = fullDetail?.creator.engagementRate;
    //--------------------------------------------------------------
    draft.outreachStatus = fullDetail?.outreach?.status;
    draft.firstMessageDate = isoStringToDateTime(
      fullDetail?.outreach?.firstMessageDate,
    );
    draft.lastFollowupDate = isoStringToDateTime(
      fullDetail?.outreach?.lastFollowupDate,
    );
    draft.nextFollowupDate = isoStringToDateTime(
      fullDetail?.outreach?.nextFollowupDate,
    );
    draft.communicationChannel = fullDetail?.outreach?.communicationChannel;
    //--------------------------------------------------------------
    draft.collaborationType = fullDetail?.deal?.collaborationType;
    draft.askedPrice = fullDetail?.deal?.askedPrice;
    draft.finalPrice = fullDetail?.deal?.finalPrice;
    draft.deliverables = fullDetail?.deal?.deliverables;
    draft.dealStatus = fullDetail?.deal?.status;

    //--------------------------------------------------------------
    draft.productName = fullDetail?.product?.productName;
    draft.productStatus = fullDetail?.product?.status;
    draft.courier = fullDetail?.product?.courier;
    draft.trackingNumber = fullDetail?.product?.trackingNumber;
    draft.dispatchDate = isoStringToDateTime(fullDetail?.product?.dispatchDate);
    draft.deliveryDate = isoStringToDateTime(fullDetail?.product?.deliveryDate);

    //--------------------------------------------------------------
    draft.contentReceived = fullDetail?.content?.contentReceived;
    draft.contentApproved = fullDetail?.content?.contentApproved;
    draft.creatorBraftSent = fullDetail?.content?.creatorBriefSent;
    draft.postedDate = isoStringToDateTime(fullDetail?.content?.postedDate);
    draft.contentLink = fullDetail?.content?.contentLink;
    draft.adPermission = fullDetail?.content?.adPermission;

    //--------------------------------------------------------------
    draft.amount = fullDetail?.payment?.amount;
    draft.paymentStatus = fullDetail?.payment?.status;
    draft.paymentDate = isoStringToDateTime(fullDetail?.payment?.paymentDate);
    draft.paymentMethod = fullDetail?.payment?.paymentMethod;
    draft.invoiceNumber = fullDetail?.payment?.invoiceNumber;

    //--------------------------------------------------------------
    draft.note = fullDetail?.note?.note;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  BlocConsumer<AddCreatorCubit, AddCreatorState>(
                    listener: (context, state) {
                      if (state is CreatorSaveError) {
                        context.showTopSnackBar(state.message);
                      }
                      if (state is CreatorUpdatedSuccess) {
                         context.showTopSnackBar(
                          'Creator update successfully',
                          color: context.af.colors.successContainer,
                        );
                        context.read<ShowAllCreatorCubit>().refreshCreators();
                        Navigator.pop(context);
                      }
                      if (state is CreatorSaveSuccess) {
                        context.showTopSnackBar(
                          'Creator saved successfully',
                          color: context.af.colors.successContainer,
                        );
                        context.read<ShowAllCreatorCubit>().refreshCreators();
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is CreatorSaveLoading) {
                        return const CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          if (draft.name == null ||
                              draft.name!.isEmpty ||
                              draft.platform == null ||
                              draft.followers == null ||
                              draft.followers!.isEmpty) {
                            context.showTopSnackBar('* Fields are required');
                            return;
                          }

                          if (widget.creatorId == null) {
                            context.read<AddCreatorCubit>().saveCreator(draft);
                          } else {
                            context.read<AddCreatorCubit>().updateCreator(
                              draft,
                            );
                          }
                        },
                        child: const Text("Save"),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: context.spacing.s4),
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
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: context.spacing.s4,
                      ),
                      child: CreatorForm(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: context.spacing.s4,
                      ),
                      child: OutReach(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: context.spacing.s4,
                      ),
                      child: Deals(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: context.spacing.s4,
                      ),
                      child: ProductTracking(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: context.spacing.s4,
                      ),
                      child: Content(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: context.spacing.s4,
                      ),
                      child: Payment(draft: draft),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: context.spacing.s4,
                      ),
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
            initialValue: draft.name,
            hintText: 'Name',
            onChanged: (v) => draft.name = v,
          ),

          AppTextField(
            initialValue: draft.followers,
            hintText: 'Followers',
            onChanged: (v) => draft.followers = v,
          ),

          AppTextField(
            initialValue: draft.phone,
            hintText: 'phone number',
            onChanged: (v) => draft.phone = v,
          ),

          AppTextField(
            initialValue: draft.email,
            hintText: 'email',
            onChanged: (v) => draft.email = v,
          ),

          AppTextField(
            initialValue: draft.address,
            hintText: 'address',
            onChanged: (v) => draft.address = v,
          ),

          AppTextField(
            initialValue: draft.location,
            hintText: 'location',
            onChanged: (v) => draft.location = v,
          ),

          AppDropdown(
            value: draft.platform,
            hintText: 'Platform',
            items: const [
              DropdownMenuItem(value: 'Instagram', child: Text('Instagram')),
              DropdownMenuItem(value: 'Facebook', child: Text('Facebook')),
              DropdownMenuItem(value: 'Youtube', child: Text('Youtube')),
            ],
            onChanged: (value) {
              draft.platform = value;
            },
          ),

          AppDropdown(
            value: draft.niche,
            hintText: 'Niche',
            items: const [
              DropdownMenuItem(value: "Food", child: Text("Food")),
              DropdownMenuItem(value: "Lifestyle", child: Text("Lifestyle")),
              DropdownMenuItem(value: "Family", child: Text("Family")),
              DropdownMenuItem(value: "Fashion", child: Text("Fashion")),
              DropdownMenuItem(value: "Beauty", child: Text("Beauty")),
              DropdownMenuItem(value: "Travel", child: Text("Travel")),
              DropdownMenuItem(value: "Fitness", child: Text("Fitness")),
              DropdownMenuItem(value: "Tech", child: Text("Tech")),
              DropdownMenuItem(
                value: "Entertainment",
                child: Text("Entertainment"),
              ),
              DropdownMenuItem(value: "Education", child: Text("Education")),
              DropdownMenuItem(value: "Cooking", child: Text("Cooking")),
              DropdownMenuItem(
                value: "Restaurant Review",
                child: Text("Restaurant Review"),
              ),
              DropdownMenuItem(value: "Daily Vlog", child: Text("Daily Vlog")),
            ],
            onChanged: (value) {
              draft.niche = value;
            },
          ),

          AppDropdown(
            value: draft.engagementRate,
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
            value: draft.outreachStatus,
            hintText: 'Status',
            items: const [
              DropdownMenuItem(
                value: 'Message Sent',
                child: Text('Message Sent'),
              ),
              DropdownMenuItem(value: 'Replied', child: Text('Replied')),
              DropdownMenuItem(
                value: 'Negotiating',
                child: Text('Negotiating'),
              ),
              DropdownMenuItem(
                value: 'Deal Agreed',
                child: Text('Deal Agreed'),
              ),
              DropdownMenuItem(
                value: 'No Response',
                child: Text('No Response'),
              ),
              DropdownMenuItem(value: 'Completed', child: Text('Completed')),
              DropdownMenuItem(value: 'Declined', child: Text('Declined')),
            ],
            onChanged: (value) {
              draft.outreachStatus = value;
            },
          ),

          AppDateField(
            value: draft.firstMessageDate,
            hintText: 'First Message Date',
            onChanged: (v) => draft.firstMessageDate = v,
          ),

          AppDateField(
            value: draft.lastFollowupDate,
            hintText: 'Last Message Date',
            onChanged: (v) => draft.lastFollowupDate = v,
          ),

          AppDateField(
            value: draft.nextFollowupDate,
            hintText: 'Next Followup Date',
            onChanged: (v) => draft.nextFollowupDate = v,
          ),

          AppDropdown(
            value: draft.communicationChannel == null || draft.communicationChannel!.isEmpty
                ? null
                : draft.communicationChannel,
            hintText: 'Communication Channel',
            items: const [
              DropdownMenuItem(value: 'Instagram', child: Text('Instagram')),
              DropdownMenuItem(value: 'Whatsapp', child: Text('Whatsapp')),
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
            initialValue: draft.askedPrice == null
                ? ''
                : draft.askedPrice.toString(),
            hintText: 'Asked Price',
            onChanged: (v) => draft.askedPrice = double.tryParse(v),
          ),

          AppTextField(
            initialValue: draft.finalPrice == null
                ? ''
                : draft.finalPrice.toString(),
            hintText: 'Final Price',
            onChanged: (v) => draft.finalPrice = double.tryParse(v),
          ),

          AppTextField(
            initialValue: draft.deliverables,
            hintText: 'Deliverables',
            onChanged: (v) => draft.deliverables = v,
          ),

          AppTextField(
            initialValue: draft.productName,
            hintText: 'Product Names (comma separated)',
            onChanged: (v) => draft.productName = v,
          ),

          AppDropdown(
            value: draft.collaborationType,
            hintText: 'Collaboration Type',
            items: const [
              DropdownMenuItem(value: 'Barter', child: Text('Barter')),
              DropdownMenuItem(value: 'Paid', child: Text('Paid + Product')),
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
            initialValue: draft.productName,
            hintText: 'Product Name',
            onChanged: (v) => draft.productName = v,
          ),

          AppDropdown(
            hintText: 'Status',
            items: [
              DropdownMenuItem(value: 'Reported', child: Text('Reported')),
              DropdownMenuItem(value: 'Dispatched', child: Text('Dispatched')),
              DropdownMenuItem(value: 'Canceld', child: Text('Canceld')),
              DropdownMenuItem(value: 'Delayed', child: Text('Delayed')),
              DropdownMenuItem(value: 'Received', child: Text('Received')),
            ],
            onChanged: (value) {
              draft.productStatus = value;
            },
          ),

          AppTextField(
            hintText: 'Tracking Number',
            onChanged: (v) => draft.trackingNumber = v,
          ),

          AppDropdown(
            hintText: 'Courier',
            items: const [
              DropdownMenuItem(value: 'DTDC', child: Text('DTDC')),
              DropdownMenuItem(value: 'Delhivery', child: Text('Delhivery')),
              DropdownMenuItem(value: 'Amazone', child: Text('Amazone')),
              DropdownMenuItem(value: 'Flipkart', child: Text('Flipkart')),
              DropdownMenuItem(value: 'Porter', child: Text('Porter')),
            ],
            onChanged: (value) {
              draft.courier = value;
            },
          ),

          AppDateField(
            value: draft.dispatchDate,
            hintText: 'Dispatch Date',
            onChanged: (v) => draft.dispatchDate = v,
          ),

          AppDateField(
            value: draft.deliveryDate,
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
            value: draft.contentReceived,
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
            value: draft.contentApproved,
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
            value: draft.creatorBraftSent,
            hintText: 'Creator Brief Sent',
            items: const [
              DropdownMenuItem(value: true, child: Text('Yes')),
              DropdownMenuItem(value: false, child: Text('No')),
            ],
            onChanged: (value) {
              draft.creatorBraftSent = value;
            },
          ),

          AppDropdown(
            value: draft.adPermission,
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
            value: draft.postedDate,
            hintText: 'Posted Date',
            onChanged: (v) => draft.postedDate = v,
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
            initialValue: draft.amount == null ? '' : draft.amount.toString(),
            hintText: 'Amount Paid',
            onChanged: (v) => draft.amount = double.tryParse(v),
          ),

          AppTextField(
            initialValue: draft.invoiceNumber,
            hintText: 'Invoice Number',
            onChanged: (v) => draft.invoiceNumber = v,
          ),

          AppDropdown(
            value: draft.paymentStatus,
            hintText: 'Status',
            items: const [
              DropdownMenuItem(value: 'Paid', child: Text('Paid')),
              DropdownMenuItem(value: 'Pending', child: Text('Pending')),
            ],
            onChanged: (value) {
              draft.paymentStatus = value;
            },
          ),

          AppDropdown(
            value: draft.paymentMethod,
            hintText: 'Payment Method',
            items: const [
              DropdownMenuItem(value: 'UPI', child: Text('UPI')),
              DropdownMenuItem(
                value: 'Bank Transfer',
                child: Text('Bank Transfer'),
              ),
            ],
            onChanged: (value) {
              draft.paymentMethod = value;
            },
          ),

          AppDateField(
            value: draft.paymentDate,
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
            initialValue: draft.note,
            hintText: 'Notes',
            onChanged: (v) => draft.note = v,
          ),
        ],
      ),
    );
  }
}
