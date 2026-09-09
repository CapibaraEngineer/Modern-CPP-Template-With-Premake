# Premake folder

Build scripts for [Premake 5](https://premake.github.io).

- `premake5.lua` — workspace (`ProjectName`), projects `ProjectName` (app)
  and `ProjectNameTests` (separate tests binary). Run `configure.sh` first to
  rename them.
- `common.lua` — shared settings used by every project: C++23, `warnings
  "Extra"`, Debug/Release flags, `targetdir` under `bin/`, `objdir` under
  `build/`, `-fmodules` for GCC/Clang (needed for `.cppm`), Linux system
  libs.

## Install premake5 (5.0.0-beta8 or newer)

- Fedora: `sudo dnf install premake` (if too old, download from GitHub).
- Manual: download `premake-5.0.0-beta8-linux.tar.gz` from
  https://github.com/premake-core/premake-core/releases, extract `premake5`
  to `~/.local/bin` and ensure it is on `PATH`.
- Check: `premake5 --version`.

## Generate + build (from repo root)

```sh
./build.sh            # Debug, default compiler
./build.sh Release    # Release
./build.sh --cc=clang # Clang instead of GCC
./clean.sh            # remove build/ and bin/ contents
```

What `build.sh` does:

```sh
premake5 --file=premake/premake5.lua gmake
make -C build config=debug_x86_64   # or release_x86_64
```

Binaries land in `bin/<ProjectName>/linux_x86_64/<Debug|Release>/`
(objects in `build/obj/...`, makefiles in `build/`).

## IDE / clangd notes

- VSCode + clangd: generate `compile_commands.json` with
  `bear -- ./build.sh` or `compiledb -n make -C build`, then point clangd
  at it. Premake's `gmake` action does not emit one itself.
- Visual Studio: `premake5 --file=premake/premake5.lua vs2022`
  (output goes to `build/` per `workspace.location`).
