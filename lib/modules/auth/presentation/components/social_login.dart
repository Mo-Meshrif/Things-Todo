import 'package:flutter/material.dart';

import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/assets_manager.dart';
import '../controller/auth_bloc.dart';
import '../widgets/custom_social_button.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = sl<AuthBloc>();
    //TODO re-config social login
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomSocialButton(
          iconName: IconAssets.facebook,
          onPress: () => authBloc.add(
            FacebookLoginEvent(),
          ),
        ),
        CustomSocialButton(
          iconName: IconAssets.twitter,
          onPress: () => authBloc.add(
            TwitterLoginEvent(),
          ),
        ),
        CustomSocialButton(
          iconName: IconAssets.google,
          onPress: () => authBloc.add(
            GoogleLoginEvent(),
          ),
        ),
      ],
    );
  }
}
