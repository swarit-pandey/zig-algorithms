const std = @import("std");

pub fn heapSort(arr: []i32) void {
    const n = arr.len;
    if (n <= 1) {
        return;
    }

    var i = n / 2 - 1;
    while (i >= 0) : (i -= 1) {
        heapify(arr, n, i);
        if (i == 0) break;
    }

    i = n - 1;
    while (i > 0) : (i -= 1) {
        std.mem.swap(i32, &arr[0], &arr[i]);
        heapify(arr, i, 0);
    }
}

fn heapify(arr: []i32, heapSize: usize, rootIndex: usize) void {
    var largest = rootIndex;
    const left = 2 * rootIndex + 1; // left = 2*i + 1
    const right = 2 * rootIndex + 2; // right = 2*i + 2

    if (left < heapSize and arr[left] > arr[largest]) {
        largest = left;
    }

    if (right < heapSize and arr[right] > arr[largest]) {
        largest = right;
    }

    if (largest != rootIndex) {
        std.mem.swap(i32, &arr[rootIndex], &arr[largest]);
        heapify(arr, heapSize, largest);
    }
}

test "heapSort with a single element array" {
    var arr: [1]i32 = [_]i32{42};
    heapSort(arr[0..]);
    try std.testing.expectEqualSlices(i32, &[_]i32{42}, arr[0..]);
}

test "heapSort with a multi-element array" {
    var arr: [6]i32 = [_]i32{ 3, 1, 4, 1, 5, 9 };
    heapSort(arr[0..]);
    try std.testing.expectEqualSlices(i32, &[_]i32{ 1, 1, 3, 4, 5, 9 }, arr[0..]);
}

test "heapSort with a reverse sorted array" {
    var arr: [5]i32 = [_]i32{ 5, 4, 3, 2, 1 };
    heapSort(arr[0..]);
    try std.testing.expectEqualSlices(i32, &[_]i32{ 1, 2, 3, 4, 5 }, arr[0..]);
}
