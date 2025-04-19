const std = @import("std");

pub fn main() void {
    var args = std.process.args();
    const name = args.next() orelse {
        std.debug.print("Error: Missing name argument.\n", .{});
        return;
    };
    const count_str = args.next() orelse {
        std.debug.print("Error: Missing count argument.\n", .{});
        return;
    const count = std.fmt.parseInt(u32, count_str, 10) catch |err| {
        std.debug.print("Error: Invalid count argument. {}\n", .{err});
        return;
    };

    const stdout = std.io.getStdOut().writer();
    var index: u32 = 0;

    while (index < count) {
        const result = stdout.print("hello, {}\n", .{name});
        index += 1;
    }
}
