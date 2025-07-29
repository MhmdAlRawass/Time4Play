import 'dart:convert';
import 'package:http/http.dart' as http;

class PhpImageService {
  // Get images from PHP backend (no HTML parsing needed)
  static Future<List<String>> getImageUrls(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> document = json.decode(response.body);

        // Extract URLs directly from the JSON response
        List<String> imageUrls =
            document.map((e) => e['url'] as String).toList();

        return imageUrls;
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }
}
