import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageUploadService {
  final String uploadUrl = "http://66.29.130.92:5070/upload";

  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Attach the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',  // The field name to send the file
        imageFile.path,
        contentType: MediaType('image', 'jpeg'), // Adjust based on your image type
      ));

      // Send the request
      var streamedResponse = await request.send();

      // Get the response
      var response = await http.Response.fromStream(streamedResponse);

      // Check for success
      if (response.statusCode == 200) {
        // Parse the response body
        var responseBody = jsonDecode(response.body);

        return {
          'path': responseBody['path'],
          'type': responseBody['type'],
        };
      } else {
        // Handle server errors
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any other errors
      throw Exception('Failed to upload image: $e');
    }
  }
}
