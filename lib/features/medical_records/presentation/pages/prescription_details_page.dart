import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/prescription_details_model.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';

class PrescriptionDetailsPage extends StatelessWidget {
  final int prescriptionId;

  const PrescriptionDetailsPage({super.key, required this.prescriptionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicalRecordsBloc.create()
            ..add(GetPrescriptionDetailsEvent(id: prescriptionId)),
      child: _PrescriptionDetailsView(prescriptionId: prescriptionId),
    );
  }
}

class _PrescriptionDetailsView extends StatelessWidget {
  final int prescriptionId;

  const _PrescriptionDetailsView({required this.prescriptionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Details', style: AppTextStyles.heading3()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<MedicalRecordsBloc, MedicalRecordsState>(
        listener: (context, state) {
          // Export success
          if (state.exportStatus == RequestStatus.success &&
              state.exportFilePath.isNotEmpty) {
            OpenFilex.open(state.exportFilePath);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PDF downloaded successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Export error
          if (state.exportStatus == RequestStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.exportError),
                backgroundColor: AppColors.redColor,
              ),
            );
          }
        },
        builder: (context, state) {
          // Loading
          if (state.prescriptionDetailsStatus == RequestStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          // Error
          if (state.prescriptionDetailsStatus == RequestStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.prescriptionDetailsError),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MedicalRecordsBloc>().add(
                        GetPrescriptionDetailsEvent(id: prescriptionId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Success
          final details = state.prescriptionDetails;
          if (details == null) return const SizedBox.shrink();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================== Doctor Card ====================
                      _buildDoctorCard(details),
                      const SizedBox(height: 20),

                      // ==================== Visit Info ====================
                      _buildSectionTitle('VISIT INFORMATION'),
                      const SizedBox(height: 12),
                      _buildVisitInfoCard(details),
                      const SizedBox(height: 20),

                      // ==================== Medications ====================
                      _buildSectionTitle(
                        'MEDICATIONS (${details.items.length})',
                      ),
                      const SizedBox(height: 12),
                      ...details.items.map(
                        (item) => _buildMedicationCard(item),
                      ),

                      // ==================== Notes ====================
                      if (details.notes.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _buildSectionTitle('DOCTOR\'S NOTES'),
                        const SizedBox(height: 12),
                        _buildNotesCard(details.notes),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // ==================== Download PDF Button ====================
              _buildDownloadButton(context, state),
            ],
          );
        },
      ),
    );
  }

  // ==================== Doctor Card ====================
  Widget _buildDoctorCard(PrescriptionDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          // Doctor Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _getInitials(details.doctorName),
                style: AppTextStyles.bodyLarge(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${details.doctorName}',
                  style: AppTextStyles.bodyMedium(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMMM dd, yyyy').format(details.visitDate),
                  style: AppTextStyles.caption(color: AppColors.greyColor),
                ),
              ],
            ),
          ),
          // Prescription ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '#${details.prescriptionId}',
              style: AppTextStyles.caption(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
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

  // ==================== Visit Info Card ====================
  Widget _buildVisitInfoCard(PrescriptionDetailsModel details) {
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
            icon: Icons.person_outline,
            label: 'Patient',
            value: details.patientFullName,
          ),
          const Divider(color: AppColors.borderColor, height: 1),
          _buildInfoRow(
            icon: Icons.folder_outlined,
            label: 'File Number',
            value: details.fileNumber,
          ),
          const Divider(color: AppColors.borderColor, height: 1),
          _buildInfoRow(
            icon: Icons.tag,
            label: 'Visit Number',
            value: details.visitNumber,
          ),
          const Divider(color: AppColors.borderColor, height: 1),
          _buildInfoRow(
            icon: Icons.report_outlined,
            label: 'Chief Complaint',
            value: details.chiefComplaint,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
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
          Flexible(
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Medication Card ====================
  Widget _buildMedicationCard(PrescriptionItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medication Name + Dosage
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medication,
                  size: 18,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.medicationName,
                      style: AppTextStyles.bodyMedium(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item.dosage,
                      style: AppTextStyles.caption(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Duration
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Text(
                  item.duration,
                  style: AppTextStyles.caption(
                    color: AppColors.darkGreyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 10),

          // Details Row
          Row(
            children: [
              _buildMedDetail(Icons.schedule, item.frequency),
              const SizedBox(width: 16),
              _buildMedDetail(Icons.info_outline, item.instructions),
            ],
          ),

          // Notes
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.notes, size: 14, color: Colors.amber.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.notes!,
                      style: AppTextStyles.caption(
                        color: AppColors.darkGreyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedDetail(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.greyColor),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.caption(color: AppColors.darkGreyColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  // ==================== Download Button ====================
  Widget _buildDownloadButton(BuildContext context, MedicalRecordsState state) {
    final isLoading = state.exportStatus == RequestStatus.loading;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          onPressed: isLoading
              ? null
              : () {
                  context.read<MedicalRecordsBloc>().add(
                    ExportPrescriptionEvent(prescriptionId: prescriptionId),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            disabledBackgroundColor: Colors.green.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.whiteColor,
                  ),
                )
              : const Icon(Icons.download, color: AppColors.whiteColor),
          label: Text(
            isLoading ? 'Downloading...' : 'Download Prescription PDF',
            style: AppTextStyles.button(color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }

  // ==================== Helpers ====================
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
