import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../domain/entities/chat_message.dart';
import 'custom_bubble_widget.dart';
import 'record_button.dart';

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
    String message = '';
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
                      padding: const EdgeInsets.only(bottom: 10, top: 5),
                      itemBuilder: (context, index) {
                        bool user = uid == messages[index].idFrom;
                        return MessageBubble(
                          fromUser: user,
                          chatMessage: messages[index],
                          onPlayVoice: () {
                            if (messages[index].isMark) {
                              innerState(
                                () => messages[index] =
                                    messages[index].copyBaseWith(
                                  isMark: false,
                                ),
                              );
                              updateMessage(messages[index]);
                            }
                          },
                        );
                      },
                    ),
            ),
            Card(
              elevation: 20,
              margin: EdgeInsets.zero,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
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
                              hintStyle: const TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              suffixIcon: Visibility(
                                visible: message.isEmpty,
                                child: GestureDetector(
                                  onTap: () async {
                                    final configs = ImagePickerConfigs();
                                    configs.translateFunc = (name, value) {
                                      if (name == 'app_title') {
                                        return AppStrings.appName;
                                      } else {
                                        return name.tr();
                                      }
                                    };
                                    final List<ImageObject>? objects =
                                        await Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, __) =>
                                            ImagePicker(
                                          maxCount: 5,
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
                      message.isNotEmpty
                          ? InkWell(
                              onTap: () =>
                                  sendMessage(message, MessageType.text).then(
                                (_) => textEditingController.clear(),
                              ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                height: 45,
                                width: 45,
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
                          : RecordButton(
                              sendRecord: (recordPath) =>
                                  sendMessage(recordPath, MessageType.voice),
                              getTapStatus: (tapStatus) => innerState(
                                () => hideChatBox = tapStatus,
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
