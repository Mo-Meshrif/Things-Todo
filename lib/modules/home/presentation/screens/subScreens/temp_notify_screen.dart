import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../app/common/models/notifiy_model.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../widgets/custom_app_bar.dart';

class TempNotifyScreen extends StatelessWidget {
  final ReceivedNotifyModel receivedNotifyModel;
  const TempNotifyScreen({Key? key, required this.receivedNotifyModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification',
        hideNotifyIcon: true,
      ),
      body: receivedNotifyModel.id == -1
          ? Center(child: Lottie.asset(JsonAssets.empty))
          : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      children: [
                        Text(receivedNotifyModel.title!),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          height: 2,
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
