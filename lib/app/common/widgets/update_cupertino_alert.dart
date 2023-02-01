import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/color_manager.dart';

class UpdateCupertinoAlert extends StatelessWidget {
  final String title;
  final String description;
  final String appLink;
  final bool forceUpdate;
  final String updateButtonLabel;
  final String closeButtonLabel;
  final String ignoreButtonLabel;

  const UpdateCupertinoAlert({
    Key? key,
    required this.title,
    required this.description,
    required this.appLink,
    this.forceUpdate = false,
    required this.updateButtonLabel,
    required this.closeButtonLabel,
    required this.ignoreButtonLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      color: ColorManager.primary,
    );
    /// Set up the Buttons
    Widget closeAppButton = CupertinoDialogAction(
      textStyle: style,
      child: Text(closeButtonLabel),
      onPressed: () => exit(0),
    );

    Widget ignoreButton = CupertinoDialogAction(
      textStyle: style,
      child: Text(ignoreButtonLabel),
      onPressed: () => Navigator.pop(context),
    );

    Widget updateButton = CupertinoDialogAction(
      textStyle: style,
      child: Text(updateButtonLabel),
      onPressed: () async {
        await launchUrl(Uri.parse(appLink));
        Navigator.pop(context);
      },
    );

    return CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          description,
        ),
      ),
      actions: [
        forceUpdate ? closeAppButton : ignoreButton,
        updateButton,
      ],
    );
  }
}
