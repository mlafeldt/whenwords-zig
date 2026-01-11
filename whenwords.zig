const std = @import("std");

pub const WhenwordsError = error{
    InvalidTimestamp,
    InvalidDuration,
    InvalidDurationString,
};

pub const DurationOptions = struct {
    compact: bool = false,
    max_units: usize = 2,
};

const Unit = struct {
    singular: []const u8,
    plural: []const u8,
    compact: []const u8,
    seconds: i64,
};

const units = [_]Unit{
    .{ .singular = "year", .plural = "years", .compact = "y", .seconds = 31_536_000 },
    .{ .singular = "month", .plural = "months", .compact = "mo", .seconds = 2_592_000 },
    .{ .singular = "day", .plural = "days", .compact = "d", .seconds = 86_400 },
    .{ .singular = "hour", .plural = "hours", .compact = "h", .seconds = 3_600 },
    .{ .singular = "minute", .plural = "minutes", .compact = "m", .seconds = 60 },
    .{ .singular = "second", .plural = "seconds", .compact = "s", .seconds = 1 },
};

const month_names = [_][]const u8{
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
};

const weekday_names = [_][]const u8{
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
};

pub fn timeago(allocator: std.mem.Allocator, timestamp: anytype, reference: anytype) ![]u8 {
    const ts = try normalizeTimestamp(timestamp);
    const ref_ts = try normalizeTimestamp(reference);
    const diff = ref_ts - ts;
    const future = diff < 0;
    const abs_diff = if (diff < 0) -diff else diff;

    if (abs_diff < 45) {
        return allocator.dupe(u8, "just now");
    }

    var count: i64 = 0;
    var unit_singular: []const u8 = "second";
    var unit_plural: []const u8 = "seconds";

    if (abs_diff < 90) {
        count = 1;
        unit_singular = "minute";
        unit_plural = "minutes";
    } else if (abs_diff < 45 * 60) {
        count = roundHalfUp(abs_diff / 60.0);
        unit_singular = "minute";
        unit_plural = "minutes";
    } else if (abs_diff < 90 * 60) {
        count = 1;
        unit_singular = "hour";
        unit_plural = "hours";
    } else if (abs_diff < 22 * 3600) {
        count = roundHalfUp(abs_diff / 3600.0);
        unit_singular = "hour";
        unit_plural = "hours";
    } else if (abs_diff < 36 * 3600) {
        count = 1;
        unit_singular = "day";
        unit_plural = "days";
    } else if (abs_diff < 26 * 86400) {
        count = roundHalfUp(abs_diff / 86400.0);
        unit_singular = "day";
        unit_plural = "days";
    } else if (abs_diff < 46 * 86400) {
        count = 1;
        unit_singular = "month";
        unit_plural = "months";
    } else if (abs_diff < 320 * 86400) {
        count = roundHalfUp(abs_diff / 2_628_000.0);
        unit_singular = "month";
        unit_plural = "months";
    } else if (abs_diff < 548 * 86400) {
        count = 1;
        unit_singular = "year";
        unit_plural = "years";
    } else {
        count = roundHalfUp(abs_diff / 31_536_000.0);
        unit_singular = "year";
        unit_plural = "years";
    }

    const unit = if (count == 1) unit_singular else unit_plural;
    if (future) {
        return std.fmt.allocPrint(allocator, "in {d} {s}", .{ count, unit });
    }
    return std.fmt.allocPrint(allocator, "{d} {s} ago", .{ count, unit });
}

pub fn duration(allocator: std.mem.Allocator, seconds_input: anytype, options: ?DurationOptions) ![]u8 {
    const total_seconds = try normalizeDurationSeconds(seconds_input);

    const opts = options orelse DurationOptions{};
    if (opts.max_units == 0) return error.InvalidDuration;

    if (total_seconds == 0) {
        if (opts.compact) return allocator.dupe(u8, "0s");
        return allocator.dupe(u8, "0 seconds");
    }

    var counts: [units.len]i64 = .{0} ** units.len;
    var remaining = total_seconds;
    for (units, 0..) |unit, idx| {
        const unit_seconds = @as(f64, @floatFromInt(unit.seconds));
        const value = @floor(remaining / unit_seconds);
        counts[idx] = @intFromFloat(value);
        remaining -= value * unit_seconds;
    }

    var display_indices = std.ArrayList(usize){};
    defer display_indices.deinit(allocator);

    for (counts, 0..) |count, idx| {
        if (count > 0) try display_indices.append(allocator, idx);
    }

    if (display_indices.items.len == 0) {
        if (opts.compact) return allocator.dupe(u8, "0s");
        return allocator.dupe(u8, "0 seconds");
    }

    if (display_indices.items.len > opts.max_units) {
        const last_idx = display_indices.items[opts.max_units - 1];
        var idx_after = last_idx + 1;
        while (idx_after < units.len) : (idx_after += 1) {
            counts[idx_after] = 0;
        }
    }

    var parts = std.ArrayList(u8){};
    errdefer parts.deinit(allocator);
    var writer = parts.writer(allocator);

    var emitted: usize = 0;
    for (units, 0..) |unit, idx| {
        if (counts[idx] == 0) continue;
        if (emitted == opts.max_units) break;
        if (emitted > 0) {
            if (opts.compact) {
                try writer.writeAll(" ");
            } else {
                try writer.writeAll(", ");
            }
        }
        if (opts.compact) {
            try writer.print("{d}{s}", .{ counts[idx], unit.compact });
        } else {
            const label = if (counts[idx] == 1) unit.singular else unit.plural;
            try writer.print("{d} {s}", .{ counts[idx], label });
        }
        emitted += 1;
    }

    return parts.toOwnedSlice(allocator);
}

pub fn parse_duration(input: []const u8) !i64 {
    const trimmed = std.mem.trim(u8, input, " \t\r\n");
    if (trimmed.len == 0) return error.InvalidDurationString;

    if (isColonFormat(trimmed)) {
        return parseColonFormat(trimmed);
    }

    var i: usize = 0;
    var total_seconds: f64 = 0;
    var found = false;

    while (i < trimmed.len) {
        const ch = trimmed[i];
        if (std.ascii.isWhitespace(ch) or ch == ',') {
            i += 1;
            continue;
        }

        if (isAndWord(trimmed, i)) {
            i += 3;
            continue;
        }

        if (ch == '-') return error.InvalidDurationString;

        if (!std.ascii.isDigit(ch) and ch != '.') return error.InvalidDurationString;

        const number_start = i;
        var seen_dot = false;
        while (i < trimmed.len) : (i += 1) {
            const c = trimmed[i];
            if (std.ascii.isDigit(c)) continue;
            if (c == '.' and !seen_dot) {
                seen_dot = true;
                continue;
            }
            break;
        }
        const number_slice = trimmed[number_start..i];
        if (number_slice.len == 0) return error.InvalidDurationString;
        const value = std.fmt.parseFloat(f64, number_slice) catch return error.InvalidDurationString;
        if (value < 0) return error.InvalidDurationString;

        while (i < trimmed.len and std.ascii.isWhitespace(trimmed[i])) : (i += 1) {}

        const unit_start = i;
        while (i < trimmed.len and std.ascii.isAlphabetic(trimmed[i])) : (i += 1) {}
        const unit_slice = trimmed[unit_start..i];
        if (unit_slice.len == 0) return error.InvalidDurationString;

        const unit_seconds = unitSeconds(unit_slice) orelse return error.InvalidDurationString;
        total_seconds += value * @as(f64, @floatFromInt(unit_seconds));
        found = true;
    }

    if (!found) return error.InvalidDurationString;
    if (total_seconds < 0) return error.InvalidDurationString;

    return roundHalfUp(total_seconds);
}

pub fn human_date(allocator: std.mem.Allocator, timestamp: anytype, reference: anytype) ![]u8 {
    const ts = try normalizeTimestampInt(timestamp);
    const ref_ts = try normalizeTimestampInt(reference);

    const ts_day = divFloor(ts, 86_400);
    const ref_day = divFloor(ref_ts, 86_400);
    const diff_days = ts_day - ref_day;

    if (diff_days == 0) return allocator.dupe(u8, "Today");
    if (diff_days == -1) return allocator.dupe(u8, "Yesterday");
    if (diff_days == 1) return allocator.dupe(u8, "Tomorrow");

    if (diff_days < 0 and diff_days >= -6) {
        const weekday = weekdayName(ts_day);
        return std.fmt.allocPrint(allocator, "Last {s}", .{weekday});
    }

    if (diff_days > 0 and diff_days <= 6) {
        const weekday = weekdayName(ts_day);
        return std.fmt.allocPrint(allocator, "This {s}", .{weekday});
    }

    const ts_date = civilFromDays(ts_day);
    const ref_date = civilFromDays(ref_day);

    if (ts_date.year == ref_date.year) {
        return std.fmt.allocPrint(allocator, "{s} {d}", .{ month_names[@intCast(ts_date.month - 1)], ts_date.day });
    }

    return std.fmt.allocPrint(
        allocator,
        "{s} {d}, {d}",
        .{ month_names[@intCast(ts_date.month - 1)], ts_date.day, ts_date.year },
    );
}

pub fn date_range(allocator: std.mem.Allocator, start_input: anytype, end_input: anytype) ![]u8 {
    var start_ts = try normalizeTimestampInt(start_input);
    var end_ts = try normalizeTimestampInt(end_input);

    if (start_ts > end_ts) {
        const tmp = start_ts;
        start_ts = end_ts;
        end_ts = tmp;
    }

    const start_day = divFloor(start_ts, 86_400);
    const end_day = divFloor(end_ts, 86_400);

    const start_date = civilFromDays(start_day);
    const end_date = civilFromDays(end_day);

    if (start_day == end_day) {
        return std.fmt.allocPrint(
            allocator,
            "{s} {d}, {d}",
            .{ month_names[@intCast(start_date.month - 1)], start_date.day, start_date.year },
        );
    }

    if (start_date.year == end_date.year and start_date.month == end_date.month) {
        return std.fmt.allocPrint(
            allocator,
            "{s} {d}–{d}, {d}",
            .{ month_names[@intCast(start_date.month - 1)], start_date.day, end_date.day, start_date.year },
        );
    }

    if (start_date.year == end_date.year) {
        return std.fmt.allocPrint(
            allocator,
            "{s} {d} – {s} {d}, {d}",
            .{ month_names[@intCast(start_date.month - 1)], start_date.day, month_names[@intCast(end_date.month - 1)], end_date.day, start_date.year },
        );
    }

    return std.fmt.allocPrint(
        allocator,
        "{s} {d}, {d} – {s} {d}, {d}",
        .{ month_names[@intCast(start_date.month - 1)], start_date.day, start_date.year, month_names[@intCast(end_date.month - 1)], end_date.day, end_date.year },
    );
}

fn normalizeTimestamp(value: anytype) !f64 {
    const T = @TypeOf(value);
    switch (@typeInfo(T)) {
        .int => return @as(f64, @floatFromInt(value)),
        .comptime_int => return @as(f64, value),
        .float => {
            if (!std.math.isFinite(value)) return error.InvalidTimestamp;
            return value;
        },
        .comptime_float => return @as(f64, value),
        .pointer => |ptr| {
            if (ptr.size == .Slice and ptr.child == u8) {
                const slice: []const u8 = value;
                const seconds = try parseIso8601(slice);
                return @as(f64, @floatFromInt(seconds));
            }
            return error.InvalidTimestamp;
        },
        else => return error.InvalidTimestamp,
    }
}

fn normalizeTimestampInt(value: anytype) !i64 {
    const seconds = try normalizeTimestamp(value);
    return @as(i64, @intFromFloat(@floor(seconds)));
}

fn normalizeDurationSeconds(value: anytype) !f64 {
    const T = @TypeOf(value);
    switch (@typeInfo(T)) {
        .int => {
            if (value < 0) return error.InvalidDuration;
            return @as(f64, @floatFromInt(value));
        },
        .comptime_int => {
            if (value < 0) return error.InvalidDuration;
            return @as(f64, value);
        },
        .float => {
            if (!std.math.isFinite(value) or value < 0) return error.InvalidDuration;
            return value;
        },
        .comptime_float => {
            if (value < 0) return error.InvalidDuration;
            return @as(f64, value);
        },
        else => return error.InvalidDuration,
    }
}

fn roundHalfUp(value: f64) i64 {
    if (value >= 0) return @as(i64, @intFromFloat(@floor(value + 0.5)));
    return -@as(i64, @intFromFloat(@floor(-value + 0.5)));
}

fn isAndWord(input: []const u8, index: usize) bool {
    if (index + 3 > input.len) return false;
    if (!std.ascii.eqlIgnoreCase(input[index .. index + 3], "and")) return false;
    if (index > 0 and std.ascii.isAlphabetic(input[index - 1])) return false;
    if (index + 3 < input.len and std.ascii.isAlphabetic(input[index + 3])) return false;
    return true;
}

fn unitSeconds(unit: []const u8) ?i64 {
    if (std.ascii.eqlIgnoreCase(unit, "s") or
        std.ascii.eqlIgnoreCase(unit, "sec") or
        std.ascii.eqlIgnoreCase(unit, "secs") or
        std.ascii.eqlIgnoreCase(unit, "second") or
        std.ascii.eqlIgnoreCase(unit, "seconds"))
    {
        return 1;
    }

    if (std.ascii.eqlIgnoreCase(unit, "m") or
        std.ascii.eqlIgnoreCase(unit, "min") or
        std.ascii.eqlIgnoreCase(unit, "mins") or
        std.ascii.eqlIgnoreCase(unit, "minute") or
        std.ascii.eqlIgnoreCase(unit, "minutes"))
    {
        return 60;
    }

    if (std.ascii.eqlIgnoreCase(unit, "h") or
        std.ascii.eqlIgnoreCase(unit, "hr") or
        std.ascii.eqlIgnoreCase(unit, "hrs") or
        std.ascii.eqlIgnoreCase(unit, "hour") or
        std.ascii.eqlIgnoreCase(unit, "hours"))
    {
        return 3600;
    }

    if (std.ascii.eqlIgnoreCase(unit, "d") or
        std.ascii.eqlIgnoreCase(unit, "day") or
        std.ascii.eqlIgnoreCase(unit, "days"))
    {
        return 86_400;
    }

    if (std.ascii.eqlIgnoreCase(unit, "w") or
        std.ascii.eqlIgnoreCase(unit, "wk") or
        std.ascii.eqlIgnoreCase(unit, "wks") or
        std.ascii.eqlIgnoreCase(unit, "week") or
        std.ascii.eqlIgnoreCase(unit, "weeks"))
    {
        return 604_800;
    }

    return null;
}

fn isColonFormat(input: []const u8) bool {
    if (std.mem.indexOfScalar(u8, input, ':') == null) return false;
    for (input) |ch| {
        if (std.ascii.isDigit(ch) or ch == ':') continue;
        return false;
    }
    return true;
}

fn parseColonFormat(input: []const u8) !i64 {
    var parts_iter = std.mem.splitScalar(u8, input, ':');
    var parts: [3]i64 = .{ 0, 0, 0 };
    var count: usize = 0;
    while (parts_iter.next()) |part| {
        if (count >= 3) return error.InvalidDurationString;
        if (part.len == 0) return error.InvalidDurationString;
        const value = std.fmt.parseInt(i64, part, 10) catch return error.InvalidDurationString;
        if (value < 0) return error.InvalidDurationString;
        parts[count] = value;
        count += 1;
    }
    if (count == 2) {
        return parts[0] * 3600 + parts[1] * 60;
    }
    if (count == 3) {
        return parts[0] * 3600 + parts[1] * 60 + parts[2];
    }
    return error.InvalidDurationString;
}

const Date = struct {
    year: i32,
    month: u8,
    day: u8,
};

fn divFloor(a: i64, b: i64) i64 {
    return std.math.divFloor(i64, a, b) catch 0;
}

fn daysFromCivil(year: i32, month: u8, day: u8) i64 {
    var y: i64 = year;
    const m: i64 = month;
    const d: i64 = day;
    y -= if (m <= 2) 1 else 0;
    const era = if (y >= 0) @divFloor(y, 400) else @divFloor(y - 399, 400);
    const yoe = y - era * 400;
    const doy = @divFloor(153 * (m + (if (m > 2) -3 else 9)) + 2, 5) + d - 1;
    const doe = yoe * 365 + @divFloor(yoe, 4) - @divFloor(yoe, 100) + doy;
    return era * 146097 + doe - 719468;
}

fn civilFromDays(days: i64) Date {
    const z = days + 719468;
    const era = if (z >= 0) @divFloor(z, 146097) else @divFloor(z - 146096, 146097);
    const doe = z - era * 146097;
    const yoe = @divFloor(doe - @divFloor(doe, 1460) + @divFloor(doe, 36524) - @divFloor(doe, 146096), 365);
    var y = yoe + era * 400;
    const doy = doe - (365 * yoe + @divFloor(yoe, 4) - @divFloor(yoe, 100));
    const mp = @divFloor(5 * doy + 2, 153);
    const d = doy - @divFloor(153 * mp + 2, 5) + 1;
    const m = mp + (if (mp < 10) @as(i64, 3) else @as(i64, -9));
    y += if (m <= 2) 1 else 0;

    return .{
        .year = @intCast(y),
        .month = @intCast(m),
        .day = @intCast(d),
    };
}

fn weekdayName(days: i64) []const u8 {
    const idx = @as(usize, @intCast(@mod(days + 4, 7)));
    return weekday_names[idx];
}

fn parseIso8601(input: []const u8) !i64 {
    if (input.len < 10) return error.InvalidTimestamp;
    if (input[4] != '-' or input[7] != '-') return error.InvalidTimestamp;

    const year = std.fmt.parseInt(i32, input[0..4], 10) catch return error.InvalidTimestamp;
    const month = std.fmt.parseInt(u8, input[5..7], 10) catch return error.InvalidTimestamp;
    const day = std.fmt.parseInt(u8, input[8..10], 10) catch return error.InvalidTimestamp;

    if (month < 1 or month > 12) return error.InvalidTimestamp;
    const dim = daysInMonth(year, month);
    if (day < 1 or day > dim) return error.InvalidTimestamp;

    var hour: i64 = 0;
    var minute: i64 = 0;
    var second: i64 = 0;

    if (input.len > 10) {
        if (input.len < 19) return error.InvalidTimestamp;
        if (input[10] != 'T' and input[10] != 't') return error.InvalidTimestamp;
        if (input[13] != ':' or input[16] != ':') return error.InvalidTimestamp;
        hour = std.fmt.parseInt(i64, input[11..13], 10) catch return error.InvalidTimestamp;
        minute = std.fmt.parseInt(i64, input[14..16], 10) catch return error.InvalidTimestamp;
        second = std.fmt.parseInt(i64, input[17..19], 10) catch return error.InvalidTimestamp;

        const end_index: usize = 19;
        if (input.len > end_index) {
            if (input.len != 20) return error.InvalidTimestamp;
            if (input[end_index] != 'Z' and input[end_index] != 'z') return error.InvalidTimestamp;
        }

        if (hour < 0 or hour > 23) return error.InvalidTimestamp;
        if (minute < 0 or minute > 59) return error.InvalidTimestamp;
        if (second < 0 or second > 59) return error.InvalidTimestamp;
    }

    const days = daysFromCivil(year, month, day);
    return days * 86_400 + hour * 3600 + minute * 60 + second;
}

fn daysInMonth(year: i32, month: u8) u8 {
    return switch (month) {
        1, 3, 5, 7, 8, 10, 12 => 31,
        4, 6, 9, 11 => 30,
        2 => if (isLeapYear(year)) 29 else 28,
        else => 0,
    };
}

fn isLeapYear(year: i32) bool {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    return year % 4 == 0;
}
