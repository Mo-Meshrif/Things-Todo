import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/assets_manager.dart';
import 'custom_loading.dart';

class ImageBuilder extends StatelessWidget {
  final bool hasPlaceHolder;
  final String imageUrl;
  final double? height, width;
  final BoxFit? fit;
  final ImageWidgetBuilder? imageBuilder;
  final Widget? errorWidget, placeholder;

  const ImageBuilder({
    Key? key,
    this.hasPlaceHolder = true,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.imageBuilder,
    this.errorWidget,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String x = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
    return x.length > 4
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            height: height,
            width: width,
            fit: fit,
            placeholder: !hasPlaceHolder
                ? null
                : (_, __) => placeholder ?? const CustomLoading(),
            fadeOutDuration: placeholder == null
                ? null
                : const Duration(
                    milliseconds: 100,
                  ),
            errorWidget: (context, url, error) =>
                errorWidget ??
                Image.asset(
                  ImageAssets.placeHolder,
                  height: height,
                  width: width,
                  fit: fit,
                ),
            imageBuilder: imageBuilder,
          )
        : errorWidget ??
            Image.asset(
              ImageAssets.placeHolder,
              height: height,
              width: width,
              fit: fit,
            );
  }
}
