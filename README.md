# A Modern C++ Template for Projects with Premake

A Mininal template for C++23 projects with Premake, a easy starting point.
I built this mostly for personal use, but feel free to open an issue or pull request. I appreciate feedback.
Unlicense

## Layout

```text
.
├── ProjectName/             # template app (rename via configure.sh)
│   ├── include/example.hpp  # example header (declares add())
│   ├── modules/example.cppm # example named module (dependency-free)
│   └── source/              # main.cpp + example.cpp
├── tests/                   # separate ProjectNameTests binary (no framework)
│   └── test_example.cpp  
├── premake/                   
│   ├── premake5.lua         # workspace + ProjectName + ProjectNameTests
│   └── common.lua           # shared settings (C++23, warnings, Debug/Release/Sanitize)
├── bin/                     # compiled binaries (ignored by git)
├── build/                   # generated makefiles + objects (ignored by git)
├── configure.sh             # rename workspace/projects, add new projects
├── cleanup_template.sh      # one-shot template strip (self-deletes)
├── build.sh                 # premake5 gmake + make wrapper
├── test.sh                  # build + run all *Tests binaries
└── clean.sh                 # remove build/ and bin/ contents
```

source code split per project: `include/` public headers, `modules/` `.cppm` named modules, `source/` implementation + `main.cpp`. 
Shared test suite lives in top-level `tests/` so the app keeps a single `main()`.

## Prerequisites

- `premake5` 5.0.0-beta8+ (`premake5 --version`), see `premake/README.md`.
- Clang 17+ (default) or GCC 14+ with C++23 support, plus `ninja`
  (`--gmake` falls back to GNU make).
- Optional: `bear` for `compile_commands.json` (clangd),
  `clang-format`, `clang-tidy`.

## Quickstart
Once you copy the template yo ucan run two shell script for setting it up.

### `./configure.sh`
- Rename ProjectName;
- Set workspace and startproject
- Optionally add more projects (ConsoleApp/StaticLib/SharedLib)

### `./cleanup_template.sh`
Cleans the template stuff, README, examples, and then self deletes along with configure.sh
Run this after configure.sh

## Utilitary Scripts
The templates comes with 3 useful scripts 
### `./build.sh`
build the project, default to clang + ninja in Debug build.
run build.sh Release for release build, -cc=gcc for gcc, --gmake for gmake
### `./test.sh`
Build and runa tests in debug build, run ./test.sh Sanitize for Sanitize build
### `./clean.sh`
Empty build/ and bin/

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
  optimize, no symbols) / Sanitize (like Debug + ASan/UBSan;
  needs the sanitizer runtimes, e.g. `sudo dnf install libasan libubsan`),
  `-fmodules` on GCC/Clang (required for `.cppm`),
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
`common_settings(rootDir)` — no duplicated per-config filters.

## Hygiene

- `.gitignore` covers `bin/`, `build/`, VS/make artifacts, `gcm.cache/`.
- `.editorconfig`, `.clang-format` (LLVM, tabs width 4, 100 col),
  `.clang-tidy` (diagnostic/analyzer/modernize/readability/performance/bugprone).
- `clang-format -i` / `clang-tidy` your sources before committing.

## License

Unlicense — public domain, see `LICENSE`.
