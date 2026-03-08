import 'package:afui/afui.dart';
import 'package:creator_tracker/screen/add_creator_screen/add_creator_screen.dart';
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
  Widget build(BuildContext context) {
    final spacing = AfThemeExtension.of(context).spacing;
    final color = AfThemeExtension.of(context).colors;
    final radius = AfThemeExtension.of(context).radius;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s5,
            vertical: spacing.s2,
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
                SizedBox(height: spacing.s4),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.s14),
                      child: Container(
                        padding: EdgeInsets.all(spacing.s1),
                        decoration: BoxDecoration(
                          color: color.surface,
                          borderRadius: BorderRadius.circular(radius.md),
                        ),
                        child: TextField(
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: spacing.s1,
                              vertical: spacing.s3,
                            ),
                            hintText: 'Search Creator',
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.s5),
                Row(
                  children: [
                    FilterChip(
                      selected: false,
                      showCheckmark: false,
                      side: BorderSide.none,
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.s2,
                        vertical: spacing.s1,
                      ),
                      label: Text('data dsfsadfadf'),
                      onSelected: (value) {},
                    ),
                  ],
                ),
                SizedBox(height: spacing.s3),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: 50,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(bottom: spacing.s5),
                        padding: EdgeInsets.all(spacing.s5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color.surface,
                          borderRadius: BorderRadius.circular(radius.md),
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
            onDoubleTap: (){
              FocusScope.of(context).requestFocus(_searchFocusNode);
            },
            child: FloatingActionButton(
              onPressed: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddCreatorScreen()),
                );
              },
              backgroundColor: color.primary,
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
