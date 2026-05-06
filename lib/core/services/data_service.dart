import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abakar_portfolio/features/formations/models/formation_model.dart';
import '../constants/app_constants.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  static const String _announcementsKey = 'announcements_data';
  static const String _formationsKey = 'formations_data';
  static const String _candidaturesKey = 'candidatures_data';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Announcements ---
  
  List<Map<String, String>> getAnnouncements() {
    final String? data = _prefs.getString(_announcementsKey);
    if (data == null) {
      return AppConstants.announcements; // Default
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => {
        'title': e['title'] as String,
        'description': e['description'] as String,
        'date': e['date'] as String,
        'imageUrl': e['imageUrl'] as String,
      }).toList();
    } catch (e) {
      return AppConstants.announcements;
    }
  }

  Future<void> saveAnnouncements(List<Map<String, String>> announcements) async {
    await _prefs.setString(_announcementsKey, jsonEncode(announcements));
  }

  // --- Formations ---
  
  List<Formation> getFormations() {
    final String? data = _prefs.getString(_formationsKey);
    if (data == null) {
      return formationsDemo; // Default
    }
    
    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Formation(
        id: e['id'],
        titre: e['titre'],
        description: e['description'],
        statut: e['statut'],
        dateDebut: DateTime.parse(e['dateDebut']),
        placesTotal: e['placesTotal'],
        placesRestantes: e['placesRestantes'],
        duree: e['duree'],
        niveau: e['niveau'],
        prix: (e['prix'] as num).toDouble(),
      )).toList();
    } catch (e) {
      return formationsDemo;
    }
  }

  Future<void> saveFormations(List<Formation> formations) async {
    final List<Map<String, dynamic>> jsonList = formations.map((e) => {
      'id': e.id,
      'titre': e.titre,
      'description': e.description,
      'statut': e.statut,
      'dateDebut': e.dateDebut.toIso8601String(),
      'placesTotal': e.placesTotal,
      'placesRestantes': e.placesRestantes,
      'duree': e.duree,
      'niveau': e.niveau,
      'prix': e.prix,
    }).toList();
    await _prefs.setString(_formationsKey, jsonEncode(jsonList));
  }

  // --- Candidatures (Applications) ---

  List<Map<String, dynamic>> getCandidatures() {
    final String? data = _prefs.getString(_candidaturesKey);
    if (data == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveCandidature(Map<String, dynamic> candidature) async {
    final List<Map<String, dynamic>> current = getCandidatures();
    current.insert(0, {
      ...candidature,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': DateTime.now().toIso8601String(),
    });
    await _prefs.setString(_candidaturesKey, jsonEncode(current));
  }

  Future<void> deleteCandidature(String id) async {
    final List<Map<String, dynamic>> current = getCandidatures();
    current.removeWhere((element) => element['id'] == id);
    await _prefs.setString(_candidaturesKey, jsonEncode(current));
  }
}
