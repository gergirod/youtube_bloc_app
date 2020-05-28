
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {

  final String id;

  VideoScreen({
    this.id
  });


  @override
  State<StatefulWidget> createState() => _VideoScreenState();

}

class _VideoScreenState extends State<VideoScreen> {

  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Hero(
        tag: widget.id,
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady:() {
            print('player is ready');
          },
        ),
      ),
    );
  }

}