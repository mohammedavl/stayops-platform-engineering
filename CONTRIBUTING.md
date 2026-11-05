# Contributing and Change Validation

Clarity and reproducibility matter more than volume.

- Explain the operational problem or learning objective.
- Keep changes small and reviewable.
- Never commit credentials, personal data, or private infrastructure details.
- Label design, simulation, and tested implementation accurately.
- Runnable labs need setup, validation, and teardown instructions.
- Capture evidence with sensitive values redacted.

Before committing: validate YAML/Markdown, run relevant tests/lint, inspect `git diff` for secrets/generated files, and record expected results and limitations.

Evidence should state environment/version, commands, expected/actual result, edge cases, evidence path, and cleanup.