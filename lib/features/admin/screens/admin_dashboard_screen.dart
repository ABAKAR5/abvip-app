import 'package:flutter/material.dart';
import 'package:abakar_portfolio/core/theme/app_colors.dart';
import 'package:abakar_portfolio/core/services/data_service.dart';
import 'package:abakar_portfolio/features/formations/models/formation_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  final VoidCallback onLogout;
  
  const AdminDashboardScreen({super.key, required this.onLogout});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DataService _dataService = DataService();
  bool _isLoading = true;
  List<Map<String, String>> _announcements = [];
  List<Formation> _formations = [];
  List<Map<String, dynamic>> _candidatures = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _dataService.init();
    setState(() {
      _announcements = List.from(_dataService.getAnnouncements());
      _formations = List.from(_dataService.getFormations());
      _candidatures = List.from(_dataService.getCandidatures());
      _isLoading = false;
    });
  }

  Future<void> _saveAnnouncements() async {
    await _dataService.saveAnnouncements(_announcements);
    _showSnackBar('Annonces mises à jour !');
  }

  Future<void> _saveFormations() async {
    await _dataService.saveFormations(_formations);
    _showSnackBar('Formations mises à jour !');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEditAnnouncementDialog(int index) {
    final announcement = _announcements[index];
    final titleCtrl = TextEditingController(text: announcement['title']);
    final typeCtrl = TextEditingController(text: announcement['description']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Modifier l\'Annonce'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: typeCtrl,
              decoration: const InputDecoration(labelText: 'Type / Description courte', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) {
                _showSnackBar('Le titre ne peut pas être vide');
                return;
              }
              if (titleCtrl.text.isNotEmpty) {
                setState(() {
                  _announcements[index] = {
                    ...announcement,
                    'title': titleCtrl.text,
                    'description': typeCtrl.text,
                  };
                });
                _saveAnnouncements();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showAddAnnouncementDialog() {
    final titleCtrl = TextEditingController();
    final typeCtrl = TextEditingController(text: 'NOUVEAU');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Nouvelle Annonce'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: typeCtrl,
              decoration: const InputDecoration(labelText: 'Type / Description courte', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) {
                _showSnackBar('Le titre est requis');
                return;
              }
              if (titleCtrl.text.isNotEmpty) {
                setState(() {
                  _announcements.add({
                    'title': titleCtrl.text,
                    'description': typeCtrl.text,
                    'date': 'Maintenant',
                    'imageUrl': ''
                  });
                });
                _saveAnnouncements();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditFormationDialog(int index) {
    final f = _formations[index];
    final titleCtrl = TextEditingController(text: f.titre);
    final descCtrl = TextEditingController(text: f.description);
    final priceCtrl = TextEditingController(text: f.prix.toInt().toString());
    final levelCtrl = TextEditingController(text: f.niveau);
    final durationCtrl = TextEditingController(text: f.duree);
    final placesCtrl = TextEditingController(text: f.placesTotal.toString());
    String status = f.statut;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Modifier la Formation'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Prix (CFA)', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: placesCtrl, decoration: const InputDecoration(labelText: 'Places', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: levelCtrl, decoration: const InputDecoration(labelText: 'Niveau', border: OutlineInputBorder()))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: durationCtrl, decoration: const InputDecoration(labelText: 'Durée', border: OutlineInputBorder()))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: status,
                    items: ['ouvert', 'bientot', 'complet'].map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase()))).toList(),
                    onChanged: (v) => setDialogState(() => status = v!),
                    decoration: const InputDecoration(labelText: 'Statut', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) {
                  _showSnackBar('Le titre est requis');
                  return;
                }
                if (titleCtrl.text.isNotEmpty) {
                  setState(() {
                    _formations[index] = f.copyWith(
                      titre: titleCtrl.text,
                      description: descCtrl.text,
                      statut: status,
                      placesTotal: int.tryParse(placesCtrl.text) ?? f.placesTotal,
                      placesRestantes: int.tryParse(placesCtrl.text) ?? f.placesRestantes,
                      duree: durationCtrl.text,
                      niveau: levelCtrl.text,
                      prix: double.tryParse(priceCtrl.text) ?? f.prix,
                    );
                  });
                  _saveFormations();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFormationDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final levelCtrl = TextEditingController(text: 'Débutant');
    final durationCtrl = TextEditingController(text: '3 jours');
    final placesCtrl = TextEditingController(text: '10');
    String status = 'ouvert';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Nouvelle Formation'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titre', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 3),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Prix (CFA)', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: placesCtrl, decoration: const InputDecoration(labelText: 'Places', border: OutlineInputBorder()), keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: levelCtrl, decoration: const InputDecoration(labelText: 'Niveau', border: OutlineInputBorder()))),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(controller: durationCtrl, decoration: const InputDecoration(labelText: 'Durée', border: OutlineInputBorder()))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: status,
                    items: ['ouvert', 'bientot', 'complet'].map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase()))).toList(),
                    onChanged: (v) => setDialogState(() => status = v!),
                    decoration: const InputDecoration(labelText: 'Statut', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) {
                  _showSnackBar('Le titre est requis');
                  return;
                }
                if (titleCtrl.text.isNotEmpty) {
                  setState(() {
                    _formations.insert(0, Formation(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      titre: titleCtrl.text,
                      description: descCtrl.text,
                      statut: status,
                      dateDebut: DateTime.now().add(const Duration(days: 7)),
                      placesTotal: int.tryParse(placesCtrl.text) ?? 10,
                      placesRestantes: int.tryParse(placesCtrl.text) ?? 10,
                      duree: durationCtrl.text,
                      niveau: levelCtrl.text,
                      prix: double.tryParse(priceCtrl.text) ?? 0,
                    ));
                  });
                  _saveFormations();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          elevation: 0,
          title: const Text('Dashboard Administration', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: widget.onLogout,
              tooltip: 'Déconnexion',
            ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.campaign_outlined), text: 'Annonces'),
              Tab(icon: Icon(Icons.school_outlined), text: 'Formations'),
              Tab(icon: Icon(Icons.people_alt_outlined), text: 'Candidatures'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildAnnouncementsTab(),
                  _buildFormationsTab(),
                  _buildCandidaturesTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildAnnouncementsTab() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            _buildTabHeader(
              title: 'Gestion des Annonces',
              subtitle: '${_announcements.length} annonces actives',
              onAdd: _showAddAnnouncementDialog,
              color: AppColors.amber,
            ),
            _buildSummaryRow(
              items: [
                _SummaryItem(label: 'Total', value: _announcements.length.toString(), icon: Icons.list_alt),
                _SummaryItem(label: 'Nouveau', value: _announcements.where((a) => a['description']?.contains('NOUVEAU') ?? false).length.toString(), icon: Icons.fiber_new, color: Colors.blue),
              ],
            ),
            Expanded(
              child: _announcements.isEmpty
                  ? _buildEmptyState('Aucune annonce')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _announcements.length,
                      itemBuilder: (context, index) {
                        final item = _announcements[index];
                        return _buildAdminCard(
                          title: item['title'] ?? '',
                          subtitle: item['description'] ?? '',
                          icon: Icons.campaign,
                          iconColor: AppColors.amber,
                          onEdit: () => _showEditAnnouncementDialog(index),
                          onDelete: () {
                            setState(() => _announcements.removeAt(index));
                            _saveAnnouncements();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormationsTab() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            _buildTabHeader(
              title: 'Gestion des Formations',
              subtitle: '${_formations.length} programmes disponibles',
              onAdd: _showAddFormationDialog,
              color: AppColors.primary,
            ),
            _buildSummaryRow(
              items: [
                _SummaryItem(label: 'Ouvertes', value: _formations.where((f) => f.statut == 'ouvert').length.toString(), icon: Icons.lock_open, color: Colors.green),
                _SummaryItem(label: 'Complet', value: _formations.where((f) => f.statut == 'complet').length.toString(), icon: Icons.lock_outline, color: Colors.red),
                _SummaryItem(label: 'Bientôt', value: _formations.where((f) => f.statut == 'bientot').length.toString(), icon: Icons.schedule, color: Colors.orange),
              ],
            ),
            Expanded(
              child: _formations.isEmpty
                  ? _buildEmptyState('Aucune formation')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _formations.length,
                      itemBuilder: (context, index) {
                        final f = _formations[index];
                        return _buildAdminCard(
                          title: f.titre,
                          subtitle: '${f.prix.toInt()} CFA • ${f.statut.toUpperCase()}',
                          icon: Icons.school,
                          iconColor: AppColors.primary,
                          onEdit: () => _showEditFormationDialog(index),
                          onDelete: () {
                            setState(() => _formations.removeAt(index));
                            _saveFormations();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabHeader({required String title, required String subtitle, required VoidCallback onAdd, required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Ajouter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              onPressed: onEdit,
              tooltip: 'Modifier',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () => _showDeleteConfirm(onDelete),
              tooltip: 'Supprimer',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({required List<_SummaryItem> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: items.map((item) => Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icon, size: 20, color: item.color ?? AppColors.textSecondary),
                const SizedBox(height: 8),
                Text(item.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text(item.label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }

  void _showDeleteConfirm(VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cet élément ? cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppColors.textHint.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCandidaturesTab() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Liste des Candidatures', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('${_candidatures.length} personnes inscrites aux formations', style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Expanded(
              child: _candidatures.isEmpty
                  ? _buildEmptyState('Aucune candidature pour le moment')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _candidatures.length,
                      itemBuilder: (context, index) {
                        final c = _candidatures[index];
                        return _buildCandidatureCard(c);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidatureCard(Map<String, dynamic> c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(c['name'] ?? 'Inconnu', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.school, size: 14, color: AppColors.primary), const SizedBox(width: 8), Expanded(child: Text(c['formation'] ?? '', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)))]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.email, size: 14, color: AppColors.textSecondary), const SizedBox(width: 8), Text(c['email'] ?? '')]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.phone, size: 14, color: AppColors.textSecondary), const SizedBox(width: 8), Text(c['phone'] ?? '')]),
            const SizedBox(height: 8),
            Text('Inscrit le : ${_formatDate(c['date'])}', style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () => _showDeleteConfirm(() async {
            await _dataService.deleteCandidature(c['id']);
            _loadData();
          }),
        ),
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (_) {
      return isoDate;
    }
  }
}

class _SummaryItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  _SummaryItem({required this.label, required this.value, required this.icon, this.color});
}
