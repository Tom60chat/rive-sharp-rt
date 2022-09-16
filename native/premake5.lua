workspace "rive-cpp"

configurations {"Debug", "Release"}
platforms {"x86", "x64", "ARM64"}

-- Are we in the "rive-sharp" or "rive" repository?
local handle = io.popen("git remote -v")
local git_remote = handle:read("*a")
handle:close()
if string.find(git_remote, "rive%-sharp") then
    -- In rive-sharp. Rive runtime is a submodule.
    RIVE_RUNTIME_DIR = "../submodules/rive-cpp"
else
    -- In rive. Rive runtime is further up the tree.
    RIVE_RUNTIME_DIR = "../../runtime"
end

project "rive"
    kind "SharedLib"
    language "C++"
    cppdialect "C++17"
    toolset "clang"
    targetdir "bin/%{cfg.platform}/%{cfg.buildcfg}"
    objdir "obj/%{cfg.platform}/%{cfg.buildcfg}"
    staticruntime "off"  -- /MD for dll
    flags { "FatalWarnings" }
    includedirs {
        RIVE_RUNTIME_DIR .. "/include",
        "../../include",
    }
    files {
        RIVE_RUNTIME_DIR .. "/src/**.cpp",
        "RiveSharpInterop.cpp"
    }

    filter "configurations:Debug"
        defines {"DEBUG"}
        symbols "On"

    filter "configurations:Release"
        defines {"RELEASE"}
        defines {"NDEBUG"}
        optimize "On"

    filter "platforms:x86"
        architecture "x86"

    filter "platforms:x64"
        architecture "x64"

    filter "platforms:ARM64"
        architecture "ARM64"

    filter {}

    -- For future use: Compile in GMs
    -- newoption {
    --    trigger = "include-gms",
    --    description = "Include source files for Rive GMs"
    -- }
    --
    -- filter "options:include-gms"
    --     includedirs {
    --     }
    --     files {
    --     }
