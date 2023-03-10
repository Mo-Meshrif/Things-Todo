import 'package:flutter/material.dart';

import '../../../../app/utils/assets_manager.dart';
import '../widgets/custom_social_button.dart';

class SocialLogin extends StatelessWidget {
  final void Function() facebookFun;
  final void Function() twitterFun;
  final void Function() googleFun;

  const SocialLogin({
    Key? key,
    required this.facebookFun,
    required this.twitterFun,
    required this.googleFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomSocialButton(
          iconName: IconAssets.facebook,
          onPress: facebookFun,
        ),
        CustomSocialButton(
          iconName: IconAssets.twitter,
          onPress: twitterFun,
        ),
        CustomSocialButton(
          iconName: IconAssets.google,
          onPress: googleFun,
        ),
      ],
    );
  }
}
