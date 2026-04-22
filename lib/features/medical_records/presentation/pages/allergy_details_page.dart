import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/allergy_details_model.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';

class AllergyDetailsPage extends StatelessWidget {
  final int allergyId;

  const AllergyDetailsPage({super.key, required this.allergyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicalRecordsBloc.create()
            ..add(GetAllergyDetailsEvent(id: allergyId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Allergy Details', style: AppTextStyles.heading3()),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
          builder: (context, state) {
            // Loading
            if (state.allergyDetailsStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            // Error
            if (state.allergyDetailsStatus == RequestStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.allergyDetailsError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicalRecordsBloc>().add(
                          GetAllergyDetailsEvent(id: allergyId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Success
            final details = state.allergyDetails;
            if (details == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== Header Card ====================
                  _buildHeaderCard(details),
                  const SizedBox(height: 20),

                  // ==================== Details Section ====================
                  _buildSectionTitle('ALLERGY INFORMATION'),
                  const SizedBox(height: 12),
                  _buildInfoCard(details),
                  const SizedBox(height: 20),

                  // ==================== Notes Section ====================
                  if (details.notes.isNotEmpty) ...[
                    _buildSectionTitle('NOTES'),
                    const SizedBox(height: 12),
                    _buildNotesCard(details.notes),
                  ],

                  // ==================== Timeline Section ====================
                  const SizedBox(height: 20),
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
  Widget _buildHeaderCard(AllergyDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getTypeColor(details.allergenType),
            _getTypeColor(details.allergenType).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getTypeColor(details.allergenType).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Type
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(details.allergenType),
                  size: 24,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(width: 12),
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
                  details.allergenType,
                  style: AppTextStyles.caption(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(details.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  details.status,
                  style: AppTextStyles.caption(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Allergen Name
          Text(
            details.allergenName,
            style: AppTextStyles.heading2(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Severity
          Row(
            children: [
              const Icon(Icons.speed, size: 16, color: AppColors.whiteColor),
              const SizedBox(width: 6),
              Text(
                'Severity: ${details.severity}',
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
  Widget _buildInfoCard(AllergyDetailsModel details) {
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
            icon: Icons.category,
            label: 'Allergen Type',
            value: details.allergenType,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.label_outline,
            label: 'Allergen Name',
            value: details.allergenName,
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.speed,
            label: 'Severity',
            value: details.severity,
            valueColor: _getSeverityColor(details.severity),
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Onset Date',
            value: DateFormat('MMMM dd, yyyy').format(details.onSetDate),
          ),
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.info_outline,
            label: 'Status',
            value: details.status,
            valueColor: _getStatusColor(details.status),
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
    return Divider(color: AppColors.borderColor, height: 1);
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
  Widget _buildTimelineCard(AllergyDetailsModel details) {
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
            label: 'Onset Date',
            date: details.onSetDate,
            icon: Icons.flag_outlined,
            color: Colors.orange,
            isFirst: true,
          ),
          _buildTimelineItem(
            label: 'Created',
            date: details.createAt,
            icon: Icons.add_circle_outline,
            color: AppColors.primaryColor,
          ),
          _buildTimelineItem(
            label: 'Last Updated',
            date: details.updateAt,
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
          // Timeline Line + Dot
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
          // Content
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
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'medication':
        return AppColors.redColor;
      case 'environmental':
        return Colors.green;
      case 'insect':
        return Colors.purple;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'medication':
        return Icons.medication;
      case 'environmental':
        return Icons.eco;
      case 'insect':
        return Icons.bug_report;
      default:
        return Icons.warning_amber;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
        return AppColors.redColor;
      case 'moderate':
        return Colors.orange;
      case 'mild':
        return Colors.green;
      default:
        return AppColors.greyColor;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.redColor;
      case 'inactive':
        return Colors.green;
      case 'resolved':
        return AppColors.primaryColor;
      default:
        return AppColors.greyColor;
    }
  }
}
