import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/chronic_disease_details_model.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';

class ChronicDiseaseDetailsPage extends StatelessWidget {
  final int diseaseId;

  const ChronicDiseaseDetailsPage({super.key, required this.diseaseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicalRecordsBloc.create()
            ..add(GetChronicDiseaseDetailsEvent(id: diseaseId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Disease Details', style: AppTextStyles.heading3()),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
          builder: (context, state) {
            // Loading
            if (state.chronicDiseaseDetailsStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            // Error
            if (state.chronicDiseaseDetailsStatus == RequestStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.chronicDiseaseDetailsError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicalRecordsBloc>().add(
                          GetChronicDiseaseDetailsEvent(id: diseaseId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Success
            final details = state.chronicDiseaseDetails;
            if (details == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== Header Card ====================
                  _buildHeaderCard(details),
                  const SizedBox(height: 20),

                  // ==================== Disease Info ====================
                  _buildSectionTitle('DISEASE INFORMATION'),
                  const SizedBox(height: 12),
                  _buildInfoCard(details),
                  const SizedBox(height: 20),

                  // ==================== Medications ====================
                  if (details.medications.isNotEmpty) ...[
                    _buildSectionTitle('MEDICATIONS'),
                    const SizedBox(height: 12),
                    _buildMedicationsCard(details.medications),
                    const SizedBox(height: 20),
                  ],

                  // ==================== Notes ====================
                  if (details.notes.isNotEmpty) ...[
                    _buildSectionTitle('NOTES'),
                    const SizedBox(height: 12),
                    _buildNotesCard(details.notes),
                    const SizedBox(height: 20),
                  ],

                  // ==================== Timeline ====================
                  _buildSectionTitle('TIMELINE'),
                  const SizedBox(height: 12),
                  _buildTimelineCard(details),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==================== Header Card ====================
  Widget _buildHeaderCard(ChronicDiseaseDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(details.currentStatus),
            _getStatusColor(details.currentStatus).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(
              details.currentStatus,
            ).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Code + Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.monitor_heart,
                  size: 24,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(width: 12),
              // Disease Code
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  details.diseaseCode,
                  style: AppTextStyles.caption(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              // Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      details.currentStatus,
                      style: AppTextStyles.caption(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Disease Name
          Text(
            details.diseaseName,
            style: AppTextStyles.heading2(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Diagnosis Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.whiteColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Diagnosed: ${DateFormat('MMMM dd, yyyy').format(details.diagnosisDate)}',
                style: AppTextStyles.bodySmall(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== Section Title ====================
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.bodySmall(
            color: AppColors.greyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==================== Info Card ====================
  Widget _buildInfoCard(ChronicDiseaseDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.local_hospital,
            label: 'Disease Name',
            value: details.diseaseName,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.code,
            label: 'Disease Code',
            value: details.diseaseCode,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.info_outline,
            label: 'Current Status',
            value: details.currentStatus,
            valueColor: _getStatusColor(details.currentStatus),
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Diagnosis Date',
            value: DateFormat('MMMM dd, yyyy').format(details.diagnosisDate),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall(color: AppColors.greyColor),
            ),
          ),
          if (valueColor != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: valueColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                value,
                style: AppTextStyles.bodySmall(
                  color: valueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Flexible(
              child: Text(
                value,
                style: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
                textAlign: TextAlign.end,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: AppColors.borderColor, height: 1);
  }

  // ==================== Medications Card ====================
  Widget _buildMedicationsCard(String medications) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medication,
              size: 20,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Medications',
                  style: AppTextStyles.caption(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  medications,
                  style: AppTextStyles.bodySmall(color: AppColors.darkColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Notes Card ====================
  Widget _buildNotesCard(String notes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notes, size: 20, color: Colors.amber.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              notes,
              style: AppTextStyles.bodySmall(color: AppColors.darkColor),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Timeline Card ====================
  Widget _buildTimelineCard(ChronicDiseaseDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _buildTimelineItem(
            label: 'Diagnosis Date',
            date: details.diagnosisDate,
            icon: Icons.flag_outlined,
            color: Colors.orange,
            isFirst: true,
          ),
          _buildTimelineItem(
            label: 'Record Created',
            date: details.createAt,
            icon: Icons.add_circle_outline,
            color: AppColors.primaryColor,
          ),
          _buildTimelineItem(
            label: 'Last Updated',
            date: details.lastUpdatedAt,
            icon: Icons.update,
            color: Colors.green,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String label,
    required DateTime date,
    required IconData icon,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(width: 2, color: AppColors.borderColor),
                  ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: AppColors.borderColor),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMMM dd, yyyy').format(date),
                    style: AppTextStyles.bodySmall(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Helpers ====================
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.redColor;
      case 'controlled':
        return Colors.green;
      case 'resolved':
        return AppColors.primaryColor;
      case 'in remission':
        return Colors.orange;
      default:
        return AppColors.greyColor;
    }
  }
}
