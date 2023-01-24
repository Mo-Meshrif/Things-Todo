import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launch_review/launch_review.dart';
import '../../../../../app/common/models/ring_tone_model.dart';
import '../../../../../app/common/models/setting_item_model.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/helper/shared_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../widgets/custom_about_widget.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_ringtone_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<SettingItemModel> settings = [
    SettingItemModel(
      icon: 'assets/icons/translation.png',
      title: 'Language',
      settingType: SettingType.lang,
    ),
    SettingItemModel(
      icon: 'assets/icons/sound.png',
      title: 'Sound',
      settingType: SettingType.sound,
    ),
    SettingItemModel(
      icon: 'assets/icons/helping.png',
      title: 'Help',
      settingType: SettingType.help,
    ),
    SettingItemModel(
      icon: 'assets/icons/review.png',
      title: 'Rate',
      settingType: SettingType.rate,
    ),
    SettingItemModel(
      icon: 'assets/icons/info.png',
      title: 'About',
      settingType: SettingType.about,
    ),
  ];
  List<RingToneModel> ringtones = [
    RingToneModel(
      title: 'Alarm clock',
      path: 'assets/sound/alarm_clock.mp3',
      selected: true,
    ),
    RingToneModel(
      title: 'Simple alarm',
      path: 'assets/sound/simple_alarm.mp3',
      selected: false,
    ),
    RingToneModel(
      title: 'Warning',
      path: 'assets/sound/warning.mp3',
      selected: false,
    ),
    RingToneModel(
      title: 'Army trumpet',
      path: 'assets/sound/army_trumpet.mp3',
      selected: false,
    ),
  ];

  @override
  void initState() {
    updateRingtones();
    super.initState();
  }

  updateRingtones() {
    String url = sl<AppShared>().getVal(AppConstants.ringToneKey) ?? '';
    int index = ringtones.indexWhere((element) => element.path == url);
    if (index > -1) {
      setState(() {
        for (var i = 0; i < ringtones.length; i++) {
          if (index == i) {
            ringtones[i].selected = true;
          } else {
            ringtones[i].selected = false;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.settings,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p10,
          vertical: AppPadding.p15,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppConstants.settingAxisCount,
          mainAxisExtent: AppSize.s185,
          mainAxisSpacing: AppSize.s1,
        ),
        itemCount: settings.length,
        itemBuilder: (context, i) {
          SettingType type = settings[i].settingType;
          return GestureDetector(
            onTap: () {
              if (type == SettingType.lang) {
                setState(() => HelperFunctions.toggleLanguage(context));
              } else if (type == SettingType.sound) {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.s30.r),
                      topRight: Radius.circular(AppSize.s30.r),
                    ),
                  ),
                  builder: (context) => RingToneWidget(ringtones: ringtones),
                );
              } else if (type == SettingType.help) {
                NavigationHelper.pushNamed(context, Routes.helpRoute);
              } else if (type == SettingType.rate) {
                LaunchReview.launch(
                  androidAppId: AppConstants.androidAppId,
                  iOSAppId: AppConstants.iOSAppId,
                );
              } else {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.s30.r),
                      topRight: Radius.circular(AppSize.s30.r),
                    ),
                  ),
                  builder: (context) => const CustomAboutWidget(),
                );
              }
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    settings[i].icon,
                    height: AppSize.s48,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    settings[i].title,
                  ).tr(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
