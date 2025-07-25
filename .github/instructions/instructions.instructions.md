---
applyTo: "**"
---

projectContext:
description: |
This project uses Flutter as the frontend framework, with BLoC for state management, Dio for network requests, and GetIt for dependency injection. Supabase is used exclusively for authentication. The backend is a NestJS service exposed via RESTful APIs. Shimmer effects are used for loading indicators only. All generated code should follow the principles of clarity, minimalism, and functional necessity.

codingGuidelines:

- Do not write unnecessary conditions, classes, or functions.
- All code must be concise, direct, and complete without over-engineering.
- Use BLoC for state management, and structure bloc files with minimal boilerplate.
- Use Dio directly for API calls with simple try-catch or `.catchError` handling if needed.
- Supabase should be used only for authentication—no other functionality is allowed via Supabase.
- Use GetIt (`locator`) for injecting blocs, repositories, and services.
- Display loading states using shimmer effects; no spinners or alternative loaders.
- Avoid helper functions unless reuse has already occurred.
- Avoid multi-level nesting and excessive abstraction in both UI and logic layers.
- Use BlocBuilder/BlocListener only where UI needs to change based on bloc state.
- No future-proofing, placeholder code, or overly generic abstractions.
- UI code must be clean and minimal, with no wrapping widgets unless necessary.
- No code should be written "just in case"—everything must be essential to the feature being implemented.

reviewGuidelines:

- Flag any bloated logic, unused abstractions, or over-complicated widget trees.
- Reject any helper/service/repository unless it’s used immediately and improves clarity.
- Highlight nested UI or conditional logic that can be flattened or simplified.
- Enforce use of shimmer where loading indicators are needed; no CircularProgressIndicator.
- Ensure dependency injection is done only via GetIt and not passed manually unless required for testability.
