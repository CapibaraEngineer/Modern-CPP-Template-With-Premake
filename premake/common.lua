-- Shared build settings for every project in this workspace.
-- Keeps premake5.lua small and guarantees new projects created by
-- configure.sh behave identically.
--
-- Usage in premake5.lua:
--   include "common.lua"
--   project("MyApp")
--     location(rootDir .. "build/MyApp")
--     kind("ConsoleApp")
--     common_settings(rootDir)

function common_settings(rootDir)
    language("C++")
    cppdialect("C++23")
    warnings("Extra")
    staticruntime("on")
    exceptionhandling("Default")
    rtti("On")

    targetdir(rootDir .. "bin/%{prj.name}/%{cfg.system}_%{cfg.architecture}/%{cfg.buildcfg}")
    objdir(rootDir .. "build/obj/%{prj.name}/%{cfg.system}_%{cfg.architecture}/%{cfg.buildcfg}")

    -- Named modules (.cppm) need explicit modules support on GCC/Clang.
    -- Without this, any .cppm file fails with
    -- "'module' does not name a type ... only available with '-fmodules'".
    filter("toolset:gcc or toolset:clang")
        buildoptions({ "-fmodules" })

    filter("configurations:Debug")
        runtime("Debug")
        defines({ "DEBUG" })
        linktimeoptimization("off")
        optimize("off")
        symbols("full")

    filter("configurations:Release")
        runtime("Release")
        defines({ "NDEBUG" })
        linktimeoptimization("on")
        optimize("on")
        symbols("off")

    -- System libraries commonly needed on Linux (harmless if unused).
    filter("system:linux")
        links({ "pthread", "dl", "m" })

    filter({})
end
