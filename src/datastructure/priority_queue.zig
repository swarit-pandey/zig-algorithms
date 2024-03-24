const std = @import("std");

pub fn PriorityQueue(comptime T: type) type {
    return struct {
        heap: std.ArrayList(T),
        comparator: fn (a: T, b: T) bool,

        pub fn init(allocator: std.mem.Allocator, comparator: fn (a: T, b: T) bool) !PriorityQueue(T) {
            return PriorityQueue(T){
                .heap = std.ArrayList(T).init(allocator), // Corrected from .bool to .heap
                .comparator = comparator,
            };
        }

        pub fn deinit(self: *PriorityQueue(T)) void {
            self.heap.deinit(); // Call deinit on the ArrayList to free memory
        }

        pub fn enqueue(self: *PriorityQueue(T), item: T) !void {
            try self.heap.append(item);
            var i = self.heap.len - 1;
            while (i > 0) {
                const parent = (i - 1) / 2;
                if (self.comparator(self.heap.items[parent], self.heap.items[i])) break;
                std.mem.swap(T, &self.heap.items[i], &self.heap.items[parent]);
                i = parent;
            }
        }

        pub fn dequeue(self: *PriorityQueue(T)) ?T {
            if (self.heap.capacity == 0) return null;
            std.mem.swap(T, &self.heap.items[0], &self.heap.items[self.heap.capacity - 1]);
            const result = self.heap.pop();

            var i: usize = 0;
            while (true) {
                const left = 2 * i + 1;
                const right = 2 * i + 2;
                var largest = i;
                if (left < self.heap.capacity and self.comparator(self.heap.items[largest], self.heap.items[left])) {
                    largest = left;
                }

                if (right < self.heap.capacity and self.comparator(self.heap.items[largest], self.heap.items[right])) {
                    largest = right;
                }

                if (largest == i) break;
                std.mem.swap(T, &self.heap.items[i], &self.heap.items[largest]);
                i = largest;
            }

            return result;
        }
    };
}

fn intComparator(a: i32, b: i32) bool {
    return a < b;
}

test "PriorityQueue enqueue and dequeue" {
    const allocator = std.heap.page_allocator;
    var pq = try PriorityQueue(i32).init(allocator, intComparator);
    defer pq.deinit();

    try pq.enqueue(10);
    try pq.enqueue(5);
    try pq.enqueue(20);

    const first = pq.dequeue() orelse unreachable;
    const second = pq.dequeue() orelse unreachable;
    const third = pq.dequeue() orelse unreachable;

    try std.testing.expectEqual(first, 20);
    try std.testing.expectEqual(second, 10);
    try std.testing.expectEqual(third, 5);
}
