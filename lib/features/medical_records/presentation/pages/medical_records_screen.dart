import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/widgets/allergies_tab.dart';
import 'package:nabd/features/medical_records/presentation/widgets/chronic_diseases_tab.dart';
import 'package:nabd/features/medical_records/presentation/widgets/medical_history_tab.dart';
import 'package:nabd/features/medical_records/presentation/widgets/visits_tab.dart';
import 'package:nabd/features/medical_records/presentation/widgets/empty_records_widget.dart';
import 'package:nabd/features/medical_records/presentation/widgets/prescriptions_tab.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_TabItem> _tabs = [
    _TabItem(title: 'Visits', icon: Icons.event_note_outlined),
    _TabItem(title: 'Lab Results', icon: Icons.science_outlined),
    _TabItem(title: 'Radiology', icon: Icons.radio_button_checked),
    _TabItem(title: 'Prescriptions', icon: Icons.medication_outlined),
    _TabItem(title: 'Medical History', icon: Icons.history),
    _TabItem(title: 'Allergies', icon: Icons.warning_amber_outlined),
    _TabItem(title: 'Chronic Diseases', icon: Icons.monitor_heart_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicalRecordsBloc.create(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Medical Records', style: AppTextStyles.heading3()),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: _buildTabBar(),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                // 1. Visits ✅
                const VisitsTab(),

                // 2. Lab Results (Mock)
                const EmptyRecordsWidget(
                  title: 'Lab Results',
                  subtitle: 'Coming Soon - Lab results will appear here',
                  icon: Icons.science_outlined,
                ),

                // 3. Radiology (Mock)
                const EmptyRecordsWidget(
                  title: 'Radiology',
                  subtitle: 'Coming Soon - Radiology reports will appear here',
                  icon: Icons.radio_button_checked,
                ),

                // 4. Prescriptions (Placeholder)
                const PrescriptionsTab(),

                // 5. Medical History (Placeholder)
                const MedicalHistoryTab(),

                // 6. Allergies (Placeholder)
                const AllergiesTab(),

                // 7. Chronic Diseases (Placeholder)
                const ChronicDiseasesTab(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.greyColor,
        labelStyle: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.bodySmall(),
        indicatorColor: AppColors.primaryColor,
        indicatorWeight: 3,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: _tabs
            .map(
              (tab) => Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tab.icon, size: 18),
                    const SizedBox(width: 6),
                    Text(tab.title),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TabItem {
  final String title;
  final IconData icon;

  _TabItem({required this.title, required this.icon});
}
