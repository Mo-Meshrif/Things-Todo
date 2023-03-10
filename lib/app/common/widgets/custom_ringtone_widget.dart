import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../../../../app/common/models/ring_tone_model.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/helper/shared_helper.dart';
import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';

class RingToneWidget extends StatefulWidget {
  final List<RingToneModel> ringtones;

  const RingToneWidget({Key? key, required this.ringtones}) : super(key: key);

  @override
  State<RingToneWidget> createState() => _RingToneWidgetState();
}

class _RingToneWidgetState extends State<RingToneWidget> {
  final FlutterSoundPlayer? mPlayer = FlutterSoundPlayer();

  @override
  void initState() {
    mPlayer!.openPlayer();
    super.initState();
  }

  @override
  void dispose() {
    mPlayer!.closePlayer();
    mPlayer!.stopPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String oldPlayerPath = AppConstants.emptyVal;
    return StatefulBuilder(
      builder: (context, ringState) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20, vertical: AppPadding.p15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.sound).tr(),
            Column(
              children: List.generate(
                widget.ringtones.length,
                (index) {
                  var ringTone = widget.ringtones[index];
                  return Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          if (ringTone.path == oldPlayerPath) {
                            if (mPlayer!.isPlaying) {
                              mPlayer!.pausePlayer();
                            } else if (mPlayer!.isStopped) {
                              var url =
                                  await HelperFunctions.getAssetRingToneData(
                                ringTone.path,
                              );
                              mPlayer!.startPlayer(
                                fromDataBuffer: url,
                                codec: Codec.mp3,
                              );
                            } else {
                              mPlayer!.resumePlayer();
                            }
                          } else {
                            if (mPlayer!.isPlaying) {
                              mPlayer!.stopPlayer();
                            }
                            var url =
                                await HelperFunctions.getAssetRingToneData(
                                    ringTone.path);
                            mPlayer!.startPlayer(
                              fromDataBuffer: url,
                              codec: Codec.mp3,
                            );
                            ringState(
                              () {
                                oldPlayerPath = ringTone.path;
                                for (var element in widget.ringtones) {
                                  if (element.title == ringTone.title) {
                                    element.selected = true;
                                  } else {
                                    element.selected = false;
                                  }
                                }
                              },
                            );
                            sl<AppShared>().setVal(
                              AppConstants.ringToneKey,
                              ringTone.path,
                            );
                            sl<AwesomeNotifications>().setChannel(
                              NotificationChannel(
                                channelKey: 'basic_channel',
                                channelName: 'Basic Notifications',
                                channelDescription:
                                    'Notification channel for Basic',
                                defaultColor: ColorManager.primary,
                                importance: NotificationImportance.High,
                                soundSource:
                                    'resource://raw/${ringTone.path.split('/').last.replaceAll(".mp3", "")}',
                                channelShowBadge: true,
                                locked: true,
                              ),
                              forceUpdate: true,
                            );
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: AppSize.s8,
                        leading: ringTone.selected
                            ? Icon(
                                Icons.check,
                                color: ColorManager.primary,
                              )
                            : const Padding(
                                padding: EdgeInsets.zero,
                              ),
                        title: Text(ringTone.title),
                      ),
                      Visibility(
                        visible: index !=
                            widget.ringtones.length -
                                AppConstants.oneVal.toInt(),
                        child: const Divider(
                          height: AppSize.s1,
                          indent: AppSize.s50,
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
