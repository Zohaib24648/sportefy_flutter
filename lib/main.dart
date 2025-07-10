import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'bloc/auth/auth_bloc.dart';
import 'dependency_injection.dart';
import 'presentation/screens/auth/signin_screen.dart';
import 'presentation/screens/auth/signup_screen.dart';
import 'presentation/navigation/main_navigation_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  configureDependencies();

  runApp(
    BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
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
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const MainNavigationWrapper(),
      },
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          print('Main: Auth state changed to $state');
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
