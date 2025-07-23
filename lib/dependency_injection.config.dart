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
import 'package:sportefy/bloc/facility/facility_bloc.dart' as _i743;
import 'package:sportefy/bloc/facility_details/facility_details_bloc.dart'
    as _i205;
import 'package:sportefy/bloc/history/history_bloc.dart' as _i63;
import 'package:sportefy/bloc/profile/profile_bloc.dart' as _i812;
import 'package:sportefy/bloc/qr/qr_bloc.dart' as _i328;
import 'package:sportefy/core/app_module.dart' as _i893;
import 'package:sportefy/core/interceptors/auth_interceptor.dart' as _i872;
import 'package:sportefy/core/network_module.dart' as _i186;
import 'package:sportefy/core/services/connectivity_service.dart' as _i306;
import 'package:sportefy/data/repository/auth_repository.dart' as _i109;
import 'package:sportefy/data/repository/facility_repository.dart' as _i133;
import 'package:sportefy/data/repository/history_repository.dart' as _i948;
import 'package:sportefy/data/repository/i_auth_repository.dart' as _i577;
import 'package:sportefy/data/repository/i_facility_repository.dart' as _i826;
import 'package:sportefy/data/repository/i_history_repository.dart' as _i527;
import 'package:sportefy/data/repository/i_profile_repository.dart' as _i411;
import 'package:sportefy/data/repository/profile_repository.dart' as _i432;
import 'package:sportefy/data/services/auth_state_manager.dart' as _i81;
import 'package:sportefy/data/services/profile_api_service.dart' as _i272;
import 'package:sportefy/data/services/secure_storage_service.dart' as _i691;
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
    gh.singleton<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.singleton<_i454.GoTrueClient>(() => appModule.supabaseAuth);
    gh.singleton<_i306.ConnectivityService>(() => _i306.ConnectivityService());
    gh.singleton<_i691.SecureStorageService>(
      () => _i691.SecureStorageService(),
    );
    gh.factory<_i203.ConnectivityBloc>(
      () => _i203.ConnectivityBloc(gh<_i306.ConnectivityService>()),
    );
    gh.factory<_i527.IHistoryRepository>(() => _i948.HistoryRepository());
    gh.factory<_i577.IAuthRepository>(
      () => _i109.AuthRepository(gh<_i691.SecureStorageService>()),
    );
    gh.factory<_i686.CheckInBloc>(
      () => _i686.CheckInBloc(gh<_i527.IHistoryRepository>()),
    );
    gh.factory<_i63.HistoryBloc>(
      () => _i63.HistoryBloc(gh<_i527.IHistoryRepository>()),
    );
    gh.factory<_i872.AuthInterceptor>(
      () => _i872.AuthInterceptor(gh<_i691.SecureStorageService>()),
    );
    gh.factory<_i633.AuthBloc>(
      () => _i633.AuthBloc(gh<_i577.IAuthRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i872.AuthInterceptor>()),
    );
    gh.lazySingleton<_i826.IFacilityRepository>(
      () => _i133.FacilityRepository(gh<_i361.Dio>()),
    );
    gh.factory<_i272.ProfileApiService>(
      () => _i272.ProfileApiService(gh<_i361.Dio>()),
    );
    gh.singleton<_i81.AuthStateManager>(
      () => _i81.AuthStateManager(
        gh<_i577.IAuthRepository>(),
        gh<_i691.SecureStorageService>(),
      ),
    );
    gh.factory<_i743.FacilityBloc>(
      () => _i743.FacilityBloc(gh<_i826.IFacilityRepository>()),
    );
    gh.factory<_i205.FacilityDetailsBloc>(
      () => _i205.FacilityDetailsBloc(gh<_i826.IFacilityRepository>()),
    );
    gh.factory<_i411.IProfileRepository>(
      () => _i432.ProfileRepository(gh<_i272.ProfileApiService>()),
    );
    gh.factory<_i812.ProfileBloc>(
      () => _i812.ProfileBloc(gh<_i411.IProfileRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i893.AppModule {}

class _$NetworkModule extends _i186.NetworkModule {}
