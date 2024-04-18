import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_scaffold_event.dart';
part 'home_scaffold_state.dart';

final class HomeScaffoldBloc
    extends Bloc<HomeScaffoldEvent, HomeScaffoldState> {
  HomeScaffoldBloc(super.state) {
    on<HomeScaffoldChanged>(_handleStateChanged);
  }

  void _handleStateChanged(
    HomeScaffoldChanged event,
    Emitter<HomeScaffoldState> emit,
  ) {
    emit(state.copyWith(scaffoldMap: event.scaffoldMap));
  }
}
