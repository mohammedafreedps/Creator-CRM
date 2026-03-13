import 'package:afui/afui.dart';
import 'package:creator_tracker/screen/add_creator_screen/add_creator_screen.dart';
import 'package:creator_tracker/screen/creator_details_screen/creator_details_screen.dart';
import 'package:creator_tracker/screen/home_screen/cubit/delete_creator/delete_creator_cubit.dart';
import 'package:creator_tracker/screen/home_screen/cubit/show_all_creator/show_all_creator_cubit.dart';
import 'package:creator_tracker/screen/setting_screen/setting_screen.dart';
import 'package:creator_tracker/service/settings_service.dart';
import 'package:creator_tracker/utils/format_date.dart';
import 'package:creator_tracker/widgets/app_filter_chip.dart';
import 'package:creator_tracker/widgets/app_show_yes_no_dialoge.dart';
import 'package:creator_tracker/widgets/app_snackbar.dart';
import 'package:creator_tracker/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showFab) {
          setState(() {
            _showFab = false;
          });
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showFab) {
          setState(() {
            _showFab = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteCreatorCubit, DeleteCreatorState>(
      listener: (context, state) {
        if(state is DeleteCreatorSuccess){
          appTopSnackBar(context, 'Creator Succusfully Deleted');
          context.read<ShowAllCreatorCubit>().loadCreators();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.s5,
              vertical: context.spacing.s2,
            ),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.settings),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spacing.s4),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing.s14,
                        ),
                        child: AppTextField(
                          hintText: 'Search Creator',
                          focusNode: _searchFocusNode,
                          prefixIcon: Icons.search,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      FilterChip(
                        selected: false,
                        showCheckmark: false,
                        side: BorderSide.none,
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing.s2,
                          vertical: context.spacing.s1,
                        ),
                        label: Text('data dsfsadfadf'),
                        onSelected: (value) {},
                      ),
                      AppFilterChip(
                        isSelected: false,
                        label: 'text',
                        onSelected: (value) {},
                      ),
                    ],
                  ),
                  SizedBox(height: context.spacing.s3),
                  BlocConsumer<ShowAllCreatorCubit, ShowAllCreatorState>(
                    listener: (context, state) {
                      if (state is CreatorListError) {
                        appTopSnackBar(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is CreatorListEmpty) {
                        return Expanded(child: Text('data is Empty'));
                      }
                      if (state is CreatorListLoading) {
                        return Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (state is CreatorListLoaded) {
                        return Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: state.creators.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onLongPress: () {
                                if (SettingsService.enableDelete) {
                                  showYesNoDialog(
                                    context: context,
                                    title: 'Delete Creator',
                                    message:
                                        'Are you sure you want to delete this creator?',
                                    onYes: () {
                                      if(state.creators[index].creator.id == null){
                                        return;
                                      }
                                      context.read<DeleteCreatorCubit>().deleteCreator(state.creators[index].creator.id!);
                                    },
                                  );
                                }
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatorDetailsScreen(
                                      creatorId:
                                          state.creators[index].creator.id!,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: context.spacing.s5,
                                ),
                                padding: EdgeInsets.all(context.spacing.s5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(
                                    context.radius.md,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.creators[index].creator.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '@${state.creators[index].creator.platform} . ${state.creators[index].creator.niche} . ${state.creators[index].creator.followers}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: context.af.spacing.s3),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatDate(
                                            state
                                                .creators[index]
                                                .outreach
                                                ?.firstMessageDate,
                                          ),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        Text(
                                          state
                                                  .creators[index]
                                                  .outreach
                                                  ?.status ??
                                              'No Outreach',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Text('data');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: AnimatedSlide(
          duration: Duration(milliseconds: 200),
          offset: _showFab ? Offset.zero : Offset(0, 2),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _showFab ? 1 : 0,
            child: GestureDetector(
              onDoubleTap: () {
                FocusScope.of(context).requestFocus(_searchFocusNode);
              },
              child: FloatingActionButton(
                onPressed: () async {
                  _searchFocusNode.unfocus();

                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddCreatorScreen()),
                  );

                  if (mounted) {
                    _searchFocusNode.unfocus();
                  }
                },
                backgroundColor: context.colors.primary,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
