import 'package:flutter/material.dart';

class ProjectDiscussions extends StatefulWidget {
  const ProjectDiscussions({super.key, required this.id});
  final String id;

  @override
  State<ProjectDiscussions> createState() => _ProjectDiscussionsState();
}

class _ProjectDiscussionsState extends State<ProjectDiscussions> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child: Text('Comming Soon'))],
      ),
    );
  }
}
