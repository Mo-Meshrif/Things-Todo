import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/values_manager.dart';

class CustomTextFormField extends StatelessWidget {
  final String iconName;
  final String hintText;
  final bool isPassword;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    Key? key,
    required this.iconName,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isPassword = false,
    required this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPassObscure = true;
    Widget icon = const Icon(Icons.visibility_off);
    return Row(
      children: [
        const SizedBox(width: AppSize.s10),
        SvgPicture.asset(
          iconName,
          width: AppSize.s20,
        ),
        StatefulBuilder(
            builder: (context, innerState) => Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          obscureText: isPassword ? isPassObscure : false,
                          validator: validator,
                          textInputAction: textInputAction,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: hintText,
                            errorMaxLines: AppConstants.errorMaxLines,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isPassword,
                        child: IconButton(
                          splashRadius: AppSize.s20,
                          onPressed: () => innerState(
                            () {
                              isPassObscure = !isPassObscure;
                              if (isPassObscure) {
                                icon = const Icon(Icons.visibility_off);
                              } else {
                                icon = const Icon(Icons.visibility);
                              }
                            },
                          ),
                          icon: icon,
                        ),
                      ),
                    ],
                  ),
                )),
      ],
    );
  }
}
