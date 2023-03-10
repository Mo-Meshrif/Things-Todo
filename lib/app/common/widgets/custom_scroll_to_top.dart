import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import '../../../../app/utils/values_manager.dart';

class CustomScrollToTop extends StatelessWidget {
  const CustomScrollToTop({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext, ScrollViewProperties) builder;
  @override
  Widget build(BuildContext context) {
    return ScrollWrapper(
      enabledAtOffset: AppSize.s250,
      promptAlignment: Alignment.bottomCenter,
      builder: builder,
    );
  }
}
