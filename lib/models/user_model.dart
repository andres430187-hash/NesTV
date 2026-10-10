class NeshUser {
  final String username;
  final String password;
  final String serverUrl;
  final String status;
  final String? expiryDate;
  final bool isTrial;

  const NeshUser({
    required this.username,
    required this.password,
    required this.serverUrl,
    required this.status,
    this.expiryDate,
    this.isTrial = false,
  });

  factory NeshUser.fromApi(Map<String, dynamic> json, {
    required String username,
    required String password,
    required String serverUrl,
  }) {
    final info = json['user_info'] as Map<String, dynamic>? ?? {};
    return NeshUser(
      username: username,
      password: password,
      serverUrl: serverUrl,
      status: info['status']?.toString() ?? 'Unknown',
      expiryDate: info['exp_date']?.toString(),
      isTrial: info['is_trial'] == '1' || info['is_trial'] == 1,
    );
  }

  bool get isActive => status.toLowerCase() == 'active';
  String get baseApiUrl => '$serverUrl/player_api.php';
  String liveStreamUrl(String streamId, {String extension = 'm3u8'}) => '$serverUrl/live/$username/$password/$streamId.$extension';
  String vodStreamUrl(String streamId, {String extension = 'mp4'}) => '$serverUrl/movie/$username/$password/$streamId.$extension';
  String seriesEpisodeUrl(String episodeId, {String extension = 'm3u8'}) => '$serverUrl/series/$username/$password/$episodeId.$extension';
  String epgLogoUrl(String logoPath) => serverUrl + logoPath;
}

class NeshCategory {
  final String categoryId;
  final String categoryName;
  final NeshContentType type;

  const NeshCategory({required this.categoryId, required this.categoryName, required this.type});

  factory NeshCategory.fromJson(Map<String, dynamic> json, NeshContentType type) {
    return NeshCategory(
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? 'Sin nombre',
      type: type,
    );
  }
}

enum NeshContentType { live, vod, series }
