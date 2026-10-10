import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class XtreamApiException implements Exception {
  final String message;
  XtreamApiException(this.message);
  @override
  String toString() => message;
}

class XtreamApiService {
  static const String _defaultServerUrl = 'http://tuservidor.com:8080';
  final http.Client _client;
  XtreamApiService({http.Client? client}) : _client = client ?? http.Client();

  String _normalizeUrl(String url) {
    var u = url.trim();
    if (u.endsWith('/')) u = u.substring(0, u.length - 1);
    if (!u.startsWith('http://') && !u.startsWith('https://')) {
      u = 'http://$u';
    }
    return u;
  }

  Uri _buildUri(String serverUrl, String username, String password,
      [Map<String, String> extra = const {}]) {
    return Uri.parse('$serverUrl/player_api.php').replace(queryParameters: {
      'username': username,
      'password': password,
      ...extra,
    });
  }

  Future<NeshUser> login({
    required String username,
    required String password,
    String? serverUrl,
  }) async {
    final base = _normalizeUrl(
        (serverUrl == null || serverUrl.trim().isEmpty)
            ? _defaultServerUrl
            : serverUrl);

    try {
      final response = await _client
          .get(_buildUri(base, username, password))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw XtreamApiException(
            'El servidor respondió con error ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic> || data['user_info'] == null) {
        throw XtreamApiException('Respuesta inválida del servidor');
      }

      final user = NeshUser.fromApi(data,
          username: username, password: password, serverUrl: base);

      if (!user.isActive) {
        throw XtreamApiException(
            'Cuenta no activa (estado: ${user.status})');
      }
      return user;
    } on XtreamApiException {
      rethrow;
    } catch (e) {
      throw XtreamApiException('No se pudo conectar con el servidor. '
          'Verifica la URL y tu conexión a internet.');
    }
  }

  Future<List<NeshCategory>> getCategories(NeshUser user, NeshContentType type) async {
    final action = switch (type) {
      NeshContentType.live   => 'get_live_categories',
      NeshContentType.vod    => 'get_vod_categories',
      NeshContentType.series => 'get_series_categories',
    };

    final response = await _client.get(
        _buildUri(user.serverUrl, user.username, user.password, {'action': action}));
    if (response.statusCode != 200) {
      throw XtreamApiException('Error al cargar categorías');
    }

    final List<dynamic> list = jsonDecode(response.body) as List? ?? [];
    return list
        .map((e) => NeshCategory.fromJson(e as Map<String, dynamic>, type))
        .toList();
  }

  Future<List<Map<String, dynamic>>> getContent(
      NeshUser user, NeshContentType type, String categoryId) async {
    final action = switch (type) {
      NeshContentType.live   => 'get_live_streams',
      NeshContentType.vod    => 'get_vod_streams',
      NeshContentType.series => 'get_series',
    };

    final response = await _client.get(_buildUri(
        user.serverUrl, user.username, user.password,
        {'action': action, 'category_id': categoryId}));

    if (response.statusCode != 200) {
      throw XtreamApiException('Error al cargar el contenido');
    }
    return (jsonDecode(response.body) as List? ?? [])
        .cast<Map<String, dynamic>>();
  }

  void dispose() => _client.close();
}
