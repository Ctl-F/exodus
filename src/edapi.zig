const std = @import("std");
const sdl = @cImport(@cInclude("SDL3/SDL.h"));

const exapi = @import("exodus.zig");

const LATEST_VERSION = exapi.Version{ .Major = 0, .Minor = 0, .Patch = 1 };

fn check_version_compat(version: exapi.Version, minimum: exapi.Version) bool {
    return version.Major <= minimum.Major and
        version.Minor <= minimum.Major and
        version.Patch <= minimum.Patch;
}

pub fn MakeContext(contextInfo: exapi.ContextCreateRequest) exapi.ApiInitError!exapi.Context {
    if (check_version_compat(contextInfo.version, LATEST_VERSION)) {
        return exapi.Context{};
    }
    // check other versions here
    return exapi.ApiInitError.VersionNotSupported;
}

pub fn impl_Init(info: exapi.InitInfo) callconv(.C) exapi.ApiInitError!void {}

pub fn impl_Shutdown() callconv(.C) void {}
