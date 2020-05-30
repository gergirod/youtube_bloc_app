import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_api/domain/bloc/channel_event.dart';
import 'package:youtube_api/domain/bloc/channel_state.dart';
import 'package:youtube_api/domain/models/channel_model.dart';
import 'package:youtube_api/domain/repository/youtube_repository.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {

  final YoutubeRepository youtubeRepository;
  Channel channel;

  ChannelBloc({this.youtubeRepository});

  @override
  ChannelState get initialState => LoadingState();

  @override
  Stream<ChannelState> mapEventToState(ChannelEvent event) async* {
    if(event is GetYoutubeChannel) {
      yield* mapGetChannelEventToState(event);
    }
  }

  Stream<ChannelState> mapGetChannelEventToState(GetYoutubeChannel getYoutubeChannel) async* {
    try{
      channel = await youtubeRepository.getChannel(getYoutubeChannel.channelId);
      yield ChannelSuccessState(channel: channel);
    }catch(e) {
      yield ErrorState(errorMessage: e.toString());
    }
  }



}