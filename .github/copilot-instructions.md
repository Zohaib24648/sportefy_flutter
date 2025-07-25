# Sportefy - GitHub Copilot Instructions

## Project Overview

Sportefy is a Flutter sports facility management app with features for venue discovery, booking, QR check-ins, and user management. The app follows Clean Architecture principles with BLoC state management, communicates with a NestJS backend via REST APIs, and uses Supabase exclusively for authentication.

## Architecture & Dependencies

**State Management**: BLoC pattern with `flutter_bloc` - each feature has its own bloc in `lib/bloc/` (auth, venue_details, facility, etc.)
**Dependency Injection**: GetIt + Injectable - all services auto-registered via `@injectable`, configure in `dependency_injection.dart`
**Navigation**: Bottom tab navigation with intelligent screen caching in `MainNavigationWrapper` - screens maintain state except QR scanner
**API Communication**: Single Dio instance with base URL from `.env`, global `AuthInterceptor` handles tokens automatically
**Authentication**: Supabase Auth only - reactive auth state via `AuthBloc` listening to Supabase auth stream changes

## Key Development Patterns

### BLoC Structure & Injection

```dart
// Always inject via GetIt in screens/widgets
BlocProvider(
  create: (context) => getIt<VenueBloc>()..add(LoadVenues()),
  child: VenueScreen(),
)

// MultiBlocProvider at app level for global state (AuthBloc, ProfileBloc)
// Feature-specific blocs injected at screen level
```

### Repository Pattern

- Interfaces: `data/repository/i_*.dart` define contracts
- Implementations: `data/repository/*.dart` with `@LazySingleton(as: Interface)`
- API services inject single Dio instance, handle standardized error responses
- All network calls return parsed model objects, never raw JSON

### Loading States - Shimmer Only

**Critical: Never use CircularProgressIndicator** - always shimmer effects:

```dart
// Import barrel file for consistency
import '../common/shimmer_exports.dart';

// Use in BLoC loading states
if (state is VenueLoading) AppShimmer(child: VenueCard())
```

### Screen Caching Pattern

`MainNavigationWrapper` pre-builds and caches screens (Home, Search, Profile, History) except QR scanner which rebuilds on each access for performance and camera resource management.

### Authentication Flow

- `AuthBloc` subscribes to Supabase auth stream changes, manages reactive auth state
- `TokenManager` handles access tokens and session validation
- `AuthInterceptor` auto-injects tokens (skips public endpoints like `/auth/*`)
- SSL bypassed in debug mode via `MyHttpOverrides` for development

## Essential Files & Commands

### Key Configuration Files

- `lib/dependency_injection.dart` - GetIt setup, run `flutter packages pub run build_runner build` after adding `@injectable`
- `lib/core/network_module.dart` - Single Dio instance with 15s timeouts, auth interceptor, debug logging
- `.env` - Contains `API_BASE_URL`, `SUPABASE_URL`, `SUPABASE_ANON_KEY` (loaded via dotenv)
- `lib/main.dart` - App initialization: Supabase setup, DI config, global BLoCs (Auth, Profile)

### Development Workflow

```bash
# Code generation after adding @injectable services or changing interfaces
flutter packages pub run build_runner build --delete-conflicting-outputs

# Splash screen generation after updating flutter_native_splash.yaml
dart run flutter_native_splash:create

# Run with performance monitoring
flutter run --enable-software-rendering
```

## Performance Optimizations

**Image Cache**: `PerformanceConfig.initialize()` sets 100 image cache, 50MB limit via `PaintingBinding`
**Scroll Performance**: Pre-configured `BouncingScrollPhysics` and 500px cache extent in `PerformanceConfig`
**Memory Management**: Navigation wrapper caches 4/5 screens, disposes QR scanner for camera resources
**Network**: 15s timeouts on Dio, request/response logging only in debug mode

### Common Issues & Patterns

- **QR Screen Strategy**: Never cache - rebuilds each access to properly initialize/dispose camera
- **Auth Token Refresh**: Automatic via `AuthInterceptor` and Supabase auth stream
- **SSL Development**: `MyHttpOverrides` bypasses certificates in debug mode only
- **State Persistence**: Use navigation caching pattern - screens survive tab switches

## Project-Specific Conventions

**Widget Organization**: Common widgets in `presentation/widgets/common/`, feature-specific in respective folders
**Error Handling**: Standardized Dio error handling in all API services with user-friendly messages
**Barrel Exports**: Use `shimmer_exports.dart` pattern for related widget collections
**Minimalist Approach**: No helper functions unless already reused, no over-abstraction

## Integration Points

**Backend API**: NestJS service at configured base URL, all endpoints require auth except public ones
**Supabase**: Auth-only integration via `SupabaseClient`, no database or storage features
**Google Maps**: Integrated for venue location features via `google_maps_flutter`
**QR Scanning**: `mobile_scanner` package for check-in functionality
