import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/color_manager.dart';

class CustomLoading extends StatelessWidget {
  final Color? color;

  const CustomLoading({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
        child: Center(
          child: Transform.scale(
            scale: Platform.isIOS ? 1 : 0.5,
            child: CircularProgressIndicator.adaptive(
              valueColor: Platform.isIOS
                  ? null
                  : AlwaysStoppedAnimation<Color>(
                      color ?? ColorManager.primary,
                    ),
            ),
          ),
        ),
      );
}
