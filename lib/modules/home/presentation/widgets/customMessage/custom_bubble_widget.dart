import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p5,
      ),
      child: Column(
        crossAxisAlignment:
            fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          chatMessage.type == MessageType.text
              ? Material(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppSize.s50),
                    bottomLeft: fromUser
                        ? const Radius.circular(AppSize.s50)
                        : const Radius.circular(AppSize.s0),
                    bottomRight: fromUser
                        ? const Radius.circular(AppSize.s0)
                        : const Radius.circular(AppSize.s50),
                    topRight: const Radius.circular(AppSize.s50),
                  ),
                  color:
                      fromUser ? ColorManager.primary : ColorManager.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.p10,
                      horizontal: AppPadding.p20,
                    ),
                    child: Text(
                      chatMessage.content,
                      style: TextStyle(
                        color: fromUser
                            ? ColorManager.kWhite
                            : ColorManager.kBlack,
                        fontSize: AppSize.s15,
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
                      width: ScreenUtil().screenWidth * AppSize.s07,
                      child: Wrap(
                        alignment:
                            fromUser ? WrapAlignment.end : WrapAlignment.start,
                        spacing: AppSize.s2,
                        runSpacing: AppSize.s2,
                        children: chatMessage.content
                            .split(',')
                            .map(
                              (imgUrl) => Container(
                                padding: const EdgeInsets.all(AppPadding.p2),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s10),
                                  color: fromUser
                                      ? ColorManager.primary
                                      : ColorManager.background,
                                ),
                                child: chatMessage.isLoading
                                    ? BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: AppSize.s2,
                                          sigmaY: AppSize.s2,
                                        ),
                                        child: Container(
                                          height: AppSize.s100,
                                          width: AppSize.s100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              AppSize.s10,
                                            ),
                                            color: ColorManager.kBlack
                                                .withOpacity(AppSize.s03),
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: imgUrl,
                                        height: AppSize.s100,
                                        width: AppSize.s100,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              AppSize.s10,
                                            ),
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
