import 'package:equatable/equatable.dart';
import 'package:youtube_api/domain/models/channel_model.dart';
import 'package:youtube_api/domain/models/videos_model.dart';

abstract class ChannelState extends Equatable {}

class LoadingState extends ChannelState {
  @override
  List<Object> get props => null;

}

class ChannelSuccessState extends ChannelState {

  final Channel channel;

  ChannelSuccessState({this.channel});

  @override
  List<Object> get props => null;

}

class MoreVideosSuccessState extends ChannelState {

  final List<Video> videos;

  MoreVideosSuccessState({this.videos});

  @override
  List<Object> get props => null;

}


class ErrorState extends ChannelState {

  final String errorMessage;

  ErrorState({this.errorMessage});

  @override
  List<Object> get props => null;


}