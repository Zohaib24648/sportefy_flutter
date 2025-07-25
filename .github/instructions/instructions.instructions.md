---
applyTo: "**"
---

projectContext:
description: |
Sportefy is a Flutter application for sports facility management that follows Clean Architecture. All mutable state flows through BLoC; manual widget‑level state manipulation is forbidden so behaviour remains deterministic and data flow stays uniform. Dio manages HTTP communication; Supabase provides authentication only; GetIt with Injectable resolves dependencies. The NestJS backend exposes REST endpoints; shimmer effects serve as the sole loading indicator. A strict widget hierarchy is enforced: reusable view logic lives in the `widgets/` tree, never inside `screens/`; screens assemble those widgets like Lego blocks. Common, cross‑feature widgets reside in `widgets/common/`; feature‑specific widgets live in their own `widgets/<feature>/` folders. No custom themes or styles are defined inside `screens/`, and layout code belongs exclusively in widgets. Every contribution must value clarity, brevity, and functional necessity; redundant abstractions and speculative code are not accepted.

codingGuidelines:

- Prefer single‑purpose files and functions; avoid needless branching or deep nesting.
- Route every dynamic behaviour through BLoC events and states; reuse bloc instances whenever practical to prevent duplicate network calls.
- Cache network responses and images aggressively with tools such as cached_network_image and bloc‑retained memory; invalidate caches only when business rules demand it.
- Configure Dio with one base client; global interceptors handle authentication, error mapping, and logging; never create ad hoc clients.
- Supabase is limited to sign‑in, sign‑up, and token refresh; all data operations pass through backend APIs.
- Inject dependencies only through GetIt; never create services inside widgets.
- Use shimmer loaders for all pending states; spinners, progress bars, or placeholder text are disallowed.
- Build UI layouts by composition: create small, reusable widgets and place them under `widgets/common/` if shared across features, or under `widgets/<feature>/` if local to a feature.
- Never declare themes, colours, or text styles inside `screens/`; styles belong in dedicated theme files or inside reusable widgets.
- Screens serve purely as orchestrators: they arrange pre‑built widgets and dispatch bloc events, without business logic or styling.
- Publish code that compiles and runs; include imports, annotations, and build_runner outputs when required.
- Respect Dart analysis rules; format with `dart format`; document public APIs with concise comments.

reviewGuidelines:

- Reject code that uses setState, ValueNotifier, ChangeNotifier, or similar patterns.
- Flag duplicate paths, unused abstractions, or overly nested structures; suggest consolidation.
- Verify bloc state reuse instead of repeated fetches; confirm effective caching.
- Disallow CircularProgressIndicator or LinearProgressIndicator; require shimmering loaders.
- Ensure every service and bloc is registered in `dependency_injection.dart` and retrieved through GetIt.
- Check that no widget contains ad hoc themes or styles; styles must be centralised and reusable.
- Confirm screens contain only widget composition and event dispatch; no business logic, no inline styling.
- Keep each file under two hundred lines unless splitting harms cohesion, and ensure common widgets live in `widgets/common/`.
