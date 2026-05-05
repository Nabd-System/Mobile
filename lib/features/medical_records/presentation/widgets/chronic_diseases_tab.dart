import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';
import 'package:nabd/features/medical_records/presentation/pages/chronic_disease_details_page.dart';
import 'package:nabd/features/medical_records/presentation/widgets/chronic_disease_card.dart';
import 'package:nabd/features/medical_records/presentation/widgets/empty_records_widget.dart';

class ChronicDiseasesTab extends StatefulWidget {
  const ChronicDiseasesTab({super.key});

  @override
  State<ChronicDiseasesTab> createState() => _ChronicDiseasesTabState();
}

class _ChronicDiseasesTabState extends State<ChronicDiseasesTab> {
  @override
  void initState() {
    super.initState();
    _loadChronicDiseases();
  }

  void _loadChronicDiseases() {
    context.read<MedicalRecordsBloc>().add(GetChronicDiseasesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
      builder: (context, state) {
        // Loading
        if (state.chronicDiseasesStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        // Error
        if (state.chronicDiseasesStatus == RequestStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.chronicDiseasesError),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadChronicDiseases,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (state.chronicDiseases.isEmpty) {
          return const EmptyRecordsWidget(
            title: 'No Chronic Diseases',
            subtitle: 'Your chronic disease records will appear here',
            icon: Icons.monitor_heart_outlined, message: '',
          );
        }

        // Success
        return RefreshIndicator(
          onRefresh: () async => _loadChronicDiseases(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: state.chronicDiseases.length,
            itemBuilder: (context, index) {
              final disease = state.chronicDiseases[index];
              return ChronicDiseaseCard(
                disease: disease,
                onTap: () {
                  pushTo(
                    context,
                    ChronicDiseaseDetailsPage(diseaseId: disease.id),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}