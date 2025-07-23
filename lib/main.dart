import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'dart:io';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'dependency_injection.dart';
import 'presentation/screens/auth/signin_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/navigation/main_navigation_wrapper.dart';
import 'presentation/theme/app_theme.dart';

// SSL bypass for development
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // In debug mode, allow all SSL certificates (for development only)
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }

  await dotenv.load(fileName: ".env");

  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      debug: kDebugMode,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Supabase initialization error: $e');
    }
    // Continue app initialization even if Supabase fails
    // The app should handle offline/connection issues gracefully
  }

  configureDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => getIt<ProfileBloc>()),
      ],
      child: const Sportefy(),
    ),
  );
}

class Sportefy extends StatelessWidget {
  const Sportefy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sportefy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const MainNavigationWrapper(),
      },
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Debug: Auth state changed to $state
          if (state is Authenticated) {
            return const MainNavigationWrapper();
          } else if (state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading...'),
                  ],
                ),
              ),
            );
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}
