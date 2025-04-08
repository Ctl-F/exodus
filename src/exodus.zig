/// External Facing Api module
/// No actual implementation will be here
const std = @import("std");

pub const Version = extern struct {
    Major: c_uint,
    Minor: c_uint,
    Patch: c_uint,
};

pub const DisplayMode = enum(c_int) {
    Undefined = 0,
    FixedResolutionDirect,
    GraphicsAcceleratedSimple,
    GraphicsAcceleratedDirect,
};

pub const DisplaySettings = extern struct {
    width: c_uint,
    height: c_uint,
    mode: DisplayMode,
    vsync: bool,
    contextVersion: ?Version,
};

pub const InitInfo = extern struct {
    displaySettings: DisplaySettings,
    appTitle: [*c]const u8,
};

pub const ApiInitError = error{
    VersionNotSupported,
    GeneralInit,
    CreateWindow,
    ConfigureContext,
    AllocFramebuffers,
};

comptime {
    const errorInfo = @typeInfo(ApiInitError);
    for (errorInfo.error_set.?) |err| {
        const value = @intFromError(@field(ApiInitError, err.name));

        @export(value, .{
            .linkage = .strong,
            .name = "API_INIT_ERROR_" ++ err.name,
        });
    }
}

pub const Context = extern union {
    V010: struct {
        version: Version,
        init: *fn (info: InitInfo) callconv(.C) ApiInitError!void,
        shutdown: *fn () callconv(.C) void,
    },
};

pub const ContextPtr = *Version;

pub const ContextCreateRequest = extern struct {
    version: Version,
};
