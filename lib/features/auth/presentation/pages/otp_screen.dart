import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_state.dart';
import 'package:nabd/features/auth/presentation/pages/reset_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // 6 controllers + 6 focus nodes
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ==================== Get OTP ====================
  String get _otp => _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otp.length == 6;

  // ==================== Handle Input ====================
  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() {});
    }
  }

  // ==================== Resend Code ====================
  void _resendCode() {
    context.read<AuthBloc>().add(
      ForgotPasswordRequested(email: widget.email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Code resent successfully'),
              backgroundColor: Colors.green,
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
                    Icons.mark_email_read_outlined,
                    color: AppColors.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),

                // ==================== Title ====================
                Text('Check Your Email', style: AppTextStyles.heading2()),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.greyColor,
                    ),
                    children: [
                      const TextSpan(text: 'We sent a verification code to\n'),
                      TextSpan(
                        text: widget.email,
                        style: AppTextStyles.bodyMedium(
                          color: AppColors.darkColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ==================== OTP Fields ====================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => _OtpField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (value) => _onChanged(value, index),
                      onKeyEvent: (event) => _onKeyEvent(event, index),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ==================== Verify Button ====================
                CustomButton(
                  text: 'Verify Code',
                  onPressed: _isOtpComplete
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResetPasswordScreen(
                                email: widget.email,
                                otp: _otp,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
                const SizedBox(height: 24),

                // ==================== Resend ====================
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: AppTextStyles.bodySmall(
                          color: AppColors.greyColor,
                        ),
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        buildWhen: (prev, curr) =>
                            curr is ForgotPasswordLoading ||
                            curr is ForgotPasswordSuccess ||
                            curr is ForgotPasswordFailure,
                        builder: (context, state) {
                          if (state is ForgotPasswordLoading) {
                            return const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: _resendCode,
                            child: Text(
                              'Resend',
                              style: AppTextStyles.bodySmall(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== OTP Single Field Widget ====================
class _OtpField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;

  const _OtpField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: onKeyEvent,
      child: SizedBox(
        width: 48,
        height: 56,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: AppTextStyles.heading3(color: AppColors.primaryColor),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}