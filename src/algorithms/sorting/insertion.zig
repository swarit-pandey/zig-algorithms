const std = @import("std");

pub fn insertionSort(arr: []i32) void {
    for (arr[1..]) |value, i| {
        var j: usize = i;
        while (j >= 0 and arr[j] > value) {
            arr[j + 1] = arr[j];
            j -= 1;
        }
        arr[j + 1] = value;
    }
}

test "insertion sort" {
    var arr = [_]i32{ 5, 2, 4, 6, 1, 3 };
    insertionSort(&arr);
    std.testing.expectEqualSlices(i32, &[_]i32{ 1, 2, 3, 4, 5, 6 }, &arr);
}
