const std = @import("std");

const Game = struct {
    id: u8,
    maxRed: u32 = 0,
    maxGreen: u32 = 0,
    maxBlue: u32 = 0,
};

const MaxRed = 12;
const MaxGreen = 13;
const MaxBlue = 14;

pub fn run() !void {
    std.log.default.info("--- Day 2 ---", .{});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    var inputText = try std.fs.cwd().readFileAlloc(alloc, "./src/day2/input.txt", 1024 * 64);
    var it = std.mem.tokenizeAny(u8, inputText, "\n");

    var games = std.ArrayList(Game).init(alloc);
    var validGames = std.ArrayList(Game).init(alloc);

    var id: u8 = 0;
    while (it.next()) |line| {
        id += 1;
        const game = try parseGame(line, id);
        try games.append(game);

        // Filter for valid games for part 1
        if (game.maxRed <= MaxRed and game.maxGreen <= MaxGreen and game.maxBlue <= MaxBlue) {
            try validGames.append(game);
        }
    }

    // Part 1
    var sumOfIds: u16 = 0;
    for (validGames.items) |value| {
        sumOfIds += value.id;
    }

    // Part 2
    var powerSum: u32 = 0;
    for (games.items) |value| {
        powerSum += value.maxRed * value.maxGreen * value.maxBlue;
    }

    std.log.default.info("Part 1: {}", .{sumOfIds});
    std.log.default.info("Part 2: {}", .{powerSum});
    std.log.default.info("-------------\n", .{});
}

// This isn't a pretty solution, but it works
fn parseGame(gameString: []const u8, gameId: u8) !Game {
    var numberString: [3]u8 = [_]u8{ '0', '0', '0' };
    var maxRed: ?u8 = null;
    var maxGreen: ?u8 = null;
    var maxBlue: ?u8 = null;

    for (gameString, 0..) |char, i| {
        numberString = [_]u8{ '0', '0', '0' };
        var numberLength: u8 = 0;

        if (char >= '0' and char <= '9') {
            numberString[2] = char;
            numberLength = 1;
            if (gameString[i + 1] >= '0' and gameString[i + 1] <= '9') {
                numberString[2] = gameString[i + 1];
                numberString[1] = char;
                numberLength = 2;
                if (gameString[i + 2] >= '0' and gameString[i + 2] <= '9') {
                    numberString[0] = gameString[i + 2];
                    numberString[2] = gameString[i + 1];
                    numberString[1] = char;
                    numberLength = 3;
                }
            }
        }

        if (numberLength != 0) {
            if (std.mem.startsWith(u8, gameString[(i + numberLength)..], " red")) {
                const number = try std.fmt.parseInt(u8, &numberString, 10);
                if (maxRed == null or maxRed.? < number) {
                    maxRed = number;
                }
            }
            if (std.mem.startsWith(u8, gameString[(i + numberLength)..], " green")) {
                const number = try std.fmt.parseInt(u8, &numberString, 10);
                if (maxGreen == null or maxGreen.? < number) {
                    maxGreen = number;
                }
            }
            if (std.mem.startsWith(u8, gameString[(i + numberLength)..], " blue")) {
                const number = try std.fmt.parseInt(u8, &numberString, 10);
                if (maxBlue == null or maxBlue.? < number) {
                    maxBlue = number;
                }
            }
        }
    }

    return Game{
        .id = gameId,
        .maxRed = maxRed orelse 0,
        .maxGreen = maxGreen orelse 0,
        .maxBlue = maxBlue orelse 0,
    };
}
