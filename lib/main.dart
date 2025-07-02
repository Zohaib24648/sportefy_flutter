//lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportefy/presentation/constants/app_colors.dart';
import 'package:sportefy/presentation/screens/auth/signin_screen.dart';
import 'package:sportefy/presentation/screens/auth/signup_screen.dart';

import 'bloc/auth/auth_bloc.dart';
import 'data/repository/auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Sportefy());
}

class Sportefy extends StatelessWidget {
  const Sportefy({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (context) => AuthRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: AppColors.backgroundColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
            ),
          ),
          home: const SignUpScreen(),
          routes: {
            '/signup': (context) => const SignUpScreen(),
            '/signin': (context) => const SignInScreen(),
          },
        ),
      ),
    );
  }
}
