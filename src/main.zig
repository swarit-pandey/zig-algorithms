const std = @import("std");
const insertionSort = @import("algorithms/sorting/insertion.zig").insertionSort;

pub fn main() !void {
    var arr = [_]i32{ 10, 4, 1, 5, 9, 2, 6 }; // Example array
    insertionSort(&arr);
    std.debug.print("Sorted array: {any}\n", .{arr});
}
