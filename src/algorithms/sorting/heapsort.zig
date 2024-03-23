const std = @import("std");

pub fn heapSort(arr: []i32) void {
    var n = arr.len;

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
    var left = 2 * rootIndex + 1; // left = 2*i + 1
    var right = 2 * rootIndex + 2; // right = 2*i + 2

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
