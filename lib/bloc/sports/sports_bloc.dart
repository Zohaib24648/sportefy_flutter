import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repository/i_sports_repository.dart';
import 'sports_event.dart';
import 'sports_state.dart';

@injectable
class SportsBloc extends Bloc<SportsEvent, SportsState> {
  final ISportsRepository _sportsRepository;

  SportsBloc(this._sportsRepository) : super(const SportsInitial()) {
    on<LoadSports>(_onLoadSports);
    on<RefreshSports>(_onRefreshSports);
  }

  Future<void> _onLoadSports(
    LoadSports event,
    Emitter<SportsState> emit,
  ) async {
    // Don't emit loading if we already have data (cache)
    if (state is! SportsLoaded) {
      emit(const SportsLoading());
    }

    try {
      final sports = await _sportsRepository.getSports();
      emit(SportsLoaded(sports));
    } catch (e) {
      emit(SportsError(e.toString()));
    }
  }

  Future<void> _onRefreshSports(
    RefreshSports event,
    Emitter<SportsState> emit,
  ) async {
    emit(const SportsLoading());
    try {
      final sports = await _sportsRepository.getSports();
      emit(SportsLoaded(sports));
    } catch (e) {
      emit(SportsError(e.toString()));
    }
  }
}
