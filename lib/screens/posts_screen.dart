import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MaterialApp(
    home: PostsPage(),
  ));
}

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      Response response =
          await Dio().get('https://jsonplaceholder.typicode.com/posts');
      List<dynamic> responseData = response.data;
      setState(() {
        posts = responseData.map((json) => Post.fromJson(json)).toList();
      });
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(posts[index].title),
            subtitle: Text(posts[index].body),
            trailing: IconButton(
              icon: const Icon(Icons.star_border),
              onPressed: () {
                // Implement star rating functionality
                // You can add your logic here to handle the star rating
              },
            ),
          );
        },
      ),
    );
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
