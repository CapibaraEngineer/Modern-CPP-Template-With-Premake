# A Modern C++ Template for Projects with Premake

Minimal C++23 + Premake 5 template: one app project, one separate tests
project, shared build settings, and small helper scripts. Public domain
(see `LICENSE`).

## Layout

```text
.
├── ProjectName/            # template app (rename via configure.sh)
│   ├── include/example.hpp # example header (declares add())
│   ├── modules/example.cppm# example named module (dependency-free)
│   └── source/             # main.cpp + example.cpp
├── tests/                  # separate ProjectNameTests binary (no framework)
│   └── test_example.cpp
├── premake/
│   ├── premake5.lua        # workspace + ProjectName + ProjectNameTests
│   └── common.lua          # shared settings (C++23, warnings, Debug/Release)
├── bin/                    # compiled binaries (ignored by git)
├── build/                  # generated makefiles + objects (ignored by git)
├── configure.sh            # rename workspace/projects, add new projects
├── build.sh                # premake5 gmake + make wrapper
└── clean.sh                # remove build/ and bin/ contents
```

Per-project source split: `include/` public headers, `modules/` `.cppm`
named modules, `source/` implementation + `main.cpp`. Shared test suite
lives in top-level `tests/` so the app keeps a single `main()`.

## Prerequisites

- `premake5` 5.0.0-beta8+ (`premake5 --version`), see `premake/README.md`.
- GCC 14+ or Clang 17+ with C++23 support, plus `make`.
- Optional: `bear`/`compiledb` for `compile_commands.json` (clangd),
  `clang-format`, `clang-tidy`.

## Quickstart

```sh
./configure.sh   # 1. rename ProjectName, 2. set workspace + startproject,
                 # 3. optionally add more projects (ConsoleApp/StaticLib/SharedLib)
./build.sh       # Debug build (or ./build.sh Release, ./build.sh --cc=clang)
./clean.sh       # wipe build/ and bin/ contents
```

Run the results (paths contain `<system>_<arch>/<Config>`):

```sh
./bin/ProjectName/linux_x86_64/Debug/ProjectName
./bin/ProjectNameTests/linux_x86_64/Debug/ProjectNameTests
```

## Build details

- Workspace `location` is `build/` — generated makefiles stay out of the
  source tree. Binaries go to `bin/<Proj>/...`, objects to
  `build/obj/<Proj>/...` (see `common_settings()` in `premake/common.lua`).
- Every project gets: `C++23`, `warnings "Extra"`, `staticruntime "on"`,
  Debug (`DEBUG`, no optimize, full symbols) / Release (`NDEBUG`, LTO +
  optimize, no symbols), `-fmodules` on GCC/Clang (required for `.cppm`),
  Linux links `pthread dl m`.
- Tests: `ProjectNameTests` is a second `ConsoleApp` compiling
  `tests/**` plus the shared non-`main` sources
  (`source/example.cpp`, `include/example.hpp`, `modules/example.cppm`).
  It is dependency-free — just `[PASS]/[FAIL]` lines and a non-zero exit
  on failure. Swap in Catch2/doctest later if you like.
- Modules note: `modules/example.cppm` deliberately avoids `import std;`
  (needs a prebuilt `std.gcm`). Once your toolchain provides it, you can
  switch the global-fragment `#include` to `import std;`. Note: Premake's
  `gmake` backend currently ignores `.cppm` files (app/tests still build
  from `.cpp`/`.hpp`); VS/Ninja handle them. Validate the module alone
  with `g++ -std=c++23 -fmodules -fsyntax-only ProjectName/modules/example.cppm`.

## Adding projects

Re-run `./configure.sh` and answer `y` at `Create another project?`.
It creates `Name/{include,modules,source}/` and appends a block using
`common_settings(rootDir)` — no duplicated Debug/Release filters.

## Hygiene

- `.gitignore` covers `bin/`, `build/`, VS/make artifacts, `gcm.cache/`.
- `.editorconfig`, `.clang-format` (LLVM, 4-space, 100 col),
  `.clang-tidy` (diagnostic/analyzer/modernize/readability/performance/bugprone).
- `clang-format -i` / `clang-tidy` your sources before committing.

## License

Unlicense — public domain, see `LICENSE`.
