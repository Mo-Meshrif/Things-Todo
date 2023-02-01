import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateMaterialAlert extends StatelessWidget {
  final String title;
  final String description;
  final String appLink;
  final bool forceUpdate;
  final String updateButtonLabel;
  final String closeButtonLabel;
  final String ignoreButtonLabel;

  const UpdateMaterialAlert({
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
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: _content(context),
        ),
      );

  Widget _content(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: screenHeight / 8,
          width: screenWidth / 1.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            color: Colors.indigo,
          ),
          child: const Center(
            child: Icon(
              Icons.error_outline_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        Container(
          height: screenHeight / 3,
          width: screenWidth / 1.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            child: Text(
                              description,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                forceUpdate ? exit(0) : Navigator.pop(context),
                            child: Container(
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.indigo,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  forceUpdate
                                      ? closeButtonLabel
                                      : ignoreButtonLabel,
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await launchUrl(Uri.parse(appLink));
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.indigo,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.indigo,
                                    blurRadius: 10,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  updateButtonLabel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
