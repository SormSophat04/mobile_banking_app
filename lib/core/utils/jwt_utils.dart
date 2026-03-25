import 'dart:convert';

class JwtDecoder {
  static Map<String, dynamic>? decode(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final String normalized = base64Url.normalize(payload);
      final String decoded = utf8.decode(base64Url.decode(normalized));
      return json.decode(decoded);
    } catch (e) {
      return null;
    }
  }

  static bool isExpired(String token) {
    final payload = decode(token);
    if (payload == null || !payload.containsKey('exp')) return true;
    final int exp = payload['exp'];
    return DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(exp * 1000));
  }
}
