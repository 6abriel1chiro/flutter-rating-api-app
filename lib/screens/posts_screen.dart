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

  Future<void> _showRatingDialog(Post post) async {
    double? rating = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate this post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
              (index) => ListTile(
                title: Text('${index + 1} stars'),
                onTap: () {
                  Navigator.of(context).pop(index + 1);
                },
              ),
            ),
          ),
        );
      },
    );

    if (rating != null) {
      setState(() {
        post.rating = rating;
      });
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
          final post = posts[index];
          return ListTile(
            subtitle: Text(post.body),
            trailing: IconButton(
              icon: Icon(Icons.star_border),
              onPressed: () {
                _showRatingDialog(post);
              },
            ),
            // Display the rating if available
            // If not rated yet, display "Not Rated"
            // You can customize this part based on your design
            // This is just a simple example
            // Displaying the rating in the title itself
            // to avoid the duplicate named argument issue
            title: Text(
              post.rating != null
                  ? '${post.title} - ${post.rating} stars'
                  : post.title,
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
  double? rating;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.rating,
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
