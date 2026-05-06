import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class GithubRepo {
  final String name;
  final String description;
  final String htmlUrl;
  final String language;
  final int stargazersCount;

  GithubRepo({
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.language,
    required this.stargazersCount,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      name: json['name'] ?? '',
      description: json['description'] ?? 'Aucune description fournie.',
      htmlUrl: json['html_url'] ?? '',
      language: json['language'] ?? 'Non spécifié',
      stargazersCount: json['stargazers_count'] ?? 0,
    );
  }
}

class GithubService {
  Future<List<GithubRepo>> fetchRepositories() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.githubApiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => GithubRepo.fromJson(json)).toList();
      } else {
        throw Exception('Échec de la récupération des dépôts GitHub.');
      }
    } catch (e) {
      throw Exception('Erreur réseau ou API: $e');
    }
  }
}
