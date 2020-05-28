import 'package:flutter/material.dart';
import 'package:youtube_api/models/channel_model.dart';
import 'package:youtube_api/models/videos_model.dart';
import 'package:youtube_api/screens/video_screen.dart';
import 'package:youtube_api/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  Channel _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  @override
  Widget build(BuildContext context) {
    _buildProfileInfo() {
      return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [ BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0
          )
          ],
        ),

        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35.0,
              backgroundImage: NetworkImage(_channel.profilePictureUrl),
            ),
            SizedBox(width: 12.0,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _channel.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_channel.subscriberCount} subscriber',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600
                    ),
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
        onTap: () =>  Navigator.push(context,
        MaterialPageRoute(
            builder: (_) => VideoScreen(
                id: video.id))),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          padding: EdgeInsets.all(10.0),
          height: 140.0,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 1),
                    blurRadius: 6.0
                )
              ]
          ),
          child: Hero(
            tag: video.id,
            child: Row(
              children: <Widget>[
                Image(
                  width: 150.0,
                  image: NetworkImage(video.thumbnailUrl),
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Text(
                    video.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    _loadMoreVideos() async {
      _isLoading = true;
      List<Video> moreVideos = await ApiService.instance.fetchVideosFromPlayList(
          playlistId: _channel.uploadPlaylistId);
      List<Video> allVideos = _channel.videos..addAll(moreVideos);
      setState(() {
        _channel.videos = allVideos;
      });

      _isLoading = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Channel'),
      ),
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetials) {
          if(!_isLoading && _channel.videos.length != int.parse(_channel.videoCount) &&
          scrollDetials.metrics.pixels == scrollDetials.metrics.maxScrollExtent) {
            // ignore: missing_return
            _loadMoreVideos();
          }
          return false;
        },
        child: ListView.builder(
        itemCount: 1 + _channel.videos.length,
        itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildProfileInfo();
            }
            Video video = _channel.videos[index - 1];
            return _buildVideo(video);
        },
      ),
          )
          : Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme
                .of(context)
                .primaryColor,
          ),
        ),
      ),

    );
  }

  _initChannel() async {
    Channel channel = await ApiService.instance.fetchChannel(
        channelId: 'UC6Dy0rQ6zDnQuHQ1EeErGUA');
    setState(() {
      _channel = channel;
    });
  }
}