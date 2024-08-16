const std = @import("std");
const testing = std.testing;

pub fn partition(arr: []i32, p: usize, r: usize) usize {
    const x = arr[r];
    var i = p;

    for (arr[p..r], p..r) |_, j| {
        if (arr[j] <= x) {
            std.mem.swap(i32, &arr[i], &arr[j]);
            i += 1;
        }
    }

    std.mem.swap(i32, &arr[i], &arr[r]);
    return i;
}

pub fn quicksort(arr: []i32, p: usize, r: usize) void {
    if (p < r) {
        const q = partition(arr, p, r);

        if (q > 0) {
            quicksort(arr, p, q - 1);
        }
        quicksort(arr, q + 1, r);
    }
}

test "quick sort" {
    var arr = [_]i32{ 5, 2, 4, 6, 1, 3 };
    quicksort(&arr, 0, arr.len - 1);
    try testing.expectEqual([_]i32{ 1, 2, 3, 4, 5, 6 }, arr);
}
