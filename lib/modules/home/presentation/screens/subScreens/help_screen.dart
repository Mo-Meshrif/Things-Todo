import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../auth/presentation/widgets/custom_or_divider.dart';
import '../../../domain/usecases/send_problem_use_case.dart';
import '../../controller/home_bloc.dart';
import '../../widgets/custom_app_bar.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String uid = HelperFunctions.getSavedUser().id;
  bool textFieldEnable = true;
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
                                onTap: () =>
                                    BlocProvider.of<HomeBloc>(context).add(
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
              onTap: () => Navigator.of(context).pushNamed(Routes.chatRoute),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s5),
                side: const BorderSide(color: Colors.grey),
              ),
              title: const Text(AppStrings.chat).tr(),
              trailing: const Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
