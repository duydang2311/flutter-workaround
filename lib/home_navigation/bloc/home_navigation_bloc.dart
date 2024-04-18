import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_navigation_event.dart';
part 'home_navigation_state.dart';

class HomeNavigationBloc
    extends Bloc<HomeNavigationEvent, HomeNavigationState> {
  HomeNavigationBloc(super.state) {
    on<HomeNavigationStateChanged>(_handleStateChanged);
  }

  void _handleStateChanged(
    HomeNavigationStateChanged event,
    Emitter<HomeNavigationState> emit,
  ) {
    log('home_navigation_bloc ${event.scaffoldMap}');
    emit(state.copyWith(scaffoldMap: event.scaffoldMap));
  }
}
