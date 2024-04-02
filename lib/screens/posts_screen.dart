import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/api_service.dart';
import 'package:flutter_application_2/types/post.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService.fetchPosts();
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
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Post> posts = snapshot.data ?? [];
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  subtitle: Text(post.body),
                  trailing: IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      _showRatingDialog(post);
                    },
                  ),
                  title: Text(
                    post.rating != null
                        ? '${post.title} - ${post.rating} stars'
                        : post.title,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
