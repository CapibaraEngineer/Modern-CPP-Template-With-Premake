workspace ("ProjectName")
    location ("../")
    architecture ("x86_64")
    configurations {"Debug", "Release"}
    startproject ("ProjectName")

local rootDir = "../"
local projectNameDir = rootDir .. "ProjectName/"

project("ProjectName")
    location (projectNameDir)
    kind ("ConsoleApp")
    language ("C++")
    cppdialect "C++23"

    targetdir (rootDir .. "bin/ProjectName/%{cfg.system}_%{cfg.architecture}/%{cfg.buildcfg}")
    objdir (rootDir .. "bin/ProjectName/%{cfg.system}_%{cfg.architecture}/%{cfg.buildcfg}/obj")

    files {
        projectNameDir .. "**.cpp",
        projectNameDir .. "**.hpp",
        projectNameDir .. "**.cppm"
    }

    includedirs {
        projectNameDir .. "include",
        projectNameDir .. "modules",
        projectNameDir .. "source"
    }

    filter "configurations:Debug"
        runtime "Debug"
        defines {"DEBUG"}
        linktimeoptimization "off"
        optimize "off"
        symbols "full"

    filter "configurations:Release"
        runtime "Release"
        defines {"NDEBUG"}
        linktimeoptimization "on"
        optimize "on"
        symbols "off"

    filter {}
