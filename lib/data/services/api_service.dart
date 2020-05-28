import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:youtube_api/domain/models/channel_model.dart';
import 'package:youtube_api/domain/models/videos_model.dart';
import 'package:youtube_api/utilities/keys.dart';

class ApiService {
  ApiService._instantiate();

  static final ApiService instance = ApiService._instantiate();

  String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY
    };

    Uri uri = Uri.https(
      _baseUrl,
      'youtube/v3/channels',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      channel.videos = await fetchVideosFromPlayList(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlayList({String playlistId}) async {
    Map<String, String> paramentes = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pagetoken': _nextPageToken,
      'key': API_KEY
    };

    Uri uri = Uri.https(_baseUrl, 'youtube/v3/playlistItems', paramentes);

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    //Get Videos

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      List<Video> vidoes = [];
      videosJson.forEach((json) => vidoes.add(
            Video.fromMap(json['snippet']),
          ));

      return vidoes;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
