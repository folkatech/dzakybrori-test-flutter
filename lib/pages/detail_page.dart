import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:folkatech_food/providers/food_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../extensions/extension.dart';
import '../models/food.dart';
import '../shared/shared_method.dart';
import '../shared/shared_value.dart';
import '../widgets/hero_widget.dart';
import '../widgets/my_image_network.dart';
import '../widgets/my_text.dart';
import '../widgets/svg_button.dart';

class DetailPage extends StatefulWidget {
  final Food food;

  const DetailPage({Key? key, required this.food}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    // Hide status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  void dispose() {
    // Display status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surface,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            _buildSliverAppBar(context),
            _buildMainContent(context),
          ],
        ),
      ),
    );
  }

  // DETAIL HEADER=================================================================
  SliverAppBar _buildSliverAppBar(BuildContext context) => SliverAppBar(
        elevation: 0,
        stretch: true,
        floating: true,
        titleSpacing: 0,
        leadingWidth: 0,
        forceElevated: false,
        expandedHeight: context.h(350),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(46)),
        ),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(46)),
                    child: HeroWidget(
                        tag: widget.food.id.foodCover,
                        child: MyImageNetwork(widget.food.cover))),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(context.dp(kPadding)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgButton(
                        onTap: () => Navigator.pop(context),
                        path: 'assets/svg/back_arrow.svg',
                        borderRadius: BorderRadius.circular(10),
                        width: context.dp(40),
                        height: context.dp(40),
                      ),
                      HeroWidget(
                        tag: widget.food.id.foodBookmark,
                        childFitted: Consumer<FoodProvider>(
                          builder: (context, value, child) => SvgButton(
                            onTap: () {},
                            path: value.findById(widget.food.id).isBookmarked
                                ? 'assets/svg/active_bookmark.svg'
                                : 'assets/svg/bookmark.svg',
                            borderRadius: BorderRadius.circular(10),
                            width: context.dp(40),
                            height: context.dp(40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  // END OF DETAIL HEADER==========================================================

  // MAIN CONTENT==================================================================
  SliverPadding _buildMainContent(BuildContext context) => SliverPadding(
        padding: EdgeInsets.all(context.dp(36)),
        sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeroWidget(
                  tag: widget.food.id.foodName,
                  childFitted: MyText(widget.food.name,
                      maxLine: 1, style: context.text.headline6),
                ),
                HeroWidget(
                  tag: widget.food.id.foodPrice,
                  childFitted: MyText(
                    formatNumber(widget.food.price),
                    maxLine: 1,
                    style: context.text.subtitle1,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dp(26)),
            MyText('Description', style: context.text.subtitle2),
            SizedBox(height: context.dp(12)),
            ReadMoreText(
              widget.food.desc,
              style: context.text.bodyText2,
              textScaleFactor: context.ts,
              trimLines: 5,
              colorClickableText: context.hintColor,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'more',
              trimExpandedText: 'less',
              moreStyle:
                  context.text.bodyText2?.copyWith(fontWeight: FontWeight.w600),
              lessStyle:
                  context.text.bodyText2?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: context.dp(32)),
            ElevatedButton(onPressed: () {}, child: const MyText('Add To Cart'))
          ]),
        ),
      );
// END OF MAIN CONTENT===========================================================
}
