const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    std.debug.print("Hello World\n", .{});

    const libdir = try std.fs.cwd().openDir("./zig-out/lib/", .{});
    const fname = try libdir.realpathAlloc(allocator, "libhello_cart.so");
    defer allocator.free(fname);

    std.debug.print("{s}\n", .{fname});

    var lib = try std.DynLib.open(fname);
    defer lib.close();

    const add_fn = lib.lookup(*fn (a: i32, b: i32) callconv(.C) i32, "add");

    if (add_fn == null) {
        std.debug.print("Could not load function\n", .{});
        return;
    }

    const result = add_fn.?(5, 3);

    std.debug.print("Result: {}\n", .{result});
}
