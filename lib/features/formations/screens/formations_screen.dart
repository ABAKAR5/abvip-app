import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/data_service.dart';
import '../models/formation_model.dart';
import '../widgets/formation_card.dart';

class FormationsScreen extends StatefulWidget {
  const FormationsScreen({super.key});

  @override
  State<FormationsScreen> createState() => _FormationsScreenState();
}

class _FormationsScreenState extends State<FormationsScreen> {
  int _tabIndex = 0;
  final Set<String> _inscriptions = {};

  @override
  Widget build(BuildContext context) {
    final allFormations = DataService().getFormations();
    final formations = _tabIndex == 0
        ? allFormations.where((f) => !_inscriptions.contains(f.id)).toList()
        : allFormations.where((f) => _inscriptions.contains(f.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border, width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildTab('Disponibles', 0),
                          _buildTab('Mes inscriptions', 1),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: formations.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: formations.length,
                          itemBuilder: (context, index) {
                            final formation = formations[index];
                            return FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              delay: Duration(milliseconds: 100 * index.clamp(0, 10)),
                              child: FormationCard(
                                formation: formation,
                                onInscription: () => _showInscriptionDialog(formation),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFE900A3), Color(0xFF5E2BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5E2BFF).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formations & Bootcamps',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Développez vos compétences avec nos programmes intensifs et pratiques.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: FadeInUp(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: AppColors.textHint.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text(
              'Aucune inscription',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vous n\'êtes inscrit à aucune\nformation pour le moment.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final selected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  void _showInscriptionDialog(Formation formation) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    bool isSending = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                formation.statut == 'ouvert' ? 'S\'inscrire à la formation' : 'Être notifié',
                style: const TextStyle(fontSize: 18, color: AppColors.textPrimary),
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formation.titre,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder())),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSending ? null : () => Navigator.pop(context),
                  child: const Text('Annuler', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          if (nameCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty) return;
                          setDialogState(() => isSending = true);
                          try {
                            await http.post(
                              Uri.parse(AppConstants.formspreeEndpoint),
                              headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
                              body: jsonEncode({
                                'name': nameCtrl.text.trim(),
                                'email': emailCtrl.text.trim(),
                                'phone': phoneCtrl.text.trim(),
                                'formation': formation.titre,
                                'type': formation.statut == 'ouvert' ? 'Inscription Formation' : 'Demande Notification',
                              }),
                            );
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            setState(() => _inscriptions.add(formation.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(formation.statut == 'ouvert'
                                    ? 'Inscription validée ! Vous recevrez des rappels avant le début.'
                                    : 'C\'est noté ! Nous vous préviendrons dès l\'ouverture.'),
                                backgroundColor: AppColors.teal,
                              ),
                            );
                          } catch (_) {
                            setDialogState(() => isSending = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erreur réseau. Veuillez réessayer.')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: isSending
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Valider'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
