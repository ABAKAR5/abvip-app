import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: AppConstants.skills.map((skill) {
        final colors = _getColors(skill['color']!);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: colors['bg'],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            skill['label']!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors['text'],
            ),
          ),
        );
      }).toList(),
    );
  }

  Map<String, Color> _getColors(String colorName) {
    switch (colorName) {
      case 'teal':
        return {'bg': AppColors.tealLight, 'text': const Color(0xFF085041)};
      case 'amber':
        return {'bg': AppColors.amberLight, 'text': const Color(0xFF633806)};
      case 'coral':
        return {'bg': AppColors.coralLight, 'text': const Color(0xFF712B13)};
      case 'purple':
      default:
        return {'bg': AppColors.primaryLight, 'text': AppColors.primaryDark};
    }
  }
}