import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../auth/presentation/widgets/custom_or_divider.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/usecases/send_problem_use_case.dart';
import '../../controller/home_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/customMessage/custom_message_widget.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String uid = HelperFunctions.getSavedUser().id;
  bool textFieldEnable = true;
  List<ChatMessage> messages = [];
  TextEditingController problemController = TextEditingController();
  @override
  void initState() {
    problemController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.help,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            vertical: AppPadding.p30, horizontal: AppPadding.p20),
        child: Column(
          children: [
            Center(
              child: Image.asset(IconAssets.helpDesk),
            ),
            const SizedBox(
              height: AppSize.s30,
            ),
            BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is ProblemLoading) {
                  textFieldEnable = false;
                } else if (state is ProblemLoaded) {
                  textFieldEnable = true;
                  problemController.clear();
                  HelperFunctions.showSnackBar(
                    context,
                    AppStrings.problemScussfully.tr(),
                  );
                } else if (state is ProblemFailure) {
                  textFieldEnable = true;
                  HelperFunctions.showSnackBar(
                    context,
                    AppStrings.operationFailed.tr(),
                  );
                }
              },
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                return Column(
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      child: TextFormField(
                        maxLines: 8,
                        enabled: textFieldEnable,
                        controller: problemController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: AppStrings.problemDetails.tr(),
                          contentPadding: const EdgeInsets.all(AppPadding.p10),
                          hintStyle: const TextStyle(color: Colors.black),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: problemController.text.isNotEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p20),
                        child: state is ProblemLoading
                            ? CircularProgressIndicator(
                                color: ColorManager.primary,
                              )
                            : ListTile(
                                onTap: () => homeBloc.add(
                                  SendProblemEvent(
                                    ProblemInput(
                                      id: UniqueKey().hashCode,
                                      from: uid,
                                      problem: problemController.text,
                                    ),
                                  ),
                                ),
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(color: Colors.grey),
                                ),
                                title: const Text(AppStrings.sendProblem).tr(),
                                trailing: const Icon(Icons.send),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppPadding.p20),
              child: CustomOrDivider(),
            ),
            ListTile(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                builder: (context) {
                  homeBloc.add(const GetChatListEvent());
                  return SizedBox(
                    height: ScreenUtil().screenHeight * 0.75,
                    child: BlocConsumer<HomeBloc, HomeState>(
                      listener: (context, state) {
                        if (state is ChatLoaded) {
                          messages = state.messages;
                        }
                      },
                      builder: (context, state) => MessageWidget(
                        uid: uid,
                        messages: messages,
                        sendMessage: (message) async => homeBloc.add(
                          SendMessageEvent(
                            ChatMessage(
                              uid: uid,
                              idFrom: uid,
                              idTo: 'admin',
                              timestamp: Timestamp.now().toString(),
                              content: message,
                              type: MessageType.text,
                              isMark: true,
                            ),
                          ),
                        ),
                        sendRecord: (recordPath) {
                          if (recordPath != null) {
                            homeBloc.add(
                              SendMessageEvent(
                                ChatMessage(
                                  uid: uid,
                                  idFrom: uid,
                                  idTo: 'admin',
                                  timestamp: Timestamp.now().toString(),
                                  content: recordPath,
                                  type: MessageType.voice,
                                  isMark: true,
                                ),
                              ),
                            );
                          }
                        },
                        updateMessage: (message) => homeBloc.add(
                          UpdateMessageEvent(message),
                        ),
                      ),
                    ),
                  );
                },
              ),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s5),
                side: const BorderSide(color: Colors.grey),
              ),
              title: const Text(AppStrings.chat).tr(),
              trailing: const Icon(Icons.arrow_upward),
            )
          ],
        ),
      ),
    );
  }
}
