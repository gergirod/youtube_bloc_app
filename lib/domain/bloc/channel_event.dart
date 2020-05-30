import 'package:equatable/equatable.dart';

abstract class ChannelEvent {}

class GetYoutubeChannel extends ChannelEvent {

  final String channelId;

  GetYoutubeChannel({this.channelId});

  @override
  List<Object> get props => null;

}

class GetMoreVideos extends ChannelEvent {
  final String uploadPlaylistId;

  GetMoreVideos({this.uploadPlaylistId});

  @override
  List<Object> get props => null;
}