import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/visit_details_model.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';

class VisitDetailsPage extends StatelessWidget {
  final int visitId;

  const VisitDetailsPage({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicalRecordsBloc.create()
            ..add(GetVisitDetailsEvent(visitId: visitId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Visit Records', style: AppTextStyles.heading3()),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
          builder: (context, state) {
            // Loading
            if (state.visitDetailsStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            // Error
            if (state.visitDetailsStatus == RequestStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.visitDetailsError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicalRecordsBloc>().add(
                          GetVisitDetailsEvent(visitId: visitId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Success
            final details = state.visitDetails;
            if (details == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== Doctor Info Card ====================
                  _buildDoctorCard(details),
                  const SizedBox(height: 20),

                  // ==================== Visit Summary ====================
                  _buildSectionTitle('VISIT SUMMARY'),
                  const SizedBox(height: 12),
                  _buildSummaryItem(
                    icon: Icons.report_outlined,
                    label: 'CHIEF COMPLAINT',
                    value: details.chiefComplaint,
                  ),
                  _buildSummaryItem(
                    icon: Icons.assignment_outlined,
                    label: 'VISIT TYPE',
                    value: details.visitType,
                  ),
                  _buildSummaryItem(
                    icon: Icons.info_outline,
                    label: 'STATUS',
                    value: details.visitStatus,
                  ),

                  // ==================== Vital Signs ====================
                  if (details.vitalSigns.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('VITAL SIGNS'),
                    const SizedBox(height: 12),
                    _buildVitalSignsGrid(details.vitalSigns.first),
                  ],

                  // ==================== Diagnoses ====================
                  if (details.diagnoses.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('DIAGNOSES'),
                    const SizedBox(height: 12),
                    ...details.diagnoses.map(
                      (d) => _buildInfoChip(d.diagnosisName),
                    ),
                  ],

                  // ==================== Prescriptions ====================
                  if (details.prescriptions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('PRESCRIPTIONS'),
                    const SizedBox(height: 12),
                    ...details.prescriptions.map(
                      (p) => _buildPrescriptionCard(p),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==================== Doctor Card ====================
  Widget _buildDoctorCard(VisitDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      style: AppTextStyles.bodyLarge(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          details.visitStatus,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        details.visitStatus,
                        style: AppTextStyles.caption(
                          color: _getStatusColor(details.visitStatus),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: AppColors.greyColor,
              ),
              const SizedBox(width: 6),
              Text(
                DateFormat('MMMM dd, yyyy').format(details.visitDate),
                style: AppTextStyles.caption(),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.tag, size: 14, color: AppColors.greyColor),
              const SizedBox(width: 6),
              Text(details.visitNumber, style: AppTextStyles.caption()),
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

  // ==================== Summary Item ====================
  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? 'N/A' : value,
                  style: AppTextStyles.bodySmall(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Vital Signs Grid ====================
  Widget _buildVitalSignsGrid(VitalSignsModel vitals) {
    final items = [
      _VitalItem('Temperature', '${vitals.temperature}°C', Icons.thermostat),
      _VitalItem('Blood Pressure', vitals.bloodPressure, Icons.favorite),
      _VitalItem('Heart Rate', '${vitals.heartRate} bpm', Icons.monitor_heart),
      _VitalItem('O₂ Saturation', '${vitals.oxygenSaturation}%', Icons.air),
      _VitalItem('Weight', '${vitals.weight} kg', Icons.scale),
      _VitalItem('BMI', '${vitals.bmi}', Icons.accessibility_new),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.accentColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 22, color: AppColors.primaryColor),
              const SizedBox(height: 6),
              Text(
                item.value,
                style: AppTextStyles.bodySmall(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: AppTextStyles.caption(color: AppColors.greyColor),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== Info Chip ====================
  Widget _buildInfoChip(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 18,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall())),
        ],
      ),
    );
  }

  // ==================== Prescription Card ====================
  Widget _buildPrescriptionCard(VisitPrescriptionModel prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.medication,
                    size: 18,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Prescription #${prescription.prescriptionId}',
                    style: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(prescription.createdAt),
                style: AppTextStyles.caption(),
              ),
            ],
          ),
          if (prescription.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              prescription.notes,
              style: AppTextStyles.caption(color: AppColors.darkGreyColor),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return Colors.green;
      case 'cancelled':
        return AppColors.redColor;
      case 'open':
        return Colors.orange;
      default:
        return AppColors.primaryColor;
    }
  }
}

class _VitalItem {
  final String label;
  final String value;
  final IconData icon;

  _VitalItem(this.label, this.value, this.icon);
}
