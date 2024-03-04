const std = @import("std");

pub fn main() !void {
    std.debug.print("Hello, {s}!\n", .{"World from zig compiler"});

    const vector = [_]u8{ 'a', 'b', 'c' };
    std.debug.print("Length: {}\n", .{vector.len});

    var new_vec: [3]u8 = [3]u8{ 'a', 'b', 'c' };
    std.debug.print("Length of the new vec: {}\n", .{new_vec.len});

    var num: u8 = 24;
    if (num % 2 == 0) {
        std.debug.print("This is even: {}\n", .{num});
    } else {
        std.debug.print("This is odd: {}\n", .{num});
    }

    const limit: u8 = 100;
    var num_new: u8 = 1;
    while (num_new <= limit) : (num_new += 1) {
        if (num_new % 2 == 0) {
            std.debug.print("this is even: {}\n", .{num_new});
        } else {
            std.debug.print("this is odd: {}\n", .{num_new});
        }
    }

    const items = [_]i32{ 23, 12, 3, 4, 3, 56, 98, 32, 12, 19 };
    var max: i32 = 0;
    for (items) |elements| {
        if (elements > max) {
            max = elements;
        }
    }
    std.debug.print("Max element is: {}\n", .{max});

    // Iterating over slices
    for (items) |elements, index| {
        std.debug.print("element: {} | index: {}\n", .{ elements, index });
    }
}
