const std = @import("std");

pub fn run() !void {
    std.log.default.info("--- Day 1 ---", .{});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var inputText = try std.fs.cwd().readFileAlloc(alloc, "./src/day1/input.txt", 1024 * 64);
    var it = std.mem.tokenizeAny(u8, inputText, "\n");

    var sumPart1: u32 = 0;
    var sumPart2: u32 = 0;

    while (it.next()) |line| {
        sumPart1 += part1(line);
        sumPart2 += part2(line);
    }

    std.log.default.info("Part 1: {}", .{sumPart1});
    std.log.default.info("Part 2: {}", .{sumPart2});
    std.log.default.info("-------------\n", .{});
}

fn part1(line: []const u8) u8 {
    var firstDigit: ?u8 = null;
    var secondDigit: ?u8 = null;

    for (line) |char| {
        if (char < '0' or char > '9') {
            continue;
        }
        const digit: ?u8 = char - '0';

        if (firstDigit == null) {
            firstDigit = digit;
        }
        secondDigit = digit;
    }

    return 10 * firstDigit.? + secondDigit.?;
}

const ValidDigits = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

fn part2(line: []const u8) u8 {
    var firstDigit: ?u8 = null;
    var secondDigit: ?u8 = null;

    for (line, 0..) |char, i| {
        var digit: ?u8 = null;
        if (char >= '0' and char <= '9') {
            digit = char - '0';
        } else {
            for (ValidDigits, 1..) |validDigit, d| {
                if (std.mem.startsWith(u8, line[i..], validDigit)) {
                    digit = @intCast(d);
                }
            }
        }

        if (digit) |d| {
            _ = d;
            if (firstDigit == null) {
                firstDigit = digit;
            }
            secondDigit = digit;
        }
    }

    return 10 * firstDigit.? + secondDigit.?;
}
