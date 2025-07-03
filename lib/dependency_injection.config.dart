// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sportefy/bloc/auth/auth_bloc.dart' as _i633;
import 'package:sportefy/core/app_module.dart' as _i893;
import 'package:sportefy/data/repository/auth_repository.dart' as _i109;
import 'package:sportefy/data/repository/i_auth_repository.dart' as _i577;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.singleton<_i454.GoTrueClient>(() => appModule.supabaseAuth);
    gh.factory<_i577.IAuthRepository>(() => _i109.AuthRepository());
    gh.factory<_i633.AuthBloc>(
      () => _i633.AuthBloc(gh<_i577.IAuthRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i893.AppModule {}
