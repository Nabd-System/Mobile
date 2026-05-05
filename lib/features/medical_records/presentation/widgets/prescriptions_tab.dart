import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';
import 'package:nabd/features/medical_records/presentation/pages/prescription_details_page.dart';
import 'package:nabd/features/medical_records/presentation/widgets/prescription_card.dart';
import 'package:nabd/features/medical_records/presentation/widgets/empty_records_widget.dart';

class PrescriptionsTab extends StatefulWidget {
  const PrescriptionsTab({super.key});

  @override
  State<PrescriptionsTab> createState() => _PrescriptionsTabState();
}

class _PrescriptionsTabState extends State<PrescriptionsTab> {
  @override
  void initState() {
    super.initState();
    _loadPrescriptions();
  }

  void _loadPrescriptions() {
    context.read<MedicalRecordsBloc>().add(GetPrescriptionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
      builder: (context, state) {
        // Loading
        if (state.prescriptionsStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        // Error
        if (state.prescriptionsStatus == RequestStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.prescriptionsError),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadPrescriptions,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty
        if (state.prescriptions.isEmpty) {
          return const EmptyRecordsWidget(
            title: 'No Prescriptions',
            subtitle: 'Your prescriptions will appear here',
            icon: Icons.medication_outlined, message: '',
          );
        }

        // Success
        return RefreshIndicator(
          onRefresh: () async => _loadPrescriptions(),
          color: AppColors.primaryColor,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: state.prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = state.prescriptions[index];
              return PrescriptionCard(
                prescription: prescription,
                onTap: () {
                  pushTo(
                    context,
                    PrescriptionDetailsPage(
                      prescriptionId: prescription.prescriptionId,
                    ),
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