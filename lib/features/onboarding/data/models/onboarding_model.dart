class OnboardingModel {
  final String title;
  final String description;
  final String image;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });

  static const List<OnboardingModel> items = [
    OnboardingModel(
      title: 'Welcome !',
      description:
          'This system allows you to book appointments, access medical records, and manage your healthcare services with ease. Let\'s get started!',
      image: 'assets/images/on1.png',
    ),
    OnboardingModel(
      title: 'Choose Specialization',
      description: 'Pick the specialty that best matches your health needs.',
      image: 'assets/images/on2.png',
    ),
    OnboardingModel(
      title: 'Schedule Your First Appointment',
      description:
          'Choose a suitable time and date to meet your preferred doctor.',
      image: 'assets/images/on3.png',
    ),
  ];
}
