import 'package:youtube_api/data/services/api_service.dart';
import 'package:youtube_api/domain/models/channel_model.dart';
import 'package:youtube_api/domain/models/videos_model.dart';

class YoutubeRepository {

  final ApiService apiService;

  YoutubeRepository({
    this.apiService
  });

  Future<Channel> getChannel(String channelId) async {
    return await apiService.fetchChannel(channelId: channelId);
  }

  Future<List<Video>> getMoreVideos(String uploadPlaylistId) async {
    return await apiService.fetchVideosFromPlayList(playlistId: uploadPlaylistId);
  }

}