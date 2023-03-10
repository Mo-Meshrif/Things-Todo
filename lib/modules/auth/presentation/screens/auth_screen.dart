import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/services/services_locator.dart';
import '/app/utils/assets_manager.dart';
import '/app/utils/constants_manager.dart';
import '/modules/auth/domain/usecases/login_use_case.dart';
import '/modules/auth/domain/usecases/signup_use_case.dart';
import '/modules/auth/presentation/controller/auth_bloc.dart';
import '../../../../app/common/config/config_bloc.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/helper/navigation_helper.dart';
import '../../../../app/helper/shared_helper.dart';
import '../../../../app/services/notification_services.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../components/auth_inputs.dart';
import '../components/forget_password.dart';
import '../components/login_button.dart';
import '../components/social_login.dart';
import '../components/toggle_auth.dart';
import '../widgets/custom_or_divider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogin = true;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _forgetPassController = TextEditingController();
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (ctx, state) {
          if (state is AuthPopUpLoading) {
            HelperFunctions.showPopUpLoading(context);
          } else if (state is AuthSuccess) {
            sl<AppShared>().setVal(AppConstants.authPassKey, true);
            sl<AppShared>().setVal(AppConstants.userKey, state.user);
            sl<FirebaseMessaging>().subscribeToTopic(AppConstants.toUser);
            sl<NotificationServices>()
                .scheduledNotificationsAgain(state.user.id);
            NavigationHelper.pushReplacementNamed(context, Routes.homeRoute);
            _emailController.clear();
            _passwordController.clear();
          } else if (state is AuthRestSuccess) {
            NavigationHelper.pop(context);
            _forgetPassController.clear();
            HelperFunctions.showSnackBar(
              context,
              AppStrings.checkEmail.tr(),
            );
          } else if (state is AuthFailure) {
            if (state.isPopup) {
              NavigationHelper.pop(context);
            }
            if (state.msg.isNotEmpty) {
              HelperFunctions.showSnackBar(context, state.msg.tr());
            }
          } else if (state is AuthSocialPass) {
            ctx.read<AuthBloc>().add(
                  SignInWithCredentialEvent(
                    authCredential: state.authCredential,
                  ),
                );
          } else if (state is AuthChanged) {
            isLogin = state.currentState;
          }
        },
        builder: (context, state) => SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 144.w),
              child: Column(
                children: [
                  SizedBox(height: AppSize.s170.h),
                  Center(
                    child: SvgPicture.asset(
                      ImageAssets.logo,
                      height: AppSize.s189.h,
                      width: AppSize.s295.w,
                    ),
                  ),
                  SizedBox(height: AppSize.s120.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AuthInputs(
                        isLogin: isLogin,
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                      Visibility(
                        visible: isLogin,
                        child: ForgetPassword(
                          forgetPassController: _forgetPassController,
                          restFun: () => context.read<AuthBloc>().add(
                                ForgetPasswordEvent(
                                  email: _forgetPassController.text,
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s36.h),
                  AuthButton(
                    isLoading: state is AuthLoading,
                    isLogin: isLogin,
                    authKey: _formKey,
                    inputsCheck: () {
                      if (HelperFunctions.isEmailValid(
                          _emailController.text)) {
                        if (_passwordController.text.length >= 8) {
                          return true;
                        } else {
                          HelperFunctions.showSnackBar(
                            context,
                            AppStrings.notVaildPassword.tr(),
                          );
                          return false;
                        }
                      } else {
                        HelperFunctions.showSnackBar(
                          context,
                          AppStrings.notVaildEmail.tr(),
                        );
                        return false;
                      }
                    },
                    loginFun: () => context.read<AuthBloc>().add(
                          LoginEvent(
                            loginInputs: LoginInputs(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          ),
                        ),
                    signUpFun: () => context.read<AuthBloc>().add(
                          SignUpEvent(
                            signUpInputs: SignUpInputs(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          ),
                        ),
                  ),
                  BlocBuilder<ConfigBloc, ConfigState>(
                    builder: (context, state) => state is ConfigLoaded
                        ? Visibility(
                            visible: state.configModel.showSocial,
                            child: Column(
                              children: [
                                SizedBox(height: AppSize.s48.h),
                                const CustomOrDivider(),
                                Text(AppStrings.loginUsingSm.tr()),
                                SizedBox(height: AppSize.s48.h),
                                SocialLogin(
                                  facebookFun: () => context
                                      .read<AuthBloc>()
                                      .add(FacebookLoginEvent()),
                                  twitterFun: () => context
                                      .read<AuthBloc>()
                                      .add(TwitterLoginEvent()),
                                  googleFun: () => context
                                      .read<AuthBloc>()
                                      .add(GoogleLoginEvent()),
                                ),
                              ],
                            ),
                          )
                        : const Padding(padding: EdgeInsets.zero),
                  ),
                  SizedBox(height: AppSize.s48.h),
                  ToggleAuth(
                    isLogin: isLogin,
                    toggleFun: () {
                      if (_formKey.currentState != null) {
                        FocusScope.of(context).unfocus();
                        _formKey.currentState!.reset();
                      }
                      context.read<AuthBloc>().add(
                            AuthToggleEvent(prevState: isLogin),
                          );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
