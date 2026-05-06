import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/formation_model.dart';

class FormationCard extends StatefulWidget {
  final Formation formation;
  final VoidCallback onInscription;

  const FormationCard({
    super.key,
    required this.formation,
    required this.onInscription,
  });

  @override
  State<FormationCard> createState() => _FormationCardState();
}

class _FormationCardState extends State<FormationCard> {
  late Duration _remaining;
  late DateTime _target;

  @override
  void initState() {
    super.initState();
    _target = widget.formation.dateDebut;
    _updateRemaining();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _updateRemaining());
      return true;
    });
  }

  void _updateRemaining() {
    final now = DateTime.now();
    _remaining = _target.isAfter(now) ? _target.difference(now) : Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.formation;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre + statut
          Row(
            children: [
              Expanded(
                child: Text(
                  f.titre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _buildStatutBadge(f.statut),
            ],
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            f.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),

          // Infos : durée, niveau, prix
          Row(
            children: [
              _buildInfo(Icons.access_time, f.duree),
              const SizedBox(width: 12),
              _buildInfo(Icons.signal_cellular_alt, f.niveau),
              const SizedBox(width: 12),
              _buildInfo(Icons.attach_money, '${f.prix.toInt()} FCFA'),
            ],
          ),
          const SizedBox(height: 10),

          // Places restantes
          _buildPlacesBar(f),
          const SizedBox(height: 10),

          // Compte à rebours + bouton
          if (f.statut == 'ouvert') ...[
            _buildCountdown(),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onInscription,
                child: const Text("S'inscrire"),
              ),
            ),
          ] else if (f.statut == 'bientot') ...[
            _buildCountdown(),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.onInscription,
                child: const Text('Être notifié'),
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Formation complète',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatutBadge(String statut) {
    Color bg, text;
    String label;
    switch (statut) {
      case 'ouvert':
        bg = AppColors.primaryLight;
        text = AppColors.primaryDark;
        label = 'Ouvert';
        break;
      case 'bientot':
        bg = AppColors.amberLight;
        text = AppColors.amber;
        label = 'Bientôt';
        break;
      default:
        bg = AppColors.surface;
        text = AppColors.textHint;
        label = 'Complet';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: text),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textHint),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildPlacesBar(Formation f) {
    final ratio = f.placesTotal > 0 ? (f.placesTotal - f.placesRestantes) / f.placesTotal : 1.0;
    final color = f.placesRestantes == 0
        ? AppColors.textHint
        : f.placesRestantes <= 3
            ? AppColors.error
            : AppColors.teal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: AppColors.surface,
            color: color,
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${f.placesRestantes} place${f.placesRestantes > 1 ? 's' : ''} restante${f.placesRestantes > 1 ? 's' : ''} sur ${f.placesTotal}',
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildCountdown() {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _countdownBlock('$days', 'jours'),
          _sep(),
          _countdownBlock(hours.toString().padLeft(2, '0'), 'heures'),
          _sep(),
          _countdownBlock(minutes.toString().padLeft(2, '0'), 'min'),
          _sep(),
          _countdownBlock(seconds.toString().padLeft(2, '0'), 'sec'),
        ],
      ),
    );
  }

  Widget _countdownBlock(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.primaryDark)),
      ],
    );
  }

  Widget _sep() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(':', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
    );
  }
}