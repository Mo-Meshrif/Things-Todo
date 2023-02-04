import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../domain/entities/chat_message.dart';
import 'custom_bubble_widget.dart';

class MessageWidget extends StatelessWidget {
  final String uid;
  final List<ChatMessage> messages;
  final bool loading;
  final Future<void> Function(
    String? message,
    MessageType messageType,
  ) sendMessage;
  final Function(ChatMessage message) updateMessage;
  const MessageWidget({
    Key? key,
    required this.messages,
    required this.sendMessage,
    required this.uid,
    required this.updateMessage,
    required this.loading,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String message = AppConstants.emptyVal;
    bool hideChatBox = false;
    TextEditingController textEditingController = TextEditingController();
    return StatefulBuilder(
      builder: (context, innerState) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Expanded(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      padding: const EdgeInsets.only(
                        bottom: AppPadding.p10,
                        top: AppPadding.p5,
                      ),
                      itemBuilder: (context, index) {
                        bool user = uid == messages[index].idFrom;
                        return MessageBubble(
                          isMe: user,
                          chatMessage: messages[index],
                        );
                      },
                    ),
            ),
            Card(
              elevation: AppSize.s20,
              margin: EdgeInsets.zero,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
                  child: Row(
                    children: [
                      const SizedBox(width: AppSize.s10),
                      Visibility(
                        visible: !hideChatBox,
                        child: Expanded(
                          child: TextFormField(
                            controller: textEditingController,
                            onChanged: (value) => innerState(
                              () => message = value,
                            ),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: AppStrings.typeMessage.tr(),
                              hintStyle: TextStyle(color: ColorManager.kBlack),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20),
                                borderSide: BorderSide(
                                  color: ColorManager.kGrey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20),
                                borderSide: BorderSide(
                                  color: ColorManager.kGrey,
                                ),
                              ),
                              suffixIcon: Visibility(
                                visible: message.isEmpty,
                                child: GestureDetector(
                                  onTap: () async {
                                    final configs = ImagePickerConfigs();
                                    configs.translateFunc = (name, value) {
                                      if (name == 'app_title') {
                                        return AppConstants.appName;
                                      } else {
                                        return name.tr();
                                      }
                                    };
                                    final List<ImageObject>? objects =
                                        await NavigationHelper.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, __) =>
                                            ImagePicker(
                                          maxCount: AppSize.s5.toInt(),
                                          configs: configs,
                                        ),
                                      ),
                                    );
                                    if (objects != null) {
                                      if (objects.isNotEmpty) {
                                        var imgPathList = objects
                                            .map((e) => e.modifiedPath)
                                            .toList();
                                        sendMessage(
                                          imgPathList.join(','),
                                          MessageType.pic,
                                        );
                                      }
                                    }
                                  },
                                  child: Icon(
                                    Icons.attach_file,
                                    color: ColorManager.kGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            sendMessage(message, MessageType.text).then(
                          (_) => textEditingController.clear(),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p10,
                          ),
                          height: AppSize.s45,
                          width: AppSize.s45,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorManager.primary,
                          ),
                          child: Icon(
                            Icons.send,
                            color: ColorManager.kWhite,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
