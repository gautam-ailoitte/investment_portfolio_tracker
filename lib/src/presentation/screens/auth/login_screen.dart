// lib/src/presentation/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_widget.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _onSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.showSuccessSnackBar(AppStrings.successLoginMessage);
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(builder: (_) => const HomeScreen()),
            // ); //todo:
          } else if (state is AuthError) {
            context.showErrorSnackBar(state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight:
                      context.screenHeight -
                      context.padding.top -
                      context.padding.bottom,
                ),
                child: Padding(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo/Title
                      Container(
                        width: ResponsiveHelper.getMaxContentWidth(context),
                        padding: const EdgeInsets.all(AppDimensions.paddingXL),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusL,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadow,
                              offset: Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // App Title
                            Text(
                              AppStrings.appName,
                              style: AppTextStyles.h2,
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: AppDimensions.spaceXL),

                            // Login Form
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Email Field
                                  CustomTextField(
                                    controller: _emailController,
                                    labelText: AppStrings.email,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return AppStrings.errorEmailRequired;
                                      }
                                      if (!value!.isValidEmail) {
                                        return AppStrings.errorEmailInvalid;
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: AppDimensions.spaceM),

                                  // Password Field
                                  CustomTextField(
                                    controller: _passwordController,
                                    labelText: AppStrings.password,
                                    obscureText: !_isPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _onLogin(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.textSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return AppStrings.errorPasswordRequired;
                                      }
                                      if (value!.length < 6) {
                                        return AppStrings.errorPasswordTooShort;
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: AppDimensions.spaceXL),

                                  // Login Button
                                  if (state is AuthLoading)
                                    const LoadingWidget()
                                  else
                                    CustomButton(
                                      text: AppStrings.logIn,
                                      onPressed: _onLogin,
                                      width: double.infinity,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spaceXL),

                      // Sign Up Link
                      TextButton(
                        onPressed: _onSignUp,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyles.bodyMedium,
                            children: [
                              const TextSpan(text: AppStrings.dontHaveAccount),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
