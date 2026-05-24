import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class MedicineAnalysisBubble extends StatelessWidget {
  final String rawText;

  const MedicineAnalysisBubble({super.key, required this.rawText});

  List<_Section> _parseSections(String text) {
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    final sections = <_Section>[];
    String? currentTitle;
    final buffer = StringBuffer();

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.endsWith(':') && trimmed.length < 60) {
        if (currentTitle != null || buffer.isNotEmpty) {
          sections.add(_Section(
            title: currentTitle,
            body: buffer.toString().trim(),
          ));
          buffer.clear();
        }
        currentTitle = trimmed.replaceAll(':', '').trim();
      } else {
        if (buffer.isNotEmpty) buffer.write(' ');
        buffer.write(trimmed);
      }
    }

    if (currentTitle != null || buffer.isNotEmpty) {
      sections.add(_Section(
        title: currentTitle,
        body: buffer.toString().trim(),
      ));
    }

    return sections;
  }

  IconData _iconForTitle(String? title) {
    if (title == null) return Icons.info_outline;
    final t = title;
    if (t.contains('اسم')) return Icons.medication_outlined;
    if (t.contains('يعالج') || t.contains('استخدام')) return Icons.healing_outlined;
    if (t.contains('طريقة')) return Icons.receipt_long_outlined;
    if (t.contains('جانبية') && t.contains('شائع')) return Icons.warning_amber_outlined;
    if (t.contains('جانبية') || t.contains('خطير')) return Icons.dangerous_outlined;
    if (t.contains('تحذير') || t.contains('خاص')) return Icons.shield_outlined;
    if (t.contains('نصائح') || t.contains('مهم')) return Icons.tips_and_updates_outlined;
    return Icons.info_outline;
  }

  Color _colorForTitle(String? title) {
    if (title == null) return AppColors.primaryColor;
    final t = title;
    if (t.contains('خطير') || t.contains('تحذير')) return AppColors.redColor;
    if (t.contains('شائع') || t.contains('جانبية')) return Colors.orange;
    if (t.contains('نصائح')) return Colors.teal;
    return AppColors.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final sections = _parseSections(rawText);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(Icons.medication, color: AppColors.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Medicine Analysis',
                    style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Sections
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: sections
                    .map((s) => _SectionTile(
                          section: s,
                          icon: _iconForTitle(s.title),
                          color: _colorForTitle(s.title),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section {
  final String? title;
  final String body;
  _Section({this.title, required this.body});
}

class _SectionTile extends StatelessWidget {
  final _Section section;
  final IconData icon;
  final Color color;

  const _SectionTile({
    required this.section,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.title != null) ...[
                  Text(
                    section.title!,
                    style: AppTextStyles.bodySmall(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  section.body,
                  style: AppTextStyles.bodySmall(
                    color: AppColors.darkGreyColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}