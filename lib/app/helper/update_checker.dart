import 'dart:io';
import 'package:flutter/material.dart';
import 'package:store_version_checker/store_version_checker.dart';
import '../common/widgets/update_material_alert.dart';
import '../common/widgets/update_cupertino_alert.dart';

class UpdateChecker {
  /// Displaying update alert
  static displayUpdateAlert(
    BuildContext context, {
    required bool forceUpdate,
    required String description,
    String updateButtonLabel = 'Update',
    String closeButtonLabel = 'Exit',
    String ignoreButtonLabel = 'Later',
    String title = 'Update',
    Function? onOpenAlert,
    Function? onExitAlert,
  }) async {
    StoreCheckerResult result = await StoreVersionChecker().checkUpdate();
    if (result.canUpdate) {
      if (onOpenAlert != null) {
        onOpenAlert();
      }
      /// Show the alert based on current platform
      if (Platform.isIOS) {
        _showCupertinoAlertDialog(
          context,
          forceUpdate: forceUpdate,
          appLink: result.appURL!,
          description: description,
          updateButtonLabel: updateButtonLabel,
          closeButtonLabel: closeButtonLabel,
          ignoreButtonLabel: ignoreButtonLabel,
          title: title,
          onExitAlert: onExitAlert,
        );
      } else {
        _showMaterialAlertDialog(
          context,
          forceUpdate: forceUpdate,
          appLink: result.appURL!,
          description: description,
          updateButtonLabel: updateButtonLabel,
          closeButtonLabel: closeButtonLabel,
          ignoreButtonLabel: ignoreButtonLabel,
          title: title,
          onExitAlert: onExitAlert,
        );
      }
    }
  }

  static _showCupertinoAlertDialog(
    BuildContext context, {
    required bool forceUpdate,
    required String appLink,
    required String description,
    required String updateButtonLabel,
    required String closeButtonLabel,
    required String ignoreButtonLabel,
    required String title,
    Function? onExitAlert,
  }) async {
    Widget alert = UpdateCupertinoAlert(
      forceUpdate: forceUpdate,
      title: title,
      appLink: appLink,
      description: description,
      updateButtonLabel: updateButtonLabel,
      closeButtonLabel: closeButtonLabel,
      ignoreButtonLabel: ignoreButtonLabel,
    );
    showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (BuildContext context) {
        return alert;
      },
    ).whenComplete(() {
      if (onExitAlert != null) {
        onExitAlert();
      }
    });
  }

  static _showMaterialAlertDialog(
    BuildContext context, {
    required bool forceUpdate,
    required String appLink,
    required String description,
    required String updateButtonLabel,
    required String closeButtonLabel,
    required String ignoreButtonLabel,
    required String title,
    Function? onExitAlert,
  }) {
    Widget alert = UpdateMaterialAlert(
      forceUpdate: forceUpdate,
      title: title,
      appLink: appLink,
      description: description,
      updateButtonLabel: updateButtonLabel,
      closeButtonLabel: closeButtonLabel,
      ignoreButtonLabel: ignoreButtonLabel,
    );
    showDialog(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (BuildContext context) {
        return alert;
      },
    ).whenComplete(() {
      if (onExitAlert != null) {
        onExitAlert();
      }
    });
  }
}
