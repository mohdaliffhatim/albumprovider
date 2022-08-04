import 'dart:convert';
import 'dart:io';
import 'package:album/models/HTTP.dart';
import 'package:album/models/POST.dart';
import 'package:http/http.dart';


class HelperAPI {
  static Future<ResponseHTTP<List<Post>>> getPosts(
      {int page = 1, int limit = 10}) async {
    try {
      var response = await get(
        'https://jsonplaceholder.typicode.com/albums',
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<Post> posts = [];
        body.forEach((e) {
          Post post = Post.fromJson(e);
          posts.add(post);
        });
        return ResponseHTTP<List<Post>>(
          true,
          posts,
          message: 'Successful!',
          codeStatus: response.statusCode,
        );
      } else {
        return ResponseHTTP<List<Post>>(
          false,
          null,
          message:
          'Invalid data received from the server! Please try again later.',
          codeStatus: response.statusCode,
        );
      }
    } on SocketException {
      print('SOCKET EXCEPTION OCCURRED');
      return ResponseHTTP<List<Post>>(
        false,
        null,
        message: 'Unable to connect  the internet! Please reconnect again.',
      );
    } on FormatException {
      print('JSON FORMAT EXCEPTION OCCURRED');
      return ResponseHTTP<List<Post>>(
        false,
        null,
        message:
        'Invalid data from the server! Please try again.',
      );
    } catch (e) {
      print('UNEXPECTED ERROR');
      print(e.toString());
      return ResponseHTTP<List<Post>>(
        false,
        null,
        message: 'Something went wrong! Please retry.',
      );
    }
  }
}