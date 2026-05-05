import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/utils/validators.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/core/widgets/custom_text_field.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_state.dart';
import 'package:nabd/features/auth/presentation/pages/otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                email: _emailController.text.trim(),
              ),
            ),
          );
        } else if (state is ForgotPasswordFailure) {
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
                      Icons.lock_reset_rounded,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==================== Title ====================
                  Text('Forgot Password?', style: AppTextStyles.heading2()),
                  const SizedBox(height: 8),
                  Text(
                    "Enter your email address and we'll send you a verification code",
                    style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
                  ),
                  const SizedBox(height: 32),

                  // ==================== Email Field ====================
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.greyColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!emailValidation(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // ==================== Send Button ====================
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (prev, curr) =>
                        curr is ForgotPasswordLoading ||
                        curr is ForgotPasswordSuccess ||
                        curr is ForgotPasswordFailure,
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Send Code',
                        isLoading: state is ForgotPasswordLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              ForgotPasswordRequested(
                                email: _emailController.text.trim(),
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