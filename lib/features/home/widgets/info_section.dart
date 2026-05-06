import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Localisation',
            value: AppConstants.location,
          ),
          const Divider(height: 0),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Téléphone',
            value: AppConstants.phone,
          ),
          const Divider(height: 0),
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: AppConstants.email,
          ),
          const Divider(height: 0),
          _buildInfoRow(
            icon: Icons.code,
            label: 'GitHub',
            value: AppConstants.github,
            isLink: true,
          ),
          const Divider(height: 0),
          _buildInfoRow(
            icon: Icons.school_outlined,
            label: 'Formation',
            value: AppConstants.school,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isLink ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}