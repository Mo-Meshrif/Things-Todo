import 'package:flutter/material.dart';
import '../../../../app/utils/color_manager.dart';

class TabHeader extends SliverPersistentHeaderDelegate {
  final List<Widget> tabs;
  final double maxHeight;
  final double minHeight;

  TabHeader({
    required this.tabs,
    required this.maxHeight,
    required this.minHeight,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: ColorManager.primary,
      child: TabBar(
        indicatorColor: Colors.white,
        tabs: tabs,
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}