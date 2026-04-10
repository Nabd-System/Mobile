import 'package:flutter/material.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/features/auth/presentation/pages/login_screen.dart';
import 'package:nabd/features/onboarding/data/models/onboarding_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToLogin() async {
    await AppLocalStorage.cacheData(AppLocalStorage.onboardingSeen, true);
    if (!mounted) return;
    pushAndRemoveUntil(context, const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ==================== Page View ====================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemCount: OnboardingModel.items.length,
                itemBuilder: (context, index) {
                  final item = OnboardingModel.items[index];
                  return Column(
                    children: [
                      // Image with gradient
                      Expanded(
                        flex: 3,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(item.image, fit: BoxFit.cover),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: screenHeight * 0.15,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.whiteColor,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Text content
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTextStyles.heading2(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.description,
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ==================== Indicator ====================
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: OnboardingModel.items.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColors.primaryColor,
                  dotColor: AppColors.borderColor,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 6,
                ),
              ),
            ),

            // ==================== Buttons ====================
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
              child: _pageIndex != OnboardingModel.items.length - 1
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            bgColor: AppColors.whiteColor,
                            textColor: AppColors.darkColor,
                            height: 48,
                            onPressed: _goToLogin,
                            text: 'Skip',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            height: 48,
                            onPressed: () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            ),
                            text: 'Next',
                          ),
                        ),
                      ],
                    )
                  : CustomButton(
                      height: 48,
                      onPressed: _goToLogin,
                      text: 'Get Started !',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
