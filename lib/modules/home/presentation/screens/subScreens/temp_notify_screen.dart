import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../app/common/models/notifiy_model.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../widgets/custom_app_bar.dart';

class TempNotifyScreen extends StatelessWidget {
  final ReceivedNotifyModel receivedNotifyModel;
  const TempNotifyScreen({Key? key, required this.receivedNotifyModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.notification,
        hideNotifyIcon: true,
      ),
      body: receivedNotifyModel.id == AppConstants.negativeOne
          ? Center(child: Lottie.asset(JsonAssets.empty))
          : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p10,
                      vertical: AppPadding.p20,
                    ),
                    child: Column(
                      children: [
                        Text(receivedNotifyModel.title!),
                        const SizedBox(
                          height: AppSize.s20,
                        ),
                        const Divider(
                          height: AppSize.s2,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(receivedNotifyModel.body!),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
