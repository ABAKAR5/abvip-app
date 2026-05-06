import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AppConstants.services.map((service) {
        final colors = _getColors(service['color']!);
        final icon = _getIcon(service['icon']!);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors['bg'],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: colors['icon']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service['subtitle']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.textHint,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, Color> _getColors(String colorName) {
    switch (colorName) {
      case 'teal':
        return {'bg': AppColors.tealLight, 'icon': AppColors.teal};
      case 'amber':
        return {'bg': AppColors.amberLight, 'icon': AppColors.amber};
      case 'coral':
        return {'bg': AppColors.coralLight, 'icon': AppColors.coral};
      case 'purple':
      default:
        return {'bg': AppColors.primaryLight, 'icon': AppColors.primary};
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'security':
        return Icons.shield_outlined;
      case 'mobile':
        return Icons.smartphone_outlined;
      case 'database':
        return Icons.storage_outlined;
      case 'web':
      default:
        return Icons.laptop_outlined;
    }
  }
}