import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sending = false;
  bool _isDark = false;

  Color get _bg => _isDark ? AppColors.bgDark : AppColors.bgLight;
  Color get _appBarBg => _isDark ? AppColors.bgDark.withOpacity(0.9) : Colors.white;
  Color get _text => _isDark ? Colors.white : AppColors.textPrimary;
  Color get _subText => _isDark ? const Color(0xFFCFC6FF) : AppColors.textSecondary;
  Color get _card => _isDark ? const Color(0x14FFFFFF) : Colors.white;
  Color get _border => _isDark ? const Color(0x2BFFFFFF) : AppColors.border;

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border.withOpacity(0.5)),
        boxShadow: [
          if (!_isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
        ],
      );

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: CustomScrollView(
              slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: _appBarBg,
              title: Row(
                children: [
                  _buildLogoBadge(),
                  const SizedBox(width: 8),
                  Text(
                    'AB VIP APP',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _text),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Style clair/sombre',
                  onPressed: () => setState(() => _isDark = !_isDark),
                  icon: Icon(_isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: _text),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  FadeInDown(duration: const Duration(milliseconds: 600), child: _buildHeroTop()),
                  const SizedBox(height: 12),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 100), child: _buildStatsRow()),
                  const SizedBox(height: 12),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 200), child: _buildSocialStrip()),
                  const SizedBox(height: 12),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 300), child: _buildQuickActions()),
                  const SizedBox(height: 16),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 320), child: _buildSectionLabel('Nouveautés')),
                  const SizedBox(height: 8),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 320), child: _buildAnnouncements()),
                  const SizedBox(height: 16),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 350), child: _buildSectionLabel('Mes Services')),
                  const SizedBox(height: 8),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 350), child: _buildServices()),
                  const SizedBox(height: 16),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 380), child: _buildSectionLabel('Mon Parcours')),
                  const SizedBox(height: 8),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 380), child: _buildMilestones()),
                  const SizedBox(height: 16),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 400), child: _buildSectionLabel('Compétences')),
                  const SizedBox(height: 8),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 400), child: _buildSkills()),
                  const SizedBox(height: 14),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 500), child: _buildSectionLabel('Projets')),
                  const SizedBox(height: 8),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 500), child: _buildProjects()),
                  const SizedBox(height: 14),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 600), child: _buildSectionLabel('Infos Contact')),
                  const SizedBox(height: 8),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 600), child: _buildContactMini()),
                  const SizedBox(height: 16),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 700), child: _buildSectionLabel('Me Contacter')),
                  const SizedBox(height: 8),
                  FadeInUp(duration: const Duration(milliseconds: 600), delay: const Duration(milliseconds: 700), child: _buildContactFormCard()),
                ]),
              ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBadge() {
    if (AppConstants.logoAssetPath.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          AppConstants.logoAssetPath,
          width: 28,
          height: 28,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackLogo(),
        ),
      );
    }
    return _fallbackLogo();
  }

  Widget _fallbackLogo() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(colors: [Color(0xFFE900A3), Color(0xFF5E2BFF)]),
      ),
      child: const Center(
        child: Text('AB', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildHeroTop() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: AppColors.premiumGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenue sur AB VIP APP',
                  style: TextStyle(color: Color(0xFFFBEFFF), fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Développeur Full-Stack pour vos projets web et mobile.',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, height: 1.3),
                ),
                const SizedBox(height: 6),
                const Text(
                  '${AppConstants.fullName} • ${AppConstants.location}',
                  style: TextStyle(color: Color(0xFFD6CCFF), fontSize: 11),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: const Text(
                    'Disponible pour nouveaux projets',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(flex: 4, child: _buildHeroVisual()),
        ],
      ),
    );
  }

  Widget _buildHeroVisual() {
    if (AppConstants.heroImageAssetPath.isNotEmpty) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE900A3).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          child: const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(AppConstants.heroImageAssetPath),
          ),
        ),
      );
    }
    return _fallbackAvatar();
  }

  Widget _fallbackAvatar() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0x22FFFFFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: CircleAvatar(
          radius: 44,
          backgroundColor: Colors.white,
          child: ClipOval(
            child: Image.network(
              AppConstants.avatarUrl,
              width: 82,
              height: 82,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Text(
                AppConstants.initials,
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return const Row(
      children: [
        _StatChip(value: '${AppConstants.projectsCount}', label: 'Projets'),
        SizedBox(width: 8),
        _StatChip(value: '${AppConstants.formationsCount}', label: 'Formations'),
        SizedBox(width: 8),
        _StatChip(value: '${AppConstants.experienceYears}+', label: 'Ans'),
      ],
    );
  }

  Widget _buildSocialStrip() {
    final items = <Widget>[
      if (AppConstants.whatsappUrl.isNotEmpty) _SocialCircleButton(icon: Icons.chat, onTap: () => _openUrl(AppConstants.whatsappUrl)),
      if (AppConstants.linkedinUrl.isNotEmpty) _SocialCircleButton(icon: Icons.business_center_outlined, onTap: () => _openUrl(AppConstants.linkedinUrl)),
      if (AppConstants.xUrl.isNotEmpty) _SocialCircleButton(icon: Icons.alternate_email, onTap: () => _openUrl(AppConstants.xUrl)),
      if (AppConstants.instagramUrl.isNotEmpty) _SocialCircleButton(icon: Icons.camera_alt_outlined, onTap: () => _openUrl(AppConstants.instagramUrl)),
      if (AppConstants.facebookUrl.isNotEmpty) _SocialCircleButton(icon: Icons.thumb_up_alt_outlined, onTap: () => _openUrl(AppConstants.facebookUrl)),
      if (AppConstants.youtubeUrl.isNotEmpty) _SocialCircleButton(icon: Icons.play_circle_outline, onTap: () => _openUrl(AppConstants.youtubeUrl)),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: _cardDecoration,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: items,
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.mail_outline,
            label: 'Email',
            onTap: () => _openUrl('mailto:${AppConstants.email}'),
            isDark: _isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.picture_as_pdf_outlined,
            label: 'CV',
            onTap: () => _openUrl('https://${AppConstants.github}'),
            isDark: _isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.code,
            label: 'GitHub',
            onTap: () => _openUrl('https://${AppConstants.github}'),
            isDark: _isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(color: _subText, fontSize: 11, letterSpacing: 0.8, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSkills() {
    final selected = AppConstants.skills.take(6).toList();
    return Column(
      children: selected.map((skill) {
        final label = skill['label'] ?? '';
        final accent = _skillAccent(skill['color'] ?? '');
        final level = _skillLevel(label);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: _cardDecoration,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(color: _text, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text('${(level * 100).round()}%', style: TextStyle(color: _subText, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 5,
                  value: level,
                  backgroundColor: _isDark ? const Color(0x25FFFFFF) : const Color(0xFFE8ECF1),
                  color: accent,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  double _skillLevel(String label) {
    switch (label.toLowerCase()) {
      case 'python':
      case 'html/css':
        return 0.95;
      case 'javascript':
        return 0.90;
      case 'php':
      case 'mysql':
        return 0.85;
      case 'mongodb':
      case 'cybersécurité':
        return 0.75;
      default:
        return 0.80;
    }
  }

  Color _skillAccent(String colorName) {
    switch (colorName) {
      case 'teal':
        return const Color(0xFF19C9A2);
      case 'amber':
        return const Color(0xFFFFB646);
      case 'coral':
        return const Color(0xFFFF6E5E);
      default:
        return const Color(0xFFE84CC1);
    }
  }

  Widget _buildProjects() {
    return Column(
      children: AppConstants.featuredProjects.map((project) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: _cardDecoration,
          child: ListTile(
            onTap: () => _openUrl(project['url'] ?? 'https://${AppConstants.github}'),
            title: Text(project['title'] ?? '', style: TextStyle(color: _text, fontSize: 13, fontWeight: FontWeight.w600)),
            subtitle: Text(
              project['description'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _subText, fontSize: 11),
            ),
            trailing: Icon(Icons.open_in_new, color: _subText, size: 16),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactMini() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration,
      child: Column(
        children: [
          _ContactRow(label: 'Téléphone', value: '${AppConstants.phone} / ${AppConstants.phoneSecondary}', textColor: _text, labelColor: _subText),
          const SizedBox(height: 6),
          _ContactRow(label: 'Email', value: AppConstants.email, textColor: _text, labelColor: _subText),
          const SizedBox(height: 6),
          _ContactRow(label: 'Localisation', value: AppConstants.location, textColor: _text, labelColor: _subText),
          const SizedBox(height: 6),
          _ContactRow(label: 'Disponibilité', value: AppConstants.availabilitySchedule, textColor: _text, labelColor: _subText),
        ],
      ),
    );
  }

  Widget _buildContactFormCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration,
      child: Column(
        children: [
          _buildInput(_nameCtrl, 'Nom complet', TextInputType.name),
          const SizedBox(height: 8),
          _buildInput(_emailCtrl, 'Adresse email', TextInputType.emailAddress),
          const SizedBox(height: 8),
          _buildInput(_subjectCtrl, 'Sujet', TextInputType.text),
          const SizedBox(height: 8),
          TextField(
            controller: _messageCtrl,
            maxLines: 4,
            style: TextStyle(color: _text, fontSize: 12),
            decoration: _inputDecoration('Message'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sending ? null : _submitContactForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE900A3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
              child: Text(_sending ? 'Envoi...' : 'Envoyer le message'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: _text, fontSize: 12),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: _subText.withOpacity(0.8), fontSize: 12),
      filled: true,
      fillColor: _isDark ? const Color(0x14000000) : const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _border)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE900A3)),
      ),
    );
  }

  Future<void> _submitContactForm() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty || _subjectCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      _showMessage('Merci de remplir tous les champs.');
      return;
    }

    setState(() => _sending = true);
    try {
      final response = await http.post(
        Uri.parse(AppConstants.formspreeEndpoint),
        headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'name': _nameCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'subject': _subjectCtrl.text.trim(),
          'message': _messageCtrl.text.trim(),
        }),
      );
      if (!mounted) return;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _nameCtrl.clear();
        _emailCtrl.clear();
        _subjectCtrl.clear();
        _messageCtrl.clear();
        _showMessage('Message envoyé avec succès.');
      } else {
        _showMessage('Envoi échoué, réessaie dans un moment.');
      }
    } catch (_) {
      if (mounted) _showMessage('Erreur réseau. Vérifie internet puis réessaie.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Widget _buildAnnouncements() {
    final announcements = DataService().getAnnouncements();
    if (announcements.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: announcements.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = announcements[index];
          return Container(
            width: 260,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: _isDark
                  ? const LinearGradient(colors: [Color(0xFF2A1B54), Color(0xFF1E1145)])
                  : AppColors.accentGradient,
              boxShadow: [
                if (!_isDark)
                  BoxShadow(
                    color: const Color(0xFF5E2BFF).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('NOUVEAU', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    Text(item['date'] ?? '', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
                  ],
                ),
                const Spacer(),
                Text(
                  item['title'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  item['description'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, height: 1.3),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServices() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: AppConstants.services.length,
      itemBuilder: (context, index) {
        final service = AppConstants.services[index];
        IconData getIcon(String i) {
          switch (i) {
            case 'web': return Icons.language;
            case 'security': return Icons.security;
            case 'mobile': return Icons.smartphone;
            case 'database': return Icons.storage;
            default: return Icons.computer;
          }
        }
        return Container(
          decoration: _cardDecoration,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(getIcon(service['icon'] ?? ''), color: _skillAccent(service['color'] ?? ''), size: 24),
              const SizedBox(height: 8),
              Text(service['title'] ?? '', style: TextStyle(color: _text, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(service['subtitle'] ?? '', style: TextStyle(color: _subText, fontSize: 10)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMilestones() {
    return Column(
      children: AppConstants.milestones.map((ms) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      gradient: AppColors.accentGradient,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(width: 2, height: 40, color: _border),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ms['period'] ?? '', style: const TextStyle(color: Color(0xFFE900A3), fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(ms['title'] ?? '', style: TextStyle(color: _text, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(ms['description'] ?? '', style: TextStyle(color: _subText, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0x14FFFFFF) : Colors.white;
    final borderColor = isDark ? const Color(0x2BFFFFFF) : const Color(0xFFE4E7EC);
    final textColor = isDark ? Colors.white : const Color(0xFF171726);
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, size: 17, color: textColor),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF08052E);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0x1BFFFFFF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? const Color(0x26FFFFFF) : const Color(0xFFE4E7EC)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF171726),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: isDark ? const Color(0xFFDCCFFF) : Colors.grey.shade600, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color labelColor;

  const _ContactRow({
    required this.label,
    required this.value,
    required this.textColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 11)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(color: textColor, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).scaffoldBackgroundColor == const Color(0xFF08052E);
    return Material(
      color: isDark ? const Color(0x1AFFFFFF) : Colors.white,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 16, color: isDark ? Colors.white : const Color(0xFF171726)),
        ),
      ),
    );
  }
}
