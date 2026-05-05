import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/core/widgets/custom_text_field.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_state.dart';
import 'package:nabd/features/auth/presentation/pages/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          pushAndRemoveUntil(context, const LoginScreen());
        } else if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.redColor,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== Icon ====================
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==================== Title ====================
                  Text('Reset Password', style: AppTextStyles.heading2()),
                  const SizedBox(height: 8),
                  Text(
                    'Your new password must be different from your previous password',
                    style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
                  ),
                  const SizedBox(height: 32),

                  // ==================== New Password ====================
                  CustomTextField(
                    controller: _newPasswordController,
                    label: 'New Password',
                    hintText: 'Enter new password',
                    obscureText: _obscureNewPassword,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.greyColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.greyColor,
                      ),
                      onPressed: () => setState(
                        () => _obscureNewPassword = !_obscureNewPassword,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ==================== Confirm Password ====================
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'Re-enter new password',
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.greyColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.greyColor,
                      ),
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // ==================== Submit Button ====================
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (prev, curr) =>
                        curr is ResetPasswordLoading ||
                        curr is ResetPasswordSuccess ||
                        curr is ResetPasswordFailure,
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Reset Password',
                        isLoading: state is ResetPasswordLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              ResetPasswordRequested(
                                email: widget.email,
                                otp: widget.otp,
                                newPassword: _newPasswordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
