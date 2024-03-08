import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'router_event.dart';
part 'router_state.dart';

class HomeNavigationBloc extends Bloc<RouterEvent, HomeNavigationState> {
  HomeNavigationBloc(super.state) {
    on<HomeNavigationBranchChangeRequested>(_handleRouterPathChangeRequested);
  }

  void _handleRouterPathChangeRequested(
    HomeNavigationBranchChangeRequested event,
    Emitter<HomeNavigationState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
  }
}
