const std = @import("std");
const whenwords = @import("whenwords.zig");

fn expectAnyError(result: anytype) !void {
    if (result) |_| {
        return error.ExpectedError;
    } else |_| {}
}
test "timeago: just now - identical timestamps" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067200, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("just now", result);
}

test "timeago: just now - 30 seconds ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067170, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("just now", result);
}

test "timeago: just now - 44 seconds ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067156, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("just now", result);
}

test "timeago: 1 minute ago - 45 seconds" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067155, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 minute ago", result);
}

test "timeago: 1 minute ago - 89 seconds" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067111, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 minute ago", result);
}

test "timeago: 2 minutes ago - 90 seconds" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067110, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2 minutes ago", result);
}

test "timeago: 30 minutes ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704065400, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("30 minutes ago", result);
}

test "timeago: 44 minutes ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704064560, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("44 minutes ago", result);
}

test "timeago: 1 hour ago - 45 minutes" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704064500, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 hour ago", result);
}

test "timeago: 1 hour ago - 89 minutes" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704061860, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 hour ago", result);
}

test "timeago: 2 hours ago - 90 minutes" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704061800, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2 hours ago", result);
}

test "timeago: 5 hours ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704049200, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("5 hours ago", result);
}

test "timeago: 21 hours ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1703991600, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("21 hours ago", result);
}

test "timeago: 1 day ago - 22 hours" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1703988000, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 day ago", result);
}

test "timeago: 1 day ago - 35 hours" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1703941200, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 day ago", result);
}

test "timeago: 2 days ago - 36 hours" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1703937600, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2 days ago", result);
}

test "timeago: 7 days ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1703462400, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("7 days ago", result);
}

test "timeago: 25 days ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1701907200, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("25 days ago", result);
}

test "timeago: 1 month ago - 26 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1701820800, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 month ago", result);
}

test "timeago: 1 month ago - 45 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1700179200, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 month ago", result);
}

test "timeago: 2 months ago - 46 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1700092800, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2 months ago", result);
}

test "timeago: 6 months ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1688169600, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("6 months ago", result);
}

test "timeago: 10 months ago - 319 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1676505600, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("10 months ago", result);
}

test "timeago: 1 year ago - 320 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1676419200, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 year ago", result);
}

test "timeago: 1 year ago - 547 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1656806400, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 year ago", result);
}

test "timeago: 2 years ago - 548 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1656720000, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2 years ago", result);
}

test "timeago: 5 years ago" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1546300800, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("5 years ago", result);
}

test "timeago: future - in just now (30 seconds)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067230, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("just now", result);
}

test "timeago: future - in 1 minute" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067260, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("in 1 minute", result);
}

test "timeago: future - in 5 minutes" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704067500, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("in 5 minutes", result);
}

test "timeago: future - in 1 hour" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704070200, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("in 1 hour", result);
}

test "timeago: future - in 3 hours" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704078000, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("in 3 hours", result);
}

test "timeago: future - in 1 day" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704150000, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("in 1 day", result);
}

test "timeago: future - in 2 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1704240000, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("in 2 days", result);
}

test "timeago: future - in 1 month" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1706745600, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("in 1 month", result);
}

test "timeago: future - in 1 year" {
    const allocator = std.testing.allocator;
    const result = try whenwords.timeago(allocator, 1735689600, 1704067200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("in 1 year", result);
}

test "duration: zero seconds" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 0, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("0 seconds", result);
}

test "duration: 1 second" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 1, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 second", result);
}

test "duration: 45 seconds" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 45, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("45 seconds", result);
}

test "duration: 1 minute" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 60, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 minute", result);
}

test "duration: 1 minute 30 seconds" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 90, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 minute, 30 seconds", result);
}

test "duration: 2 minutes" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 120, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2 minutes", result);
}

test "duration: 1 hour" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 3600, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 hour", result);
}

test "duration: 1 hour 1 minute" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 3661, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 hour, 1 minute", result);
}

test "duration: 1 hour 30 minutes" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 5400, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 hour, 30 minutes", result);
}

test "duration: 2 hours 30 minutes" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 9000, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2 hours, 30 minutes", result);
}

test "duration: 1 day" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 86400, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 day", result);
}

test "duration: 1 day 2 hours" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 93600, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 day, 2 hours", result);
}

test "duration: 7 days" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 604800, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("7 days", result);
}

test "duration: 1 month (30 days)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 2592000, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 month", result);
}

test "duration: 1 year (365 days)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 31536000, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 year", result);
}

test "duration: 1 year 2 months" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 36720000, null);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 year, 2 months", result);
}

test "duration: compact - 1h 1m" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 3661, whenwords.DurationOptions{ .compact = true });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1h 1m", result);
}

test "duration: compact - 2h 30m" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 9000, whenwords.DurationOptions{ .compact = true });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2h 30m", result);
}

test "duration: compact - 1d 2h" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 93600, whenwords.DurationOptions{ .compact = true });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1d 2h", result);
}

test "duration: compact - 45s" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 45, whenwords.DurationOptions{ .compact = true });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("45s", result);
}

test "duration: compact - 0s" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 0, whenwords.DurationOptions{ .compact = true });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("0s", result);
}

test "duration: max_units 1 - hours only" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 3661, whenwords.DurationOptions{ .max_units = 1 });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 hour", result);
}

test "duration: max_units 1 - days only" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 93600, whenwords.DurationOptions{ .max_units = 1 });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 day", result);
}

test "duration: max_units 3" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 93661, whenwords.DurationOptions{ .max_units = 3 });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("1 day, 2 hours, 1 minute", result);
}

test "duration: compact max_units 1" {
    const allocator = std.testing.allocator;
    const result = try whenwords.duration(allocator, 9000, whenwords.DurationOptions{ .compact = true, .max_units = 1 });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("2h", result);
}

test "duration: error - negative seconds" {
    const allocator = std.testing.allocator;
    try expectAnyError(whenwords.duration(allocator, -100, null));
}

test "parse_duration: compact hours minutes" {
    const result = try whenwords.parse_duration("2h30m");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: compact with space" {
    const result = try whenwords.parse_duration("2h 30m");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: compact with comma" {
    const result = try whenwords.parse_duration("2h, 30m");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: verbose" {
    const result = try whenwords.parse_duration("2 hours 30 minutes");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: verbose with and" {
    const result = try whenwords.parse_duration("2 hours and 30 minutes");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: verbose with comma and" {
    const result = try whenwords.parse_duration("2 hours, and 30 minutes");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: decimal hours" {
    const result = try whenwords.parse_duration("2.5 hours");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: decimal compact" {
    const result = try whenwords.parse_duration("1.5h");
    try std.testing.expectEqual(@as(i64, 5400), result);
}

test "parse_duration: single unit minutes verbose" {
    const result = try whenwords.parse_duration("90 minutes");
    try std.testing.expectEqual(@as(i64, 5400), result);
}

test "parse_duration: single unit minutes compact" {
    const result = try whenwords.parse_duration("90m");
    try std.testing.expectEqual(@as(i64, 5400), result);
}

test "parse_duration: single unit min" {
    const result = try whenwords.parse_duration("90min");
    try std.testing.expectEqual(@as(i64, 5400), result);
}

test "parse_duration: colon notation h:mm" {
    const result = try whenwords.parse_duration("2:30");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: colon notation h:mm:ss" {
    const result = try whenwords.parse_duration("1:30:00");
    try std.testing.expectEqual(@as(i64, 5400), result);
}

test "parse_duration: colon notation with seconds" {
    const result = try whenwords.parse_duration("0:05:30");
    try std.testing.expectEqual(@as(i64, 330), result);
}

test "parse_duration: days verbose" {
    const result = try whenwords.parse_duration("2 days");
    try std.testing.expectEqual(@as(i64, 172800), result);
}

test "parse_duration: days compact" {
    const result = try whenwords.parse_duration("2d");
    try std.testing.expectEqual(@as(i64, 172800), result);
}

test "parse_duration: weeks verbose" {
    const result = try whenwords.parse_duration("1 week");
    try std.testing.expectEqual(@as(i64, 604800), result);
}

test "parse_duration: weeks compact" {
    const result = try whenwords.parse_duration("1w");
    try std.testing.expectEqual(@as(i64, 604800), result);
}

test "parse_duration: mixed verbose" {
    const result = try whenwords.parse_duration("1 day, 2 hours, and 30 minutes");
    try std.testing.expectEqual(@as(i64, 95400), result);
}

test "parse_duration: mixed compact" {
    const result = try whenwords.parse_duration("1d 2h 30m");
    try std.testing.expectEqual(@as(i64, 95400), result);
}

test "parse_duration: seconds only verbose" {
    const result = try whenwords.parse_duration("45 seconds");
    try std.testing.expectEqual(@as(i64, 45), result);
}

test "parse_duration: seconds compact s" {
    const result = try whenwords.parse_duration("45s");
    try std.testing.expectEqual(@as(i64, 45), result);
}

test "parse_duration: seconds compact sec" {
    const result = try whenwords.parse_duration("45sec");
    try std.testing.expectEqual(@as(i64, 45), result);
}

test "parse_duration: hours hr" {
    const result = try whenwords.parse_duration("2hr");
    try std.testing.expectEqual(@as(i64, 7200), result);
}

test "parse_duration: hours hrs" {
    const result = try whenwords.parse_duration("2hrs");
    try std.testing.expectEqual(@as(i64, 7200), result);
}

test "parse_duration: minutes mins" {
    const result = try whenwords.parse_duration("30mins");
    try std.testing.expectEqual(@as(i64, 1800), result);
}

test "parse_duration: case insensitive" {
    const result = try whenwords.parse_duration("2H 30M");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: whitespace tolerance" {
    const result = try whenwords.parse_duration("  2 hours   30 minutes  ");
    try std.testing.expectEqual(@as(i64, 9000), result);
}

test "parse_duration: error - empty string" {
    try expectAnyError(whenwords.parse_duration(""));
}

test "parse_duration: error - no units" {
    try expectAnyError(whenwords.parse_duration("hello world"));
}

test "parse_duration: error - negative" {
    try expectAnyError(whenwords.parse_duration("-5 hours"));
}

test "parse_duration: error - just number" {
    try expectAnyError(whenwords.parse_duration("42"));
}

test "human_date: today" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705276800, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Today", result);
}

test "human_date: today - same day different time" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705320000, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Today", result);
}

test "human_date: yesterday" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705190400, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Yesterday", result);
}

test "human_date: tomorrow" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705363200, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Tomorrow", result);
}

test "human_date: last Sunday (1 day before Monday)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705190400, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Yesterday", result);
}

test "human_date: last Saturday (2 days ago)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705104000, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Last Saturday", result);
}

test "human_date: last Friday (3 days ago)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705017600, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Last Friday", result);
}

test "human_date: last Thursday (4 days ago)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1704931200, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Last Thursday", result);
}

test "human_date: last Wednesday (5 days ago)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1704844800, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Last Wednesday", result);
}

test "human_date: last Tuesday (6 days ago)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1704758400, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Last Tuesday", result);
}

test "human_date: last Monday (7 days ago) - becomes date" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1704672000, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 8", result);
}

test "human_date: this Tuesday (1 day future)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705363200, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Tomorrow", result);
}

test "human_date: this Wednesday (2 days future)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705449600, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("This Wednesday", result);
}

test "human_date: this Thursday (3 days future)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705536000, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("This Thursday", result);
}

test "human_date: this Sunday (6 days future)" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705795200, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("This Sunday", result);
}

test "human_date: next Monday (7 days future) - becomes date" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1705881600, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 22", result);
}

test "human_date: same year different month" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1709251200, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("March 1", result);
}

test "human_date: same year end of year" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1735603200, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("December 31", result);
}

test "human_date: previous year" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1672531200, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 1, 2023", result);
}

test "human_date: next year" {
    const allocator = std.testing.allocator;
    const result = try whenwords.human_date(allocator, 1736121600, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 6, 2025", result);
}

test "date_range: same day" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1705276800, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 15, 2024", result);
}

test "date_range: same day different times" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1705276800, 1705320000);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 15, 2024", result);
}

test "date_range: consecutive days same month" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1705276800, 1705363200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 15–16, 2024", result);
}

test "date_range: same month range" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1705276800, 1705881600);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 15–22, 2024", result);
}

test "date_range: same year different months" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1705276800, 1707955200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 15 – February 15, 2024", result);
}

test "date_range: different years" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1703721600, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("December 28, 2023 – January 15, 2024", result);
}

test "date_range: full year span" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1704067200, 1735603200);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 1 – December 31, 2024", result);
}

test "date_range: swapped inputs - should auto-correct" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1705881600, 1705276800);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 15–22, 2024", result);
}

test "date_range: multi-year span" {
    const allocator = std.testing.allocator;
    const result = try whenwords.date_range(allocator, 1672531200, 1735689600);
    defer allocator.free(result);
    try std.testing.expectEqualStrings("January 1, 2023 – January 1, 2025", result);
}
