import 'package:flutter/material.dart';
import 'package:nabd/core/functions/navigation.dart';
import 'package:nabd/core/utils/colors.dart';
import 'package:nabd/core/utils/text_styles.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/features/auth/presentation/page/login_screen.dart';
import 'package:nabd/features/intro/onboarding/model/onboarding_model.dart';

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
                        Image.asset(onboardingList[index].image),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.white, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      onboardingList[index].title,
                      style: getFont20TextStyle(
                        color: AppColors.darkColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      onboardingList[index].description,
                      style: getFont20TextStyle(
                        color: AppColors.darkColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            children: [
              if (pageIndex != onboardingList.length - 1) ...[
                CustomButton(
                  onPressed: () => pushTo(context, const LoginScreen()),
                  text: 'Skip',
                ),
                Spacer(),
                CustomButton(
                  onPressed: () => pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.bounceIn,
                  ),
                  text: 'Next',
                ),
              ] else ...[
                CustomButton(
                  onPressed: () => pushTo(context, const LoginScreen()),
                  text: 'Get Started !',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
