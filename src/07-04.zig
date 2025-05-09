const std = @import("std");

var n: u8 = 0;

fn incr() void {
    n = n + 1;
}

var once_incr = std.once(incr);

fn onceIncr() void {
    // The invocations of `call` are thread-safe.
    once_incr.call();
    once_incr.call();
}

pub fn main() !void {
    {
        const t1 = try std.Thread.spawn(.{}, onceIncr, .{});
        defer t1.join();
        const t2 = try std.Thread.spawn(.{}, onceIncr, .{});
        defer t2.join();
    }

    try std.testing.expectEqual(1, n);
}
