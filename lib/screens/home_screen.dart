import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_api/data/services/api_service.dart';
import 'package:youtube_api/domain/bloc/channel_bloc.dart';
import 'package:youtube_api/domain/bloc/channel_event.dart';
import 'package:youtube_api/domain/bloc/channel_state.dart';
import 'package:youtube_api/domain/models/channel_model.dart';
import 'package:youtube_api/domain/models/videos_model.dart';
import 'package:youtube_api/domain/repository/youtube_repository.dart';
import 'package:youtube_api/screens/video_screen.dart';
import 'package:youtube_api/utilities/constants.dart';

class Home extends StatelessWidget {
  final YoutubeRepository youtubeRepository
  = new YoutubeRepository(apiService: ApiService.instance);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChannelBloc(youtubeRepository: youtubeRepository),
      child: HomeScreen(),
    );
  }

}

class HomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    _buildProfileInfo(Channel channel) {
      return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 1), blurRadius: 6.0)
          ],
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35.0,
              backgroundImage: NetworkImage(channel.profilePictureUrl),
            ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    channel.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${channel.subscriberCount} subscriber',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    _buildVideo(Video video) {
      return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => VideoScreen(id: video.id))),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          padding: EdgeInsets.all(10.0),
          height: 140.0,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 1), blurRadius: 6.0)
          ]),
          child: Hero(
            tag: video.id,
            child: Row(
              children: <Widget>[
                Image(
                  width: 150.0,
                  image: NetworkImage(video.thumbnailUrl),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    video.title,
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    _loadMoreVideos(Channel channel) async {
      BlocProvider.of<ChannelBloc>(context).add(GetMoreVideos(uploadPlaylistId: channel.uploadPlaylistId));
    }

    _buildList(Channel channel) {
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails) {
          if (channel.videos.length != int.parse(channel.videoCount) &&
              scrollDetails.metrics.pixels ==
                  scrollDetails.metrics.maxScrollExtent) {
           // _loadMoreVideos(channel);
          }
          return false;
        },
        child: ListView.builder(itemCount: 1 + channel.videos.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildProfileInfo(channel);
            }
            Video video = channel.videos[index - 1];
            return _buildVideo(video);
          },
        ),);
    }
    
    BlocProvider.of<ChannelBloc>(context).add(GetYoutubeChannel(channelId: CHANNEL_ID));
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Channel"),
      ),
      body: BlocBuilder<ChannelBloc, ChannelState>(
        builder: (context, state){
          if(state is LoadingState){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(state is ChannelSuccessState) {
            return Center(
              child: _buildList(state.channel),
            );
          }else{
            return Center(
              child: Text(
                state.toString()
              ),
            );
          }
        },

      ),
    );
  }
}
