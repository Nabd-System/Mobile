import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/lab_result_details_model.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_bloc.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_event.dart';
import 'package:nabd/features/medical_records/presentation/bloc/medical_records_state.dart';

class LabResultDetailsPage extends StatelessWidget {
  final int labResultId;

  const LabResultDetailsPage({super.key, required this.labResultId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicalRecordsBloc.create()
            ..add(GetLabResultDetailsEvent(id: labResultId)),
      child: _LabResultDetailsView(labResultId: labResultId),
    );
  }
}

class _LabResultDetailsView extends StatelessWidget {
  final int labResultId;

  const _LabResultDetailsView({required this.labResultId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab Result Details', style: AppTextStyles.heading3()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // ✅ استخدام MultiBlocListener عشان نفصل الـ listeners
      body: MultiBlocListener(
        listeners: [
          // ==================== Export PDF Listener ====================
          BlocListener<MedicalRecordsBloc, MedicalRecordsState>(
            listenWhen: (previous, current) =>
                previous.exportLabStatus != current.exportLabStatus,
            listener: (context, state) {
              if (state.exportLabStatus == RequestStatus.success &&
                  state.exportLabFilePath.isNotEmpty) {
                OpenFilex.open(state.exportLabFilePath);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('PDF downloaded successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state.exportLabStatus == RequestStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.exportLabError),
                    backgroundColor: AppColors.redColor,
                  ),
                );
              }
            },
          ),

          // ==================== AI Analysis Listener ====================
          BlocListener<MedicalRecordsBloc, MedicalRecordsState>(
            listenWhen: (previous, current) =>
                previous.labAnalysisStatus != current.labAnalysisStatus,
            listener: (context, state) {
              if (state.labAnalysisStatus == RequestStatus.success &&
                  state.labAnalysis != null) {
                _showAnalysisBottomSheet(context, state.labAnalysis!.summary);
              } else if (state.labAnalysisStatus == RequestStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.labAnalysisError),
                    backgroundColor: AppColors.redColor,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
          buildWhen: (previous, current) =>
              previous.labResultDetailsStatus !=
                  current.labResultDetailsStatus ||
              previous.labResultDetails != current.labResultDetails ||
              previous.exportLabStatus != current.exportLabStatus ||
              previous.labAnalysisStatus != current.labAnalysisStatus,
          builder: (context, state) {
            // Loading
            if (state.labResultDetailsStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            // Error
            if (state.labResultDetailsStatus == RequestStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.labResultDetailsError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedicalRecordsBloc>().add(
                          GetLabResultDetailsEvent(id: labResultId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Success
            final details = state.labResultDetails;
            if (details == null) return const SizedBox.shrink();

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================== Header Card ====================
                        _buildHeaderCard(details),
                        const SizedBox(height: 20),

                        // ==================== Patient Info ====================
                        _buildSectionTitle('PATIENT INFORMATION'),
                        const SizedBox(height: 12),
                        _buildPatientInfoCard(details),
                        const SizedBox(height: 20),

                        // ==================== Test Parameters ====================
                        _buildSectionTitle(
                          'TEST PARAMETERS (${details.params.length})',
                        ),
                        const SizedBox(height: 12),
                        ...details.params.map(
                          (param) => _buildParamCard(param),
                        ),
                        const SizedBox(height: 20),

                        // ==================== AI Analysis Button ====================
                        _buildAiAnalysisButton(context, state),

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
      ),
    );
  }

  // ==================== Header Card ====================
  Widget _buildHeaderCard(LabResultDetailsModel details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade600, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                child: const Icon(
                  Icons.biotech_outlined,
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
                  details.category,
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
                  color: _hasAbnormalResults(details)
                      ? AppColors.redColor.withValues(alpha: 0.3)
                      : Colors.green.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _hasAbnormalResults(details)
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      size: 12,
                      color: AppColors.whiteColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _hasAbnormalResults(details) ? 'Abnormal' : 'Normal',
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
          const SizedBox(height: 14),
          Text(
            details.testName,
            style: AppTextStyles.heading3(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
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
                  DateFormat(
                    'MMMM dd, yyyy – hh:mm a',
                  ).format(details.createdAt),
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
  Widget _buildPatientInfoCard(LabResultDetailsModel details) {
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
          const Divider(color: AppColors.borderColor, height: 1),
          _buildInfoRow(
            icon: Icons.category_outlined,
            label: 'Category',
            value: details.category,
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

  // ==================== Parameter Card ====================
  Widget _buildParamCard(LabParamModel param) {
    final bool isNormal = param.isNormal;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNormal
              ? AppColors.borderColor
              : AppColors.redColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isNormal
                      ? Colors.green.withValues(alpha: 0.1)
                      : AppColors.redColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isNormal
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_rounded,
                  size: 18,
                  color: isNormal ? Colors.green : AppColors.redColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      param.paramName,
                      style: AppTextStyles.bodySmall(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (param.abbreviation.isNotEmpty)
                      Text(
                        param.abbreviation,
                        style: AppTextStyles.caption(
                          color: AppColors.greyColor,
                        ),
                      ),
                  ],
                ),
              ),
              if (!isNormal && param.abnormalFlag.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getFlagColor(
                      param.abnormalFlag,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    param.abnormalFlag,
                    style: AppTextStyles.caption(
                      color: _getFlagColor(param.abnormalFlag),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderColor, height: 1),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 250) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultColumn(
                      param,
                      isNormal,
                      CrossAxisAlignment.start,
                    ),
                    const SizedBox(height: 8),
                    _buildRangeColumn(param, CrossAxisAlignment.start),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: _buildResultColumn(
                      param,
                      isNormal,
                      CrossAxisAlignment.start,
                    ),
                  ),
                  Expanded(
                    child: _buildRangeColumn(param, CrossAxisAlignment.end),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _buildRangeBar(param),
        ],
      ),
    );
  }

  Widget _buildResultColumn(
    LabParamModel param,
    bool isNormal,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          'Result',
          style: AppTextStyles.caption(
            color: AppColors.greyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${param.paramValue} ${param.unit}',
            style: AppTextStyles.bodyMedium(
              color: isNormal ? Colors.green : AppColors.redColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRangeColumn(LabParamModel param, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          'Normal Range',
          style: AppTextStyles.caption(
            color: AppColors.greyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${param.normalRange} ${param.unit}',
            style: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // ==================== Range Bar ====================
  Widget _buildRangeBar(LabParamModel param) {
    final double min = param.minNormal;
    final double max = param.maxNormal;
    final double value = param.paramValue;

    final double extend = (max - min) * 0.3;
    final double barMin = min - extend;
    final double barMax = max + extend;

    final double clampedValue = value.clamp(barMin, barMax);
    final double position = (clampedValue - barMin) / (barMax - barMin);

    final double normalStart = (min - barMin) / (barMax - barMin);
    final double normalEnd = (max - barMin) / (barMax - barMin);

    return Column(
      children: [
        SizedBox(
          height: 24,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double width = constraints.maxWidth;
              final double indicatorLeft = (width * position - 8).clamp(
                0,
                width - 16,
              );

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: width * normalStart,
                    width: width * (normalEnd - normalStart),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: indicatorLeft,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: param.isNormal
                            ? Colors.green
                            : AppColors.redColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.whiteColor,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (param.isNormal
                                        ? Colors.green
                                        : AppColors.redColor)
                                    .withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${param.minNormal}',
              style: AppTextStyles.caption(color: AppColors.greyColor),
            ),
            Text(
              '${param.maxNormal}',
              style: AppTextStyles.caption(color: AppColors.greyColor),
            ),
          ],
        ),
      ],
    );
  }

  // ==================== AI Analysis Button ====================
  Widget _buildAiAnalysisButton(
    BuildContext context,
    MedicalRecordsState state,
  ) {
    final isLoading = state.labAnalysisStatus == RequestStatus.loading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.05),
            Colors.purple.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome,
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
                      'AI Analysis',
                      style: AppTextStyles.bodyMedium(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Get AI-powered insights about your results',
                      style: AppTextStyles.caption(color: AppColors.greyColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<MedicalRecordsBloc>().add(
                        GetLabAnalysisEvent(id: labResultId),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                disabledBackgroundColor: AppColors.primaryColor.withValues(
                  alpha: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.whiteColor,
                      ),
                    )
                  : const Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: AppColors.whiteColor,
                    ),
              label: Text(
                isLoading ? 'Analyzing...' : 'View AI Analysis',
                style: AppTextStyles.button(color: AppColors.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Download PDF Button ====================
  Widget _buildDownloadButton(BuildContext context, MedicalRecordsState state) {
    final isLoading = state.exportLabStatus == RequestStatus.loading;

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
                    ExportLabResultEvent(labResultId: labResultId),
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
            isLoading ? 'Downloading...' : 'Download Lab Report PDF',
            style: AppTextStyles.button(color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }

  // ==================== Analysis Bottom Sheet ====================
  void _showAnalysisBottomSheet(BuildContext context, String summary) {
    final sections = _parseSummary(summary);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 20,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('AI Analysis', style: AppTextStyles.heading3()),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, size: 22),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.borderColor),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: sections.length + 1,
                      itemBuilder: (context, index) {
                        if (index == sections.length) {
                          return _buildDisclaimer();
                        }
                        final section = sections[index];
                        return _buildAnalysisSection(
                          section['title']!,
                          section['content']!,
                          _getSectionIcon(index),
                          _getSectionColor(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==================== Analysis Section ====================
  Widget _buildAnalysisSection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodySmall(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content.trim(),
            style: AppTextStyles.bodySmall(color: AppColors.darkColor),
          ),
        ],
      ),
    );
  }

  // ==================== Disclaimer ====================
  Widget _buildDisclaimer() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.amber.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This analysis is for reference only and does not replace professional medical consultation.',
              style: AppTextStyles.caption(
                color: AppColors.darkGreyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Helpers ====================
  bool _hasAbnormalResults(LabResultDetailsModel details) {
    return details.params.any((param) => !param.isNormal);
  }

  Color _getFlagColor(String flag) {
    switch (flag.toLowerCase()) {
      case 'high':
        return AppColors.redColor;
      case 'low':
        return Colors.orange;
      case 'critical':
        return Colors.red.shade900;
      default:
        return AppColors.greyColor;
    }
  }

  List<Map<String, String>> _parseSummary(String summary) {
    final sections = <Map<String, String>>[];
    final parts = summary.split(RegExp(r'\n\n+'));

    String currentTitle = '';
    String currentContent = '';

    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.contains('أولا') || trimmed.contains('شرح النتائج')) {
        if (currentTitle.isNotEmpty) {
          sections.add({'title': currentTitle, 'content': currentContent});
        }
        currentTitle = 'Results Explanation';
        currentContent = trimmed.replaceAll(RegExp(r'^.*?[:-]\s*'), '');
      } else if (trimmed.contains('ثانيا') ||
          trimmed.contains('القيم غير الطبيعية')) {
        if (currentTitle.isNotEmpty) {
          sections.add({'title': currentTitle, 'content': currentContent});
        }
        currentTitle = 'Abnormal Values';
        currentContent = trimmed.replaceAll(RegExp(r'^.*?[:-]\s*'), '');
      } else if (trimmed.contains('ثالثا') ||
          trimmed.contains('النصائح العامة')) {
        if (currentTitle.isNotEmpty) {
          sections.add({'title': currentTitle, 'content': currentContent});
        }
        currentTitle = 'General Recommendations';
        currentContent = trimmed.replaceAll(RegExp(r'^.*?[:-]\s*'), '');
      } else if (trimmed.contains('للاسترشاد فقط')) {
        continue;
      } else {
        currentContent += '\n$trimmed';
      }
    }

    if (currentTitle.isNotEmpty) {
      sections.add({'title': currentTitle, 'content': currentContent});
    }

    if (sections.isEmpty) {
      sections.add({
        'title': 'Analysis',
        'content': summary.replaceAll(RegExp(r'للاسترشاد فقط.*$'), '').trim(),
      });
    }

    return sections;
  }

  IconData _getSectionIcon(int index) {
    switch (index) {
      case 0:
        return Icons.description_outlined;
      case 1:
        return Icons.warning_amber_outlined;
      case 2:
        return Icons.lightbulb_outline;
      default:
        return Icons.info_outline;
    }
  }

  Color _getSectionColor(int index) {
    switch (index) {
      case 0:
        return AppColors.primaryColor;
      case 1:
        return AppColors.redColor;
      case 2:
        return Colors.green;
      default:
        return AppColors.greyColor;
    }
  }
}
