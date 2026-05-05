import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';
import 'package:nabd/features/medical_records/presentation/pages/radiology_details_page.dart';
import 'package:nabd/features/medical_records/presentation/widgets/empty_records_widget.dart';
import 'package:nabd/features/medical_records/presentation/widgets/radiology_card.dart';

class RadiologyTab extends StatefulWidget {
  const RadiologyTab({super.key});

  @override
  State<RadiologyTab> createState() => _RadiologyTabState();
}

class _RadiologyTabState extends State<RadiologyTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MedicalRecordsBloc>();
    if (bloc.state.radiologyStatus == RequestStatus.initial) {
      bloc.add(GetRadiologyEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
      buildWhen: (previous, current) =>
          previous.radiologyStatus != current.radiologyStatus ||
          previous.radiology != current.radiology,
      builder: (context, state) {
        // ==================== Loading ====================
        if (state.radiologyStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        // ==================== Error ====================
        if (state.radiologyStatus == RequestStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.redColor.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 12),
                Text(
                  state.radiologyError,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.greyColor),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<MedicalRecordsBloc>().add(GetRadiologyEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // ==================== Empty ====================
        if (state.radiologyStatus == RequestStatus.success &&
            state.radiology.isEmpty) {
          return const EmptyRecordsWidget(
            icon: Icons.image_outlined,
            message: 'No radiology reports found', title: '', subtitle: '',
          );
        }

        // ==================== Success ====================
        return RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            context.read<MedicalRecordsBloc>().add(GetRadiologyEvent());
          },
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: state.radiology.length,
            itemBuilder: (context, index) {
              final report = state.radiology[index];
              return RadiologyCard(
                radiology: report,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RadiologyDetailsPage(
                        radiologyId: report.reportId,
                      ),
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