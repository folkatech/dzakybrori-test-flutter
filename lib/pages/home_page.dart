import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../extensions/extension.dart';
import '../models/food.dart';
import '../pages/detail_page.dart';
import '../providers/food_provider.dart';
import '../shared/shared_method.dart';
import '../shared/shared_value.dart';
import '../widgets/expandable_navbar.dart';
import '../widgets/hero_widget.dart';
import '../widgets/my_image_network.dart';
import '../widgets/my_text.dart';
import '../widgets/shimmer_widget.dart';
import '../widgets/svg_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _title = 'What do you want\nto eat today?';

  // Navbar item selected index
  int _selectedIndex = 0;

  // Scroll controller for pull down refresh
  final _scrollController = ScrollController();

  // Using late because it should be initialize when HomePageState context is ready.
  late FoodProvider _foodProvider;

  @override
  void initState() {
    // Adding listener to scroll controller.
    _scrollController.addListener(_scrollListener);
    super.initState();
    // Initiate foodProvider, using listen false cause we doesn't care about any changes.
    _foodProvider = Provider.of<FoodProvider>(context, listen: false);
  }

  // Dispose any listener and service to prevent memory leak
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Prevent doubled setState
  @override
  void setState(VoidCallback fn) => (mounted) ? super.setState(fn) : fn();

  @override
  Widget build(BuildContext context) {
    // If data cache is empty and context is ready, request the data.
    if (_foodProvider.foods.isEmpty && mounted) {
      _foodProvider.getFoods();
    }
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            _buildSliverAppBar(context),
            _buildMainContent(context),
          ],
        ),
      ),
      bottomNavigationBar: ExpandableNavbar(
        items: menu,
        selectedIndex: _selectedIndex,
        onTap: (value) => setState(() => _selectedIndex = value),
      ),
    );
  }

  // LOGICAL METHOD=================================================================
  // Scroll listener.
  void _scrollListener() {
    if (_scrollController.offset < -120) {
      // Call refresh service from provider.
      _foodProvider.refresh();
    }
  }

  // Go to Detail Page
  void _goToDetailPage(Food data) {
    // Push navigation with fade in transition for smoothing Hero Animation.
    Navigator.push(
      context,
      PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            final curvedAnimation = CurvedAnimation(
                parent: animation, curve: Curves.easeInOutCubic);

            return FadeTransition(
              opacity: curvedAnimation,
              child: DetailPage(food: data),
            );
          }),
    );
  }

  // END OF LOGICAL METHOD==========================================================

  // HEADER WIDGET==================================================================
  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      title: const MyText(_title),
      toolbarHeight: context.dp(126),
      titleSpacing: context.dp(kPadding),
      backgroundColor: Colors.transparent,
      foregroundColor: context.onSurface,
      actions: [
        SvgPicture.asset(
          'assets/svg/cart.svg',
          width: context.dp(24),
          fit: BoxFit.fitWidth,
          color: context.onBackground,
        ),
        SizedBox(width: context.dp(kPadding)),
      ],
    );
  }

  // END OF HEADER WIDGET===========================================================

  // FOODS GRID CONTENT=============================================================
  SliverPadding _buildMainContent(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(context.dp(24)),
      sliver: Consumer<FoodProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return child ??
                _buildSliverGrid(context, _buildGridShimmerLoading(context));
          } else if (value.foods.isNotEmpty) {
            List<Widget> foodsData = List<Widget>.generate(
              value.foods.length,
              (index) => _buildFoodItem(context, value.foods[index]),
            );
            return _buildSliverGrid(context, foodsData);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(child: MyText('Couln\'t load the page'))));
            return child ??
                _buildSliverGrid(context, _buildGridShimmerLoading(context));
          }
        },
        child: _buildSliverGrid(context, _buildGridShimmerLoading(context)),
      ),
    );
  }

  // END OF FOODS GRID CONTENT======================================================

  // GRID TEMPLATE==================================================================
  SliverGrid _buildSliverGrid(BuildContext context, List<Widget> children) =>
      SliverGrid.count(
        // Specify number of column
        crossAxisCount: 2,
        crossAxisSpacing: context.dp(16),
        mainAxisSpacing: context.dp(16),
        // Size of item
        childAspectRatio: ((context.dw / 2) - 32) / context.dp(190),
        children: children,
      );

  // END OF GRID TEMPLATE===========================================================

  // FOOD ITEM WIDGET===============================================================
  //// I'm using stack because the ripple effect from InkWell is hidden behind another material.
  //// To make the effect surface I used stack.
  Widget _buildFoodItem(BuildContext context, Food data) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(kRadius)),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Food Images.
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(kRadius)),
                  child: HeroWidget(
                    tag: data.id.foodCover,
                    child: MyImageNetwork(
                      data.cover,
                      width: double.infinity,
                      height: context.dp(146),
                    ),
                  ),
                ),
                // Food Name and Price
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(kRadius))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: context.dp(8)),
                        HeroWidget(
                          tag: data.id.foodName,
                          childFitted: MyText(data.name,
                              maxLine: 1, style: context.text.subtitle2),
                        ),
                        SizedBox(height: context.dp(4)),
                        HeroWidget(
                          tag: data.id.foodPrice,
                          childFitted: MyText(formatNumber(data.price),
                              maxLine: 1, style: context.text.bodyText2),
                        ),
                        SizedBox(height: context.dp(8)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              color: Colors.transparent,
              child: InkWell(
                  highlightColor: context.primaryColor.withOpacity(0.1),
                  splashColor: context.primaryColor.withOpacity(0.2),
                  onTap: () => _goToDetailPage(data),
                  borderRadius: BorderRadius.circular(18)),
            ),
          ),
          // Bookmark button
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(kRadius),
                  bottomLeft: Radius.circular(14)),
              onTap: () => _foodProvider.bookmarkToggle(data.id),
              child: HeroWidget(
                tag: data.id.foodBookmark,
                childFitted: Consumer<FoodProvider>(
                  builder: (context, value, child) => SvgButton(
                    path: value.findById(data.id).isBookmarked
                        ? 'assets/svg/active_bookmark.svg'
                        : 'assets/svg/bookmark.svg',
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(kRadius),
                        bottomLeft: Radius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  // END OF FOOD ITEM WIDGET========================================================

  // SHIMMER LOADING WIDGET=========================================================
  // Method build GridShimmerLoading Widget
  List<Widget> _buildGridShimmerLoading(BuildContext context) =>
      List<Widget>.generate(4, (index) => _buildShimmerItem(context));

  // Loading item shimmer widget
  Container _buildShimmerItem(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(kRadius)),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ShimmerWidget.rounded(
              width: double.infinity,
              height: context.dp(146),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(kRadius)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(kRadius))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: context.dp(8)),
                    ShimmerWidget.rectangle(
                        width: context.dp(113), height: context.dp(16)),
                    SizedBox(height: context.dp(4)),
                    ShimmerWidget.rectangle(
                        width: context.dp(80), height: context.dp(16)),
                    SizedBox(height: context.dp(8)),
                  ],
                ),
              ),
            )
          ],
        ),
      );
// END OF SHIMMER LOADING WIDGET===================================================
}
