import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launch_review/launch_review.dart';

import '../../../modules/auth/domain/entities/user.dart';
import '../../../modules/auth/presentation/controller/auth_bloc.dart';
import '../../../modules/help/presentation/widgets/help_widget.dart';
import '../../helper/enums.dart';
import '../../helper/helper_functions.dart';
import '../../helper/navigation_helper.dart';
import '../../helper/shared_helper.dart';
import '../../services/services_locator.dart';
import '../../utils/constants_manager.dart';
import '../../utils/strings_manager.dart';
import '../../utils/values_manager.dart';
import '../config/config_bloc.dart';
import '../models/alert_action_model.dart';
import '../models/config_model.dart';
import '../models/ring_tone_model.dart';
import '../models/setting_item_model.dart';
import '../widgets/custom_about_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_ringtone_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AuthUser auhtUser = HelperFunctions.getSavedUser();
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
      icon: 'assets/icons/delete-user.png',
      title: 'Delete Account',
      settingType: SettingType.detete,
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
    ConfigModel config = context.read<ConfigBloc>().config;
    bool isEmail = HelperFunctions.getSignType(auhtUser) == SignType.email;
    List<SettingItemModel> tempSettings = isEmail && config.showDeletion
        ? settings
        : settings
            .where((element) => element.settingType != SettingType.detete)
            .toList();
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
        itemCount: tempSettings.length,
        itemBuilder: (context, i) {
          SettingType type = tempSettings[i].settingType;
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
                if (auhtUser.isLocal) {
                  HelperFunctions.sendMail(
                    context: context,
                    mail: 'm.meshrif77@gmail.com',
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
                    builder: (context) => const HelpWidget(),
                  );
                }
              } else if (type == SettingType.rate) {
                LaunchReview.launch(
                  androidAppId: AppConstants.androidAppId,
                  iOSAppId: AppConstants.iOSAppId,
                );
              } else if (type == SettingType.detete) {
                String passVal = AppConstants.emptyVal;
                HelperFunctions.showAlert(
                  context: context,
                  title: tempSettings[i].title.tr(),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(AppStrings.deleteAccount).tr(),
                        const SizedBox(height: 5),
                        Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            obscureText: true,
                            autofocus: true,
                            onChanged: (value) => passVal = value,
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    AlertActionModel(
                      title: AppStrings.cancel.tr(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    AlertActionModel(
                      title: AppStrings.delete.tr(),
                      onPressed: () {
                        if (passVal.isEmpty) {
                          HelperFunctions.showSnackBar(
                            context,
                            AppStrings.enterPassword.tr(),
                          );
                        } else {
                          if (HelperFunctions.checkPassword(
                            passVal,
                            auhtUser.password!,
                          )) {
                            BlocProvider.of<AuthBloc>(context).add(
                              DeleteEvent(
                                user: auhtUser.copyWith(password: passVal),
                              ),
                            );
                            NavigationHelper.pop(context);
                          } else {
                            HelperFunctions.showSnackBar(
                              context,
                              AppStrings.deleteWrongPass.tr(),
                            );
                          }
                        }
                      },
                    ),
                  ],
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
                    tempSettings[i].icon,
                    height: AppSize.s48,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tempSettings[i].title,
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
