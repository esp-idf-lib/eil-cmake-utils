# eil-cmake-utils

A helper `cmake` utilities for `esp-idf-lib`.

## Usage

TBW

## Testing

The project uses a custom test runner implemented in `tests/runner.cmake`.
This script automatically discovers and executes all tests located in the
`tests/` directory.

To run all tests:

```console
cmake -P tests/runner.cmake
```

To run a test:
```console
cmake -P tests/foo_test.cmake
```
