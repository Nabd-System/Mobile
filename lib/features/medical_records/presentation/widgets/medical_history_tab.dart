import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';
import 'package:nabd/features/medical_records/presentation/pages/medical_history_details_page.dart';
import 'package:nabd/features/medical_records/presentation/widgets/medical_history_card.dart';
import 'package:nabd/features/medical_records/presentation/widgets/empty_records_widget.dart';

class MedicalHistoryTab extends StatefulWidget {
  const MedicalHistoryTab({super.key});

  @override
  State<MedicalHistoryTab> createState() => _MedicalHistoryTabState();
}

class _MedicalHistoryTabState extends State<MedicalHistoryTab> {
  @override
  void initState() {
    super.initState();
    _loadMedicalHistory();
  }

  void _loadMedicalHistory() {
    context.read<MedicalRecordsBloc>().add(GetMedicalHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
      builder: (context, state) {
        // Loading
        if (state.medicalHistoryStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        // Error
        if (state.medicalHistoryStatus == RequestStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.medicalHistoryError),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadMedicalHistory,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (state.medicalHistory.isEmpty) {
          return const EmptyRecordsWidget(
            title: 'No Medical History',
            subtitle: 'Your medical history will appear here',
            icon: Icons.history, message: '',
          );
        }

        // Success
        return RefreshIndicator(
          onRefresh: () async => _loadMedicalHistory(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: state.medicalHistory.length,
            itemBuilder: (context, index) {
              final history = state.medicalHistory[index];
              return MedicalHistoryCard(
                history: history,
                onTap: () {
                  pushTo(
                    context,
                    MedicalHistoryDetailsPage(historyId: history.id),
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