const std = @import("std");

pub fn mergeSort(arr: []i32, temp: []i32, left: usize, right: usize) void {
    if (left >= right) {
        return;
    }

    const mid = (left + right) / 2;
    mergeSort(arr, temp, left, mid);
    mergeSort(arr, temp, mid + 1, right);
    merge(arr, temp, left, mid, right);
}

fn merge(arr: []i32, temp: []i32, left: usize, mid: usize, right: usize) void {
    var i: usize = left;
    var j: usize = mid + 1;
    var k: usize = left;

    while (i <= mid and j <= right) {
        if (arr[i] <= arr[j]) {
            temp[k] = arr[i];
            i += 1;
        } else {
            temp[k] = arr[j];
            j += 1;
        }
        k += 1;
    }

    while (i <= mid) {
        temp[k] = arr[i];
        i += 1;
        k += 1;
    }

    while (j <= right) {
        temp[k] = arr[j];
        j += 1;
        k += 1;
    }

    for (temp[left .. right + 1], 0..) |value, idx| {
        arr[left + idx] = value;
    }
}

test "mergeSort with an empty array" {
    const arr: []i32 = &[_]i32{};
    var temp: [0]i32 = undefined;
    if (arr.len > 0) {
        mergeSort(arr, temp[0..], 0, arr.len - 1);
    }
}

test "mergeSort with a single element array" {
    var arr: [1]i32 = [_]i32{42};
    var temp: [1]i32 = undefined;
    mergeSort(arr[0..], temp[0..], 0, arr.len - 1);
    try std.testing.expectEqualSlices(i32, &[_]i32{42}, arr[0..]);
}

test "mergeSort with an array of multiple elements" {
    var arr: [7]i32 = [_]i32{ 38, 27, 43, 3, 9, 82, 10 };
    var temp: [7]i32 = undefined;
    mergeSort(arr[0..], temp[0..], 0, arr.len - 1);
    try std.testing.expectEqualSlices(i32, &[_]i32{ 3, 9, 10, 27, 38, 43, 82 }, arr[0..]);
}

test "mergeSort with a reverse sorted array" {
    var arr: [5]i32 = [_]i32{ 5, 4, 3, 2, 1 };
    var temp: [5]i32 = undefined;
    mergeSort(arr[0..], temp[0..], 0, arr.len - 1);
    try std.testing.expectEqualSlices(i32, &[_]i32{ 1, 2, 3, 4, 5 }, arr[0..]); // Corrected.
}
