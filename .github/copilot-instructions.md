# Sportefy - GitHub Copilot Instructions

## Project Overview

Sportefy is a Flutter sports facility management app with features for venue discovery, booking, QR check-ins, and user management. The app follows Clean Architecture principles with BLoC state management, communicates with a NestJS backend via REST APIs, and uses Supabase exclusively for authentication.

## Architecture & Dependencies

**State Management**: BLoC pattern with `flutter_bloc` - each feature has its own bloc in `lib/bloc/`
**Dependency Injection**: GetIt + Injectable - register services in `lib/core/`, configure in `dependency_injection.dart`
**Navigation**: Bottom tab navigation with screen caching in `MainNavigationWrapper`
**API Communication**: Dio HTTP client with auth interceptor for token management
**Authentication**: Supabase Auth only - no other Supabase features used

## Key Development Patterns

### BLoC Structure

```dart
// Always inject via GetIt in screens/widgets
BlocProvider(
  create: (context) => getIt<VenueBloc>()..add(LoadVenues()),
  child: VenueScreen(),
)
```

### API Services Pattern

- Repository pattern: Interface in `data/repository/i_*.dart`, implementation in `data/repository/*.dart`
- API services in `data/services/` use Dio directly with standardized error handling
- All services are `@injectable` and registered automatically

### Loading States

**Always use shimmer effects** - never CircularProgressIndicator:

```dart
// Import barrel file for consistency
import '../common/shimmer_exports.dart';

// Use in loading states
AppShimmer(child: YourWidget())
```

### Authentication Flow

- `AuthBloc` handles all auth state, listens to Supabase auth changes
- `TokenManager` centrally manages access tokens and session validation
- `AuthInterceptor` automatically adds tokens to API requests (skips public endpoints)

## Performance Optimizations

**Image Handling**: Use `cached_network_image` with configured cache limits (100 images, 50MB)
**Scroll Performance**: Pre-configured physics and cache extent in `PerformanceConfig`
**Memory**: Screen caching in navigation wrapper, `RepaintBoundary` for complex widgets

## Essential Files & Commands

### Key Configuration Files

- `lib/dependency_injection.dart` - DI setup, run `flutter packages pub run build_runner build` after changes
- `lib/core/network_module.dart` - Dio configuration with base URL from `.env`
- `flutter_native_splash.yaml` - Splash screen config, run `dart run flutter_native_splash:create`

### Development Workflow

```bash
# Code generation (after adding @injectable services)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Environment setup
# Ensure .env file exists with API_BASE_URL

# Run app with performance monitoring
flutter run --enable-software-rendering  # for performance debugging
```

### Common Issues

- **SSL in development**: `MyHttpOverrides` class bypasses certificate validation
- **Auth token refresh**: Handled automatically by `AuthInterceptor` and `TokenManager`
- **State persistence**: Use screen caching pattern in navigation wrapper for performance

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
