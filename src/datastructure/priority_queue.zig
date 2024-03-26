const std = @import("std");

pub fn PriorityQueue(comptime T: type, comptime comparator: fn (a: T, b: T) bool) type {
    return struct {
        heap: std.ArrayList(T),

        pub fn init(allocator: std.mem.Allocator) !PriorityQueue(T, comparator) {
            return PriorityQueue(T, comparator){
                .heap = std.ArrayList(T).init(allocator),
            };
        }

        pub fn deinit(self: *PriorityQueue(T, comparator)) void {
            self.heap.deinit();
        }

        pub fn enqueue(self: *PriorityQueue(T, comparator), item: T) !void {
            try self.heap.append(item);
            var i = self.heap.items.len - 1;
            while (i > 0 and comparator(self.heap.items[(i - 1) / 2], self.heap.items[i])) {
                std.mem.swap(T, &self.heap.items[i], &self.heap.items[(i - 1) / 2]);
                i = (i - 1) / 2;
            }
        }

        pub fn dequeue(self: *PriorityQueue(T, comparator)) ?T {
            if (self.heap.items.len == 0) return null;
            std.mem.swap(T, &self.heap.items[0], &self.heap.items[self.heap.items.len - 1]);
            const result = self.heap.pop();
            var i: usize = 0;
            while (true) {
                const left = 2 * i + 1;
                const right = 2 * i + 2;
                var largest = i;
                if (left < self.heap.items.len and comparator(self.heap.items[largest], self.heap.items[left])) {
                    largest = left;
                }
                if (right < self.heap.items.len and comparator(self.heap.items[largest], self.heap.items[right])) {
                    largest = right;
                }
                if (largest == i) break;
                std.mem.swap(T, &self.heap.items[i], &self.heap.items[largest]);
                i = largest;
            }
            return result;
        }

        pub fn peek(self: *PriorityQueue(T, comparator)) ?T {
            if (self.heap.items.len == 0) return null;
            return self.heap.items[0];
        }

        pub fn clear(self: *PriorityQueue(T, comparator)) void {
            self.heap.clearRetainingCapacity();
        }
    };
}

fn intComparator(a: i32, b: i32) bool {
    return a < b;
}

test "PriorityQueue enqueue and dequeue" {
    const allocator = std.heap.page_allocator;
    var pq = try PriorityQueue(i32, intComparator).init(allocator);
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
