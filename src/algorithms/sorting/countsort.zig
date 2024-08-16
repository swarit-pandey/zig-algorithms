const std = @import("std");
const testing = std.testing;

/// Counting Sort Algorithm
///
/// This function implements the counting sort algorithm, which is an integer sorting
/// algorithm that operates by counting the number of objects that possess distinct
/// key values, and applying prefix sum on those counts to determine the positions
/// of each key value in the output sequence.
///
/// How it works:
/// 1. Find the maximum value in the input array to determine the size of the count array.
/// 2. Initialize a count array with zeros, where the index represents the value and
///    the element at that index represents how many times that value appears.
/// 3. Iterate through the input array and increment the count for each value.
/// 4. Modify the count array to store the actual position of each element in the output array:
///    each element becomes the sum of itself and all previous elements.
/// 5. Build the output array:
///    a. Iterate through the input array from right to left.
///    b. Look up the position for each element in the count array.
///    c. Place the element in the output array at that position.
///    d. Decrement the count for that element.
///
/// Example:
/// Let's sort the array [4, 2, 2, 8, 3, 3, 1]
///
/// Step 1: Find max value (8)
///
/// Step 2: Initialize count array of size 9 (0 to 8) with zeros
/// count = [0, 0, 0, 0, 0, 0, 0, 0, 0]
///
/// Step 3: Count occurrences
/// count = [0, 1, 2, 2, 1, 0, 0, 0, 1]
///
/// Step 4: Calculate cumulative count
/// count = [0, 1, 3, 5, 6, 6, 6, 6, 7]
///
/// Step 5: Build output array
/// - Start from the end: 1 (count[1] = 1, place at index 0)
/// - Next: 3 (count[3] = 5, place at index 4)
/// - Next: 3 (count[3] = 4, place at index 3)
/// - Continue this process...
///
/// Final sorted array: [1, 2, 2, 3, 3, 4, 8]
///
/// Time Complexity: O(n + k) where n is the number of elements and k is the range of input
/// Space Complexity: O(n + k) for the output and count arrays
///
/// Note: This implementation assumes non-negative integer inputs.
pub fn countsort(allocator: std.mem.Allocator, arr: []u32) ![]u32 {
    if (arr.len == 0) return &[_]u32{};

    // Step 1: Find the maximum element from the given array
    const max = getMax: {
        var maxVal: u32 = arr[0];
        for (arr[1..]) |elem| {
            if (elem > maxVal) maxVal = elem;
        }
        break :getMax maxVal;
    };

    // Step 2: Create an array of size max and then init all the elements to 0
    var countArray = try allocator.alloc(u32, max + 1);
    defer allocator.free(countArray);
    @memset(countArray, 0);

    // Step 3: Fill the countArray with count of specific elements, just like hashing
    for (arr) |elem| {
        countArray[elem] += 1;
    }

    // Step 4: Now we get the cumulative count
    for (countArray[1..], 0..) |*v, i| {
        v.* += countArray[i];
    }

    // Step 5: Building the output array
    var output = try allocator.alloc(u32, arr.len);
    var i: usize = arr.len;
    while (i > 0) {
        i -= 1;
        output[countArray[arr[i]] - 1] = arr[i];
        countArray[arr[i]] -= 1;
    }

    return output;
}

test "countsort" {
    const allocator = std.testing.allocator;
    var input = [_]u32{ 6, 8, 4, 3, 2, 10, 13, 1 };
    const expected = [_]u32{ 1, 2, 3, 4, 6, 8, 10, 13 };

    const result = try countsort(allocator, &input);
    defer allocator.free(result);

    try testing.expectEqualSlices(u32, &expected, result);
}
