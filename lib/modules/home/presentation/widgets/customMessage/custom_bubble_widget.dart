import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final bool fromUser;
  final ChatMessage chatMessage;
  final Function() onPlayVoice;

  const MessageBubble({
    Key? key,
    required this.fromUser,
    required this.chatMessage,
    required this.onPlayVoice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Column(
        crossAxisAlignment:
            fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          chatMessage.type == MessageType.text
              ? Material(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(50),
                    bottomLeft: fromUser
                        ? const Radius.circular(50)
                        : const Radius.circular(0),
                    bottomRight: fromUser
                        ? const Radius.circular(0)
                        : const Radius.circular(50),
                    topRight: const Radius.circular(50),
                  ),
                  color:
                      fromUser ? ColorManager.primary : ColorManager.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      chatMessage.content,
                      style: TextStyle(
                        color: fromUser
                            ? ColorManager.kWhite
                            : ColorManager.kBlack,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              : chatMessage.type == MessageType.voice
                  ? Builder(
                      builder: (context) => chatMessage.isLoading
                          ? const Padding(padding: EdgeInsets.zero)
                          : VoiceMessage(
                              audioSrc: chatMessage.content,
                              played: !chatMessage.isMark,
                              me: fromUser,
                              meBgColor: ColorManager.primary,
                              contactBgColor: ColorManager.background,
                              onPlay: onPlayVoice,
                            ),
                    )
                  : SizedBox(
                      width: ScreenUtil().screenWidth * 0.7,
                      child: Wrap(
                        alignment:
                            fromUser ? WrapAlignment.end : WrapAlignment.start,
                        spacing: 2,
                        runSpacing: 2,
                        children: chatMessage.content
                            .split(',')
                            .map(
                              (imgUrl) => Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: fromUser
                                      ? ColorManager.primary
                                      : ColorManager.background,
                                ),
                                child: chatMessage.isLoading
                                    ? BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 2.0, sigmaY: 2.0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ColorManager.kBlack
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: imgUrl,
                                        height: 100,
                                        width: 100,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (_, __) => Lottie.asset(
                                          JsonAssets.loadingDots,
                                        ),
                                      ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
        ],
      ),
    );
  }
}
