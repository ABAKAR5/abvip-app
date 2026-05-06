class AppConstants {
  static const String fullName = 'Abakar Mahamat Brahim';
  static const String title = 'Développeur Full-Stack';
  static const String initials = 'AB';
  static const String headline = 'Je crée des applications utiles et modernes.';
  static const String bio =
      'Étudiant en Génie Logiciel à l\'INSTA d\'Abéché. '
      'Passionné par le développement web, la cybersécurité '
      'et les solutions numériques locales.';
  static const String objective =
      'Construire des produits numériques simples, performants et accessibles '
      'pour répondre à des besoins concrets.';
  static const String availability = 'Disponible pour stages et missions freelance';
  static const String responseTime = 'Réponse moyenne: moins de 24h';
  static const String heroHook =
      'Je transforme vos idées en applications web et mobiles modernes.';

  static const String location = 'Abéché, Tchad';
  static const String phone = '+235 60 44 90 70';
  static const String phoneSecondary = '+235 92 46 45 15';
  static const String email = 'abakarmahamatbrahim8@gmail.com';
  static const String availabilitySchedule = 'Lun – Ven : 8h – 18h';
  static const String formspreeEndpoint = 'https://formspree.io/f/xyzjpylk';
  static const String github = 'github.com/ABAKAR5';
  static const String githubUsername = 'ABAKAR5';
  static const String avatarUrl = 'https://github.com/ABAKAR5.png';
  static const String logoAssetPath = 'assets/images/logo.png';
  static const String heroImageAssetPath = 'assets/images/hero.jpg';
  static const String whatsappUrl = 'https://wa.me/23560449070';
  static const String linkedinUrl = 'https://www.linkedin.com/in/ABAKAR-MAHAMAT-BRAHIM';
  static const String xUrl = 'https://x.com/ABAKARMAHA95237';
  static const String instagramUrl = 'https://instagram.com/abakarmahamat647';
  static const String facebookUrl = 'https://facebook.com/';
  static const String youtubeUrl = 'https://youtube.com/';
  static const String school = 'Génie Logiciel — INSTA';

  static const String githubApiUrl =
      'https://api.github.com/users/$githubUsername/repos?sort=updated&per_page=20';

  static const List<String> focusAreas = [
    'Applications web (Django/PHP)',
    'Applications mobiles Flutter',
    'APIs REST et intégrations',
    'Sécurité applicative de base',
  ];

  static const List<Map<String, String>> skills = [
    {'label': 'Python', 'color': 'purple'},
    {'label': 'Django', 'color': 'teal'},
    {'label': 'JavaScript', 'color': 'amber'},
    {'label': 'PHP', 'color': 'purple'},
    {'label': 'MySQL', 'color': 'teal'},
    {'label': 'MongoDB', 'color': 'amber'},
    {'label': 'HTML/CSS', 'color': 'purple'},
    {'label': 'Cybersécurité', 'color': 'coral'},
    {'label': 'Flutter', 'color': 'teal'},
    {'label': 'Firebase', 'color': 'amber'},
  ];

  static const List<Map<String, String>> services = [
    {
      'title': 'Développement web',
      'subtitle': 'Sites, applications, APIs REST',
      'icon': 'web',
      'color': 'purple',
    },
    {
      'title': 'Cybersécurité',
      'subtitle': 'Audit, sécurisation systèmes',
      'icon': 'security',
      'color': 'teal',
    },
    {
      'title': 'Applications mobiles',
      'subtitle': 'Android avec Flutter',
      'icon': 'mobile',
      'color': 'amber',
    },
    {
      'title': 'Bases de données',
      'subtitle': 'MySQL, MongoDB, Firebase',
      'icon': 'database',
      'color': 'coral',
    },
  ];

  static const List<Map<String, String>> milestones = [
    {
      'period': '2026',
      'title': 'Portfolio mobile Flutter',
      'description': 'Conception d\'une app vitrine personnelle moderne.',
    },
    {
      'period': '2025',
      'title': 'Projets académiques full-stack',
      'description': 'Réalisation d\'applications web orientées besoins locaux.',
    },
    {
      'period': '2024',
      'title': 'Approfondissement cybersécurité',
      'description': 'Bonnes pratiques de sécurisation et audit de base.',
    },
  ];

  static const List<Map<String, String>> featuredProjects = [
    {
      'title': 'SGB — Bibliothèque',
      'description': 'Système de gestion de bibliothèque avec interface Bootstrap.',
      'tech': 'PHP / MySQL',
      'url': 'https://github.com/$githubUsername',
    },
    {
      'title': 'INSTA Rencontre',
      'description': 'Plateforme sociale bilingue pensée pour les étudiants.',
      'tech': 'PHP / JavaScript',
      'url': 'https://github.com/$githubUsername',
    },
    {
      'title': 'Django Reservation',
      'description': 'Gestion de réservation avec API REST et tableau de bord.',
      'tech': 'Python / Django',
      'url': 'https://github.com/$githubUsername',
    },
  ];

  static const int projectsCount = 10;
  static const int formationsCount = 5;
  static const int experienceYears = 2;

  static const List<Map<String, String>> announcements = [
    {
      'title': 'Nouvelle formation Django',
      'description': 'Je viens de lancer une nouvelle session de formation sur Django REST Framework pour les débutants.',
      'date': 'Aujourd\'hui',
      'imageUrl': '',
    },
    {
      'title': 'Portfolio V2.0 en ligne',
      'description': 'Mise à jour majeure du portfolio avec un design moderne, des animations et une synchronisation GitHub en temps réel !',
      'date': 'Il y a 2 jours',
      'imageUrl': '',
    },
    {
      'title': 'Certification en Cybersécurité',
      'description': 'J\'ai officiellement obtenu ma certification de base en audit de sécurité. Prêt pour de nouveaux défis.',
      'date': 'Semaine dernière',
      'imageUrl': '',
    },
  ];
}