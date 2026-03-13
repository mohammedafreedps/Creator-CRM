import 'package:afui/afui.dart';
import 'package:creator_tracker/screen/add_creator_screen/add_creator_screen.dart';
import 'package:creator_tracker/screen/add_creator_screen/cubit/cubit/add_creator_cubit.dart';
import 'package:creator_tracker/screen/creator_details_screen/cubit/cubit/creator_details_cubit.dart';
import 'package:creator_tracker/screen/home_screen/cubit/show_all_creator/show_all_creator_cubit.dart';
import 'package:creator_tracker/utils/format_date.dart';
import 'package:creator_tracker/widgets/app_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatorDetailsScreen extends StatefulWidget {
  final int creatorId;
  const CreatorDetailsScreen({super.key, required this.creatorId});

  @override
  State<CreatorDetailsScreen> createState() => _CreatorDetailsScreenState();
}

class _CreatorDetailsScreenState extends State<CreatorDetailsScreen> {
  final ScrollController chipScrollController = ScrollController();

  DateTime? _lastSwipeTime;
  static const int swipeDebounceMs = 300;
  static const double minSwipeVelocity = 300;

  List<String> segment = [
    'Details',
    'Outreach',
    'Deals',
    'Product Tracking',
    'Content',
    'Payments',
    'Notes',
  ];

  int selectedIndex = 0;

  double alignmentX = 0;

  CreatorFullDetail? creatorFullDetail;

  @override
  void initState() {
    super.initState();
    context.read<CreatorDetailsCubit>().loadCreatorDetail(widget.creatorId);
  }

  void scrollToChip() {
    final offset = selectedIndex * 100;

    chipScrollController.animateTo(
      offset.toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void nextSegment() {
    if (selectedIndex < segment.length - 1) {
      setState(() {
        selectedIndex++;
        alignmentX = 1;
      });

      scrollToChip();
    }
  }

  void previousSegment() {
    if (selectedIndex > 0) {
      setState(() {
        selectedIndex--;
        alignmentX = -1;
      });

      scrollToChip();
    }
  }

  void handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity;

    if (velocity == null) return;

    // Ignore small swipes
    if (velocity.abs() < minSwipeVelocity) return;

    // Debounce
    final now = DateTime.now();
    if (_lastSwipeTime != null &&
        now.difference(_lastSwipeTime!).inMilliseconds < swipeDebounceMs) {
      return;
    }

    _lastSwipeTime = now;

    if (velocity < 0) {
      nextSegment();
    } else {
      previousSegment();
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          alignmentX = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddCreatorCubit, AddCreatorState>(
      listener: (context, state) {
        if (state is CreatorUpdatedSuccess) {
          context.read<CreatorDetailsCubit>().loadCreatorDetail(
            widget.creatorId,
          );
          context.read<ShowAllCreatorCubit>().loadCreators();
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onHorizontalDragEnd: handleSwipe,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.s3,
                vertical: context.spacing.s2,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCreatorScreen(
                                creatorId: widget.creatorId,
                                selectedStep: selectedIndex + 1,
                                creatorFullDetail: creatorFullDetail,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),

                  /// CHIP ROW (always visible)
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      controller: chipScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: segment.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: context.spacing.s1),
                          child: AppFilterChip(
                            label: segment[index],
                            isSelected: selectedIndex == index,
                            onSelected: (_) {
                              setState(() {
                                selectedIndex = index;
                              });

                              scrollToChip();
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: context.spacing.s16),

                  /// CONTENT
                  Expanded(
                    child:
                        BlocBuilder<CreatorDetailsCubit, CreatorDetailsState>(
                          builder: (context, state) {
                            if (state is CreatorDetailLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (state is CreatorDetailError) {
                              return Center(child: Text(state.message));
                            }

                            if (state is CreatorDetailLoaded) {
                              creatorFullDetail = state.data;
                              return SingleChildScrollView(
                                child: _buildSegmentContent(state.data),
                              );
                            }

                            return const SizedBox();
                          },
                        ),
                  ),

                  /// BOTTOM SWIPE CONTROLLER
                  GestureDetector(
                    onHorizontalDragEnd: handleSwipe,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Opacity(
                          opacity: 0,
                          child: Container(
                            margin: EdgeInsets.only(
                              right: context.spacing.s10,
                              bottom: context.spacing.s5,
                            ),
                            padding: EdgeInsets.all(context.spacing.s5),
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  context.colors.infoContainer,
                                  context.af.colors.background,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                          
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              width: 20,
                              height: 20,
                          
                              child: AnimatedAlign(
                                duration: const Duration(milliseconds: 250),
                                alignment: Alignment(alignmentX, 0),
                          
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.colors.successContainer,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentContent(CreatorFullDetail data) {
    switch (selectedIndex) {
      case 0:
        return _creatorDetails(data);
      case 1:
        return _outreach(data);
      case 2:
        return _deal(data);
      case 3:
        return _product(data);
      case 4:
        return _content(data);
      case 5:
        return _payment(data);
      case 6:
        return _notes(data);
      default:
        return const SizedBox();
    }
  }

  Widget _creatorDetails(CreatorFullDetail data) {
    final c = data.creator;

    return DetailSection(
      title: "Creator Details",
      children: [
        DetailRow(label: "Name", value: c.name),
        DetailRow(label: "Platform", value: c.platform ?? ''),
        DetailRow(label: "Niche", value: c.niche ?? ''),
        DetailRow(label: "Followers", value: c.followers.toString()),
        DetailRow(label: "Engagement", value: c.engagementRate ?? ''),
        if (c.phone != null) DetailRow(label: "Phone", value: c.phone!),
        if (c.email != null) DetailRow(label: "Email", value: c.email!),
        if (c.location != null)
          DetailRow(label: "Location", value: c.location!),
      ],
    );
  }

  Widget _outreach(CreatorFullDetail data) {
    final o = data.outreach;

    if (o == null) {
      return const Center(child: Text("No Outreach Data"));
    }

    return DetailSection(
      title: "Outreach",
      children: [
        DetailRow(label: "Status", value: o.status ?? "-"),
        DetailRow(label: "Channel", value: o.communicationChannel ?? "-"),
        DetailRow(
          label: "First Message",
          value: formatDate(o.firstMessageDate),
        ),
        DetailRow(
          label: "Last Followup",
          value: formatDate(o.lastFollowupDate),
        ),
        DetailRow(
          label: "Next Followup",
          value: formatDate(o.nextFollowupDate),
        ),
      ],
    );
  }

  Widget _deal(CreatorFullDetail data) {
    final d = data.deal;

    if (d == null) {
      return const Center(child: Text("No Deal Data"));
    }

    return DetailSection(
      title: "Deal",
      children: [
        DetailRow(label: "Type", value: d.collaborationType),
        DetailRow(label: "Asked Price", value: "${d.askedPrice ?? "-"}"),
        DetailRow(label: "Final Price", value: "${d.finalPrice ?? "-"}"),
        DetailRow(label: "Deliverables", value: d.deliverables ?? "-"),
      ],
    );
  }

  Widget _product(CreatorFullDetail data) {
    final p = data.product;

    if (p == null) {
      return const Center(child: Text("No Product Data"));
    }

    return DetailSection(
      title: "Product Tracking",
      children: [
        DetailRow(label: "Product", value: p.productName ?? "-"),
        DetailRow(label: "Status", value: p.status ?? "-"),
        DetailRow(label: "Courier", value: p.courier ?? "-"),
        DetailRow(label: "Tracking", value: p.trackingNumber ?? "-"),
      ],
    );
  }

  Widget _content(CreatorFullDetail data) {
    final c = data.content;

    if (c == null) {
      return const Center(child: Text("No Content Data"));
    }

    return DetailSection(
      title: "Content",
      children: [
        DetailRow(
          label: "Received",
          value: c.contentReceived ? "Yes" : "No",
        ),
        DetailRow(
          label: "Approved",
          value: c.contentApproved ? "Yes" : "No",
        ),
        DetailRow(label: "Posting Date", value: formatDate(c.postingDate)),
      ],
    );
  }

  Widget _payment(CreatorFullDetail data) {
    final p = data.payment;

    if (p == null) {
      return const Center(child: Text("No Payment Data"));
    }

    return DetailSection(
      title: "Payment",
      children: [
        DetailRow(label: "Amount", value: "${p.amount ?? "-"}"),
        DetailRow(label: "Status", value: p.status ?? "-"),
        DetailRow(label: "Method", value: p.paymentMethod ?? "-"),
        DetailRow(label: "Invoice", value: p.invoiceNumber ?? "-"),
      ],
    );
  }

  Widget _notes(CreatorFullDetail data) {
    final n = data.note;

    if (n == null) {
      return const Center(child: Text("No Notes"));
    }

    return DetailSection(title: "Notes", children: [Text(n.note ?? "-")]);
  }
}

class DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const DetailSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.spacing.s4),
      padding: EdgeInsets.all(context.spacing.s4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(context.radius.md),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: context.spacing.s3),
          ...children,
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.s2),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
