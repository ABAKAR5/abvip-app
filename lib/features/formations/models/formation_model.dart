class Formation {
  final String id;
  final String titre;
  final String description;
  final String statut; // 'ouvert', 'bientot', 'complet'
  final DateTime dateDebut;
  final int placesTotal;
  final int placesRestantes;
  final String duree;
  final String niveau;
  final double prix;

  Formation({
    required this.id,
    required this.titre,
    required this.description,
    required this.statut,
    required this.dateDebut,
    required this.placesTotal,
    required this.placesRestantes,
    required this.duree,
    required this.niveau,
    required this.prix,
  });

  Formation copyWith({
    String? id,
    String? titre,
    String? description,
    String? statut,
    DateTime? dateDebut,
    int? placesTotal,
    int? placesRestantes,
    String? duree,
    String? niveau,
    double? prix,
  }) {
    return Formation(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      statut: statut ?? this.statut,
      dateDebut: dateDebut ?? this.dateDebut,
      placesTotal: placesTotal ?? this.placesTotal,
      placesRestantes: placesRestantes ?? this.placesRestantes,
      duree: duree ?? this.duree,
      niveau: niveau ?? this.niveau,
      prix: prix ?? this.prix,
    );
  }
}

// Données de test — on remplacera par Firebase plus tard
final List<Formation> formationsDemo = [
  Formation(
    id: '1',
    titre: 'Django & API REST',
    description: 'Construire une API complète avec Django REST Framework. Tu apprendras les bases de Django, les modèles, les vues et la sérialisation.',
    statut: 'ouvert',
    dateDebut: DateTime.now().add(const Duration(days: 4)),
    placesTotal: 10,
    placesRestantes: 6,
    duree: '5 jours',
    niveau: 'Intermédiaire',
    prix: 5000,
  ),
  Formation(
    id: '2',
    titre: 'Cybersécurité — bases',
    description: 'Pentest, réseaux, outils de sécurité. Introduction aux techniques de base en cybersécurité.',
    statut: 'bientot',
    dateDebut: DateTime.now().add(const Duration(days: 14)),
    placesTotal: 10,
    placesRestantes: 7,
    duree: '3 jours',
    niveau: 'Débutant',
    prix: 3000,
  ),
  Formation(
    id: '3',
    titre: 'Développement mobile Flutter',
    description: 'Flutter de A à Z — créer des applications Android et iOS avec un seul code.',
    statut: 'complet',
    dateDebut: DateTime.now().add(const Duration(days: 2)),
    placesTotal: 8,
    placesRestantes: 0,
    duree: '7 jours',
    niveau: 'Intermédiaire',
    prix: 7000,
  ),
  Formation(
    id: '4',
    titre: 'Python pour débutants',
    description: 'Apprendre Python depuis zéro. Variables, fonctions, boucles, et projets pratiques.',
    statut: 'ouvert',
    dateDebut: DateTime.now().add(const Duration(days: 7)),
    placesTotal: 15,
    placesRestantes: 10,
    duree: '4 jours',
    niveau: 'Débutant',
    prix: 3000,
  ),
];