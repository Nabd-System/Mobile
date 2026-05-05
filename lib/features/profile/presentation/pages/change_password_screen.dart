import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/core/widgets/custom_text_field.dart';
import 'package:nabd/features/profile/presentation/bloc/profile_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is ChangePasswordFailure) {
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
          title: const Text('Change Password'),
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
                  Text('Change Password', style: AppTextStyles.heading2()),
                  const SizedBox(height: 8),
                  Text(
                    'Your new password must be different from your previous password',
                    style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
                  ),
                  const SizedBox(height: 32),

                  // ==================== Old Password ====================
                  CustomTextField(
                    controller: _oldPasswordController,
                    label: 'Current Password',
                    hintText: 'Enter your current password',
                    obscureText: _obscureOldPassword,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.greyColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureOldPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.greyColor,
                      ),
                      onPressed: () => setState(
                        () => _obscureOldPassword = !_obscureOldPassword,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ==================== New Password ====================
                  CustomTextField(
                    controller: _newPasswordController,
                    label: 'New Password',
                    hintText: 'Enter your new password',
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
                      if (value == _oldPasswordController.text) {
                        return 'New password must be different from current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ==================== Confirm Password ====================
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm New Password',
                    hintText: 'Re-enter your new password',
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
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // ==================== Submit Button ====================
                  BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (prev, curr) =>
                        curr is ChangePasswordLoading ||
                        curr is ChangePasswordSuccess ||
                        curr is ChangePasswordFailure,
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Update Password',
                        isLoading: state is ChangePasswordLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileBloc>().add(
                              ChangePasswordEvent(
                                oldPassword: _oldPasswordController.text,
                                newPassword: _newPasswordController.text,
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
