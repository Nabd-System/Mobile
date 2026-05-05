import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/radiology_details_model.dart';
import 'package:nabd/features/medical_records/data/models/radiology_image_model.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';

class RadiologyDetailsPage extends StatelessWidget {
  final int radiologyId;

  const RadiologyDetailsPage({super.key, required this.radiologyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicalRecordsBloc.create()
            ..add(GetRadiologyDetailsEvent(id: radiologyId)),
      child: _RadiologyDetailsView(radiologyId: radiologyId),
    );
  }
}

class _RadiologyDetailsView extends StatelessWidget {
  final int radiologyId;

  const _RadiologyDetailsView({required this.radiologyId});

  // ==================== Color & Icon by Type ====================
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'x-ray':
        return Colors.blue.shade600;
      case 'ct':
        return Colors.purple.shade600;
      case 'mri':
        return Colors.indigo.shade600;
      case 'ultrasound':
        return Colors.teal.shade600;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'x-ray':
        return Icons.monitor_heart_outlined;
      case 'ct':
        return Icons.rotate_90_degrees_ccw_outlined;
      case 'mri':
        return Icons.psychology_outlined;
      case 'ultrasound':
        return Icons.waves_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radiology Report', style: AppTextStyles.heading3()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          // ==================== Export Listener ====================
          BlocListener<MedicalRecordsBloc, MedicalRecordsState>(
            listenWhen: (previous, current) =>
                previous.exportRadiologyStatus != current.exportRadiologyStatus,
            listener: (context, state) {
              if (state.exportRadiologyStatus == RequestStatus.success &&
                  state.exportRadiologyFilePath.isNotEmpty) {
                OpenFilex.open(state.exportRadiologyFilePath);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('PDF downloaded successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state.exportRadiologyStatus == RequestStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.exportRadiologyError),
                    backgroundColor: AppColors.redColor,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
          buildWhen: (previous, current) =>
              previous.radiologyDetailsStatus !=
                  current.radiologyDetailsStatus ||
              previous.radiologyDetails != current.radiologyDetails ||
              previous.exportRadiologyStatus != current.exportRadiologyStatus,
          builder: (context, state) {
            // ==================== Loading ====================
            if (state.radiologyDetailsStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            // ==================== Error ====================
            if (state.radiologyDetailsStatus == RequestStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.radiologyDetailsError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicalRecordsBloc>().add(
                          GetRadiologyDetailsEvent(id: radiologyId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // ==================== Success ====================
            final details = state.radiologyDetails;
            if (details == null) return const SizedBox.shrink();

            final color = _getTypeColor(details.reportType);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================== Header Card ====================
                        _buildHeaderCard(details, color),
                        const SizedBox(height: 20),

                        // ==================== Patient Info ====================
                        _buildSectionTitle('PATIENT INFORMATION'),
                        const SizedBox(height: 12),
                        _buildPatientInfoCard(details),
                        const SizedBox(height: 20),

                        // ==================== Findings ====================
                        _buildSectionTitle('FINDINGS'),
                        const SizedBox(height: 12),
                        _buildFindingsCard(details),
                        const SizedBox(height: 20),

                        // ==================== Recommendations ====================
                        if (details.recommendationsEn.isNotEmpty ||
                            details.recommendationsAr.isNotEmpty) ...[
                          _buildSectionTitle('RECOMMENDATIONS'),
                          const SizedBox(height: 12),
                          _buildRecommendationsCard(details),
                          const SizedBox(height: 20),
                        ],

                        // ==================== Scoring ====================
                        if (details.hasScoring) ...[
                          _buildSectionTitle('SCORING CATEGORIES'),
                          const SizedBox(height: 12),
                          _buildScoringCard(details),
                          const SizedBox(height: 20),
                        ],

                        // ==================== Differential Diagnosis ====================
                        if (details.differentialDiagnosis.isNotEmpty) ...[
                          _buildSectionTitle('DIFFERENTIAL DIAGNOSIS'),
                          const SizedBox(height: 12),
                          _buildSimpleCard(
                            icon: Icons.biotech_outlined,
                            color: Colors.orange,
                            content: details.differentialDiagnosis,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ==================== Images ====================
                        if (details.images.isNotEmpty) ...[
                          _buildSectionTitle(
                            'IMAGES (${details.images.length})',
                          ),
                          const SizedBox(height: 12),
                          _buildImagesCard(details.images),
                          const SizedBox(height: 20),
                        ],

                        // ==================== Radiologist ====================
                        _buildSectionTitle('RADIOLOGIST'),
                        const SizedBox(height: 12),
                        _buildRadiologistCard(details),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                // ==================== Download Button ====================
                _buildDownloadButton(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==================== Header Card ====================
  Widget _buildHeaderCard(RadiologyDetailsModel details, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Type + Status
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getTypeIcon(details.reportType),
                  size: 20,
                  color: AppColors.whiteColor,
                ),
              ),
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
                  details.reportType,
                  style: AppTextStyles.caption(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
                  details.reportStatus,
                  style: AppTextStyles.caption(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Report Number
          Text(
            details.reportNumber,
            style: AppTextStyles.heading3(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // ICD Codes
          if (details.icdCodes.isNotEmpty) ...[
            Row(
              children: [
                const Icon(
                  Icons.code_outlined,
                  size: 12,
                  color: AppColors.whiteColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'ICD: ${details.icdCodes}',
                  style: AppTextStyles.caption(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 12,
                color: AppColors.whiteColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  DateFormat('MMMM dd, yyyy').format(details.reportDate),
                  style: AppTextStyles.caption(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
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
        Flexible(
          child: Text(
            title,
            style: AppTextStyles.bodySmall(
              color: AppColors.greyColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== Patient Info Card ====================
  Widget _buildPatientInfoCard(RadiologyDetailsModel details) {
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
            label: 'Patient Name',
            value: details.patientFullName,
          ),
          const Divider(color: AppColors.borderColor, height: 1),
          _buildInfoRow(
            icon: Icons.folder_outlined,
            label: 'File Number',
            value: details.fileNumber,
          ),
          if (details.phone != null && details.phone!.isNotEmpty) ...[
            const Divider(color: AppColors.borderColor, height: 1),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: details.phone!,
            ),
          ],
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
          Icon(icon, size: 18, color: AppColors.primaryColor),
          const SizedBox(width: 10),
          Text(label, style: AppTextStyles.caption(color: AppColors.greyColor)),
          const Spacer(),
          Flexible(
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Findings Card ====================
  Widget _buildFindingsCard(RadiologyDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // English
          Row(
            children: [
              const Icon(
                Icons.language,
                size: 16,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'English',
                style: AppTextStyles.caption(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            details.findingsEn.isEmpty ? 'N/A' : details.findingsEn,
            style: AppTextStyles.bodySmall(color: AppColors.darkColor),
          ),

          if (details.findingsAr.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(color: AppColors.borderColor, height: 1),
            const SizedBox(height: 14),

            // Arabic
            Row(
              children: [
                const Icon(
                  Icons.translate,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Arabic',
                  style: AppTextStyles.caption(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              details.findingsAr,
              style: AppTextStyles.bodySmall(color: AppColors.darkColor),
              textAlign: TextAlign.right,
            ),
          ],
        ],
      ),
    );
  }

  // ==================== Recommendations Card ====================
  Widget _buildRecommendationsCard(RadiologyDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.recommendationsEn.isNotEmpty) ...[
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  'English',
                  style: AppTextStyles.caption(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              details.recommendationsEn,
              style: AppTextStyles.bodySmall(color: AppColors.darkColor),
            ),
          ],

          if (details.recommendationsEn.isNotEmpty &&
              details.recommendationsAr.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(color: AppColors.borderColor, height: 1),
            const SizedBox(height: 14),
          ],

          if (details.recommendationsAr.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.translate, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Arabic',
                  style: AppTextStyles.caption(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              details.findingsAr,
              style: AppTextStyles.bodySmall(color: AppColors.darkColor),
              textAlign: TextAlign.right,
            ),
          ],
        ],
      ),
    );
  }

  // ==================== Scoring Card ====================
  Widget _buildScoringCard(RadiologyDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: details.scoringFields.map((field) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field['label']!,
                  style: AppTextStyles.caption(
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  field['value']!,
                  style: AppTextStyles.bodySmall(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==================== Simple Card ====================
  Widget _buildSimpleCard({
    required IconData icon,
    required Color color,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              content,
              style: AppTextStyles.bodySmall(color: AppColors.darkColor),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Images Card ====================
  Widget _buildImagesCard(List<RadiologyImageModel> images) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: images.asMap().entries.map((entry) {
          final index = entry.key;
          final image = entry.value;
          final isLast = index == images.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        size: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Image #${image.imageNumber}',
                            style: AppTextStyles.bodySmall(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (image.notes.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              image.notes,
                              style: AppTextStyles.caption(
                                color: AppColors.greyColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd').format(image.acquisitionDate),
                      style: AppTextStyles.caption(color: AppColors.greyColor),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  color: AppColors.borderColor,
                  height: 1,
                  indent: 14,
                  endIndent: 14,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ==================== Radiologist Card ====================
  Widget _buildRadiologistCard(RadiologyDetailsModel details) {
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
            icon: Icons.person_pin_outlined,
            label: 'Radiologist',
            value: details.radiologistName,
          ),
          const Divider(color: AppColors.borderColor, height: 1),
          _buildInfoRow(
            icon: Icons.check_circle_outline,
            label: 'Finalized Date',
            value: DateFormat('MMM dd, yyyy').format(details.finalizedDate),
          ),
          const Divider(color: AppColors.borderColor, height: 1),
          _buildInfoRow(
            icon: Icons.verified_outlined,
            label: 'Verified Date',
            value: DateFormat('MMM dd, yyyy').format(details.verifiedDate),
          ),
          if (details.amendmentReason != null &&
              details.amendmentReason!.isNotEmpty) ...[
            const Divider(color: AppColors.borderColor, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.edit_note_outlined,
                    size: 18,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Amendment',
                    style: AppTextStyles.caption(color: AppColors.greyColor),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      details.amendmentReason!,
                      style: AppTextStyles.bodySmall(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.end,
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

  // ==================== Download Button ====================
  Widget _buildDownloadButton(BuildContext context, MedicalRecordsState state) {
    final isLoading = state.exportRadiologyStatus == RequestStatus.loading;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
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
                    ExportRadiologyEvent(id: radiologyId),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            disabledBackgroundColor: Colors.indigo.withValues(alpha: 0.5),
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
            isLoading ? 'Downloading...' : 'Download Radiology Report PDF',
            style: AppTextStyles.button(color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
