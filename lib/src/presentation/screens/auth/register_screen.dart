// lib/src/presentation/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
    }
  }

  void _onLoginTap() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.createAccount,
        showBackButton: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.showSuccessSnackBar(AppStrings.successRegisterMessage);
            // Navigator.of(context).pushAndRemoveUntil(
            //   MaterialPageRoute(builder: (_) => const HomeScreen()),
            //   (route) => false,
            // ); //todo : our focus is on api first spring boot...
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
                      context.padding.bottom -
                      ResponsiveHelper.getAppBarHeight(context),
                ),
                child: Padding(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Registration Form Card
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Full Name Field
                              CustomTextField(
                                controller: _fullNameController,
                                labelText: AppStrings.fullName,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return AppStrings.errorFullNameRequired;
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: AppDimensions.spaceM),

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
                                textInputAction: TextInputAction.next,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
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

                              const SizedBox(height: AppDimensions.spaceM),

                              // Confirm Password Field
                              CustomTextField(
                                controller: _confirmPasswordController,
                                labelText: AppStrings.confirmPassword,
                                obscureText: !_isConfirmPasswordVisible,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _onRegister(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return AppStrings.errorPasswordRequired;
                                  }
                                  if (value != _passwordController.text) {
                                    return AppStrings.errorPasswordsDontMatch;
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: AppDimensions.spaceXL),

                              // Register Button
                              if (state is AuthLoading)
                                const LoadingWidget()
                              else
                                CustomButton(
                                  text: AppStrings.register,
                                  onPressed: _onRegister,
                                  width: double.infinity,
                                ),

                              const SizedBox(height: AppDimensions.spaceL),

                              // Login Link
                              TextButton(
                                onPressed: _onLoginTap,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: AppTextStyles.bodyMedium,
                                    children: [
                                      const TextSpan(
                                        text:
                                            '${AppStrings.alreadyHaveAccount} ',
                                      ),
                                      TextSpan(
                                        text: AppStrings.logIn,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w500,
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
