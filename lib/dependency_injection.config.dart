// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sportefy/bloc/auth/auth_bloc.dart' as _i633;
import 'package:sportefy/bloc/check_in/check_in_bloc.dart' as _i686;
import 'package:sportefy/bloc/connectivity/connectivity_bloc.dart' as _i203;
import 'package:sportefy/bloc/history/history_bloc.dart' as _i63;
import 'package:sportefy/bloc/profile/profile_bloc.dart' as _i812;
import 'package:sportefy/bloc/qr/qr_bloc.dart' as _i328;
import 'package:sportefy/bloc/search/search_bloc.dart' as _i308;
import 'package:sportefy/bloc/slot/slot_bloc.dart' as _i430;
import 'package:sportefy/bloc/sports/sports_bloc.dart' as _i113;
import 'package:sportefy/bloc/venue/venue_bloc.dart' as _i937;
import 'package:sportefy/bloc/venue_details/venue_details_bloc.dart' as _i110;
import 'package:sportefy/core/app_module.dart' as _i893;
import 'package:sportefy/core/auth/token_manager.dart' as _i730;
import 'package:sportefy/core/interceptors/auth_interceptor.dart' as _i872;
import 'package:sportefy/core/network_module.dart' as _i186;
import 'package:sportefy/core/services/connectivity_service.dart' as _i306;
import 'package:sportefy/data/repository/auth_repository.dart' as _i109;
import 'package:sportefy/data/repository/history_repository.dart' as _i948;
import 'package:sportefy/data/repository/i_auth_repository.dart' as _i577;
import 'package:sportefy/data/repository/i_history_repository.dart' as _i527;
import 'package:sportefy/data/repository/i_profile_repository.dart' as _i411;
import 'package:sportefy/data/repository/i_slot_repository.dart' as _i506;
import 'package:sportefy/data/repository/i_sports_repository.dart' as _i227;
import 'package:sportefy/data/repository/i_venue_repository.dart' as _i828;
import 'package:sportefy/data/repository/profile_repository.dart' as _i432;
import 'package:sportefy/data/repository/slot_repository.dart' as _i155;
import 'package:sportefy/data/repository/sports_repository.dart' as _i671;
import 'package:sportefy/data/repository/venue_repository.dart' as _i482;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i328.QrBloc>(() => _i328.QrBloc());
    gh.factory<_i308.SearchBloc>(() => _i308.SearchBloc());
    gh.singleton<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.singleton<_i454.GoTrueClient>(() => appModule.supabaseAuth);
    gh.singleton<_i306.ConnectivityService>(() => _i306.ConnectivityService());
    gh.factory<_i203.ConnectivityBloc>(
      () => _i203.ConnectivityBloc(gh<_i306.ConnectivityService>()),
    );
    gh.factory<_i527.IHistoryRepository>(() => _i948.HistoryRepository());
    gh.factory<_i577.IAuthRepository>(() => _i109.AuthRepository());
    gh.factory<_i686.CheckInBloc>(
      () => _i686.CheckInBloc(gh<_i527.IHistoryRepository>()),
    );
    gh.factory<_i63.HistoryBloc>(
      () => _i63.HistoryBloc(gh<_i527.IHistoryRepository>()),
    );
    gh.factory<_i633.AuthBloc>(
      () => _i633.AuthBloc(gh<_i577.IAuthRepository>()),
    );
    gh.factory<_i730.TokenManager>(
      () => _i730.TokenManager(gh<_i577.IAuthRepository>()),
    );
    gh.factory<_i872.AuthInterceptor>(
      () => _i872.AuthInterceptor(gh<_i730.TokenManager>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i872.AuthInterceptor>()),
    );
    gh.lazySingleton<_i506.ISlotRepository>(
      () => _i155.SlotRepository(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i227.ISportsRepository>(
      () => _i671.SportsRepository(gh<_i361.Dio>()),
    );
    gh.factory<_i430.SlotBloc>(
      () => _i430.SlotBloc(gh<_i506.ISlotRepository>()),
    );
    gh.lazySingleton<_i828.IVenueRepository>(
      () => _i482.VenueRepository(gh<_i361.Dio>()),
    );
    gh.factory<_i411.IProfileRepository>(
      () => _i432.ProfileRepository(gh<_i361.Dio>()),
    );
    gh.factory<_i937.VenueBloc>(
      () => _i937.VenueBloc(gh<_i828.IVenueRepository>()),
    );
    gh.factory<_i110.VenueDetailsBloc>(
      () => _i110.VenueDetailsBloc(gh<_i828.IVenueRepository>()),
    );
    gh.factory<_i113.SportsBloc>(
      () => _i113.SportsBloc(gh<_i227.ISportsRepository>()),
    );
    gh.factory<_i812.ProfileBloc>(
      () => _i812.ProfileBloc(gh<_i411.IProfileRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i893.AppModule {}

class _$NetworkModule extends _i186.NetworkModule {}
