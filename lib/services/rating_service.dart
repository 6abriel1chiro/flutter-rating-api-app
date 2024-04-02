import 'package:flutter_bloc/flutter_bloc.dart';

// Define events for the ratings BLoC
abstract class RatingsEvent {}

class RatePost extends RatingsEvent {
  final int postId;
  final int rating;

  RatePost(this.postId, this.rating);
}

// Define states for the ratings BLoC
abstract class RatingsState {}

class RatingsInitial extends RatingsState {}

class RatingsUpdated extends RatingsState {
  final Map<int, int> ratings;

  RatingsUpdated(this.ratings);
}

// Implement the ratings BLoC
class RatingsBloc extends Bloc<RatingsEvent, RatingsState> {
  final Map<int, int> _ratings = {};

  RatingsBloc() : super(RatingsInitial());

  @override
  Stream<RatingsState> mapEventToState(RatingsEvent event) async* {
    if (event is RatePost) {
      _ratings[event.postId] = event.rating;
      yield RatingsUpdated(Map.from(_ratings));
    }
  }
}
