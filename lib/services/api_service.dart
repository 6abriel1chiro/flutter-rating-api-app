import 'package:dio/dio.dart';
import 'package:flutter_application_2/types/post.dart';

class ApiService {
  static Future<List<Post>> fetchPosts() async {
    try {
      Response response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
      List<dynamic> responseData = response.data;
      return responseData.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}
