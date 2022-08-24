import 'package:demo/blocs/views_bloc/current_view.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class ViewsBloc {
  const ViewsBloc._({
    required this.goToView,
    required this.currentView,
  });

  final Sink<CurrentView> goToView;
  final Stream<CurrentView> currentView;

  factory ViewsBloc() {
    final goToViewSubject = BehaviorSubject<CurrentView>();
    return ViewsBloc._(
      goToView: goToViewSubject,
      currentView: goToViewSubject.startWith(CurrentView.login),
    );
  }

  void dispose() {
    goToView.close();
  }
}
