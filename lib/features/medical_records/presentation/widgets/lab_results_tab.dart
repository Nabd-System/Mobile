import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';
import 'package:nabd/features/medical_records/presentation/pages/lab_result_details_page.dart';
import 'package:nabd/features/medical_records/presentation/widgets/lab_result_card.dart';
import 'package:nabd/features/medical_records/presentation/widgets/empty_records_widget.dart';

class LabResultsTab extends StatefulWidget {
  const LabResultsTab({super.key});

  @override
  State<LabResultsTab> createState() => _LabResultsTabState();
}

class _LabResultsTabState extends State<LabResultsTab> {
  @override
  void initState() {
    super.initState();
    _loadLabResults();
  }

  void _loadLabResults() {
    context.read<MedicalRecordsBloc>().add(GetLabResultsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
      builder: (context, state) {
        // Loading
        if (state.labResultsStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        // Error
        if (state.labResultsStatus == RequestStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.labResultsError),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadLabResults,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (state.labResults.isEmpty) {
          return const EmptyRecordsWidget(
            title: 'No Lab Results',
            subtitle: 'Your lab results will appear here',
            icon: Icons.science_outlined, message: '',
          );
        }

        // Success
        return RefreshIndicator(
          onRefresh: () async => _loadLabResults(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: state.labResults.length,
            itemBuilder: (context, index) {
              final labResult = state.labResults[index];
              return LabResultCard(
                labResult: labResult,
                onTap: () {
                  pushTo(
                    context,
                    LabResultDetailsPage(labResultId: labResult.id),
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