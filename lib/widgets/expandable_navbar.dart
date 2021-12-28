import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../extensions/extension.dart';
import '../shared/shared_value.dart';
import '../widgets/my_text.dart';

class ExpandableNavbar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final double? minHeight; // Default 72
  final double? maxHeight; // Default 350
  final List<Map<String, String>> items;

  const ExpandableNavbar({
    Key? key,
    this.minHeight,
    this.maxHeight,
    required this.items,
    required this.selectedIndex,
    this.onTap,
  }) : super(key: key);

  @override
  _ExpandableNavbarState createState() => _ExpandableNavbarState();
}

class _ExpandableNavbarState extends State<ExpandableNavbar>
    with SingleTickerProviderStateMixin {
  // Animation Controller
  late AnimationController _animController;

  // Expand state
  bool _expanded = false;

  // Height variable
  late final double _minHeight = context.dp(widget.minHeight ?? 72);
  late final double _maxHeight = context.dp(widget.maxHeight ?? 350);
  late double _currentHeight = _minHeight;

  @override
  void initState() {
    // Initiate animation controller
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    // Dispose animation controller.
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // On Update use to update animation controller value depends on user vertical drag.
      onVerticalDragUpdate: _expanded
          ? (details) {
              setState(() {
                final newHeight = _currentHeight - details.delta.dy;
                _animController.value = _currentHeight / _maxHeight;
                _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
              });
            }
          : null,
      // On Drag Ended, we have to specify either it's expanded or collapsed.
      // If current height is below maxHeight / 2 then it should be collapsed.
      onVerticalDragEnd: _expanded
          ? (details) {
              if (_currentHeight < _maxHeight / 2) {
                _animController.reverse();
                _expanded = false;
              } else {
                _expanded = true;
                _animController.forward(from: _currentHeight / _maxHeight);
                _currentHeight = _maxHeight;
              }
            }
          : null,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final value = _animController.value;
          return Stack(
            children: [
              // Use lerpDouble to linearly interpolate between two numbers, a and b, by an extrapolation factor t.
              Positioned(
                height: lerpDouble(_minHeight, _maxHeight, value),
                left: lerpDouble(context.dp(kPadding), 0.0, value),
                right: lerpDouble(context.dp(kPadding), 0.0, value),
                bottom: lerpDouble(context.dp(kPadding), 0.0, value),
                child: _expanded
                    ? _buildExpandedContainer(context)
                    : _buildCollapsedContainer(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // COLLAPSED CONTAINER WIDGET======================================================
  Container _buildCollapsedContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            offset: Offset(1, 1),
            blurRadius: 4,
          )
        ],
        borderRadius: BorderRadius.circular(kRadius),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: context.dp(6)),
              Container(
                width: context.dp(100),
                height: context.dp(4),
                decoration: BoxDecoration(
                    color: context.disableColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                    4,
                    (index) => InkWell(
                          onTap: () => widget.onTap?.call(index),
                          child: SvgPicture.asset(widget.items[index]['icon']!,
                              color: (index == widget.selectedIndex)
                                  ? context.primaryColor
                                  : context.hintColor),
                        )),
              ),
              const Spacer(),
            ],
          ),
          // Gesture area above other widget.
          Positioned(
            top: 0,
            left: (context.dw / 2) - (context.dp(kPadding + 20)),
            right: (context.dw / 2) - (context.dp(kPadding + 20)),
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // if it is not expanded yet, set expanded to true dan play forward animation.
                // When expanded set to true. Method on another gesture will be active.
                if (!_expanded && details.delta.dy < 0) {
                  setState(() {
                    _expanded = true;
                    _currentHeight = _maxHeight;
                    _animController.forward(from: 0.0);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // END OF COLLAPSED CONTAINER WIDGET===============================================

  // EXPANDED CONTAINER WIDGET=======================================================
  Container _buildExpandedContainer(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.dp(kPadding), vertical: context.dp(8)),
        decoration: BoxDecoration(
          color: context.surface,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, -2),
              blurRadius: 6,
            )
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(46)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.dp(100),
              height: 3,
              decoration: BoxDecoration(
                  color: context.disableColor,
                  borderRadius: BorderRadius.circular(30)),
            ),
            SizedBox(height: context.dp(32)),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: context.dp(8),
                mainAxisSpacing: context.dp(8),
                childAspectRatio: 1,
                children: List<Widget>.generate(
                  widget.items.length,
                  (index) => Column(
                    children: [
                      SvgPicture.asset(
                        widget.items[index]['icon']!,
                        color: context.hintColor,
                      ),
                      const SizedBox(height: 4),
                      MyText(widget.items[index]['name']!),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
// END OF EXPANDED CONTAINER WIDGET================================================
}
