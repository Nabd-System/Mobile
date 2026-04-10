import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/features/auth/presentation/pages/login_screen.dart';
import 'package:nabd/features/onboarding/data/models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) => setState(() => pageIndex = index),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          onboardingList[index].image,
                          width: double.infinity,
                          height: 626,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: double.infinity,
                            height: 200,
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            onboardingList[index].title,
                            style: AppTextStyles.heading2(
                              color: AppColors.darkColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            onboardingList[index].description,
                            style: AppTextStyles.bodySmall(
                              color: AppColors.darkColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (pageIndex != onboardingList.length - 1) ...[
                  CustomButton(
                    bgColor: AppColors.whiteColor,
                    textColor: AppColors.darkColor,
                    width: 163.5,
                    height: 40,
                    onPressed: () async {
                      await AppLocalStorage.cacheData(
                        AppLocalStorage.onboardingSeen,
                        true,
                      );
                      if (!context.mounted) return;
                      pushTo(context, const LoginScreen());
                    },
                    text: 'Skip',
                  ),
                  CustomButton(
                    width: 163.5,
                    height: 40,
                    onPressed: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    ),
                    text: 'Next',
                  ),
                ] else ...[
                  CustomButton(
                    width: 343,
                    height: 40,
                    onPressed: () async {
                      await AppLocalStorage.cacheData(
                        AppLocalStorage.onboardingSeen,
                        true,
                      );
                      if (!context.mounted) return;
                      pushTo(context, const LoginScreen());
                    },
                    text: 'Get Started !',
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
