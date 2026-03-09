import 'package:afui/afui.dart';
import 'package:creator_tracker/screen/add_creator_screen/add_creator_screen.dart';
import 'package:creator_tracker/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    return Scaffold(
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
                    IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
                  ],
                ),
                SizedBox(height: context. spacing.s4),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context. spacing.s14),
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
                        horizontal: context. spacing.s2,
                        vertical: context. spacing.s1,
                      ),
                      label: Text('data dsfsadfadf'),
                      onSelected: (value) {},
                    ),
                  ],
                ),
                SizedBox(height: context. spacing.s3),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: 50,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(bottom: context. spacing.s5),
                        padding: EdgeInsets.all(context. spacing.s5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context. colors.surface,
                          borderRadius: BorderRadius.circular(context. radius.md),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'mohd.afreed_',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  '@instagram . Tech . 500k',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text('Replied')],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
    );
  }
}
