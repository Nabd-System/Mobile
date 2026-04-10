import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class SpecializationsSection extends StatelessWidget {
  const SpecializationsSection({super.key});

  static const List<Map<String, dynamic>> _specializations = [
    {'name': 'Orthopedics', 'icon': Icons.accessibility_new},
    {'name': 'Urology', 'icon': Icons.medical_services},
    {'name': 'Oncology', 'icon': Icons.biotech},
    {'name': 'Cardiology', 'icon': Icons.favorite},
    {'name': 'Neurology', 'icon': Icons.psychology},
    {'name': 'Dermatology', 'icon': Icons.face},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _specializations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = _specializations[index];
          return _buildSpecializationItem(
            name: item['name'] as String,
            icon: item['icon'] as IconData,
          );
        },
      ),
    );
  }

  Widget _buildSpecializationItem({
    required String name,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to specialization
      },
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primaryColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: AppTextStyles.caption(color: AppColors.darkColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
