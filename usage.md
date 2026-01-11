# whenwords for Zig

Human-friendly time formatting and parsing.

## Installation

Copy `whenwords.zig` into your project and import it with `@import("whenwords.zig")`.

## Quick start

```zig
const std = @import("std");
const whenwords = @import("whenwords.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const ago = try whenwords.timeago(allocator, 1704067110, 1704067200);
    defer allocator.free(ago);

    const span = try whenwords.duration(allocator, 9000, null);
    defer allocator.free(span);

    const parsed = try whenwords.parse_duration("2h 30m");

    const label = try whenwords.human_date(allocator, 1705276800, 1705276800);
    defer allocator.free(label);

    const range = try whenwords.date_range(allocator, 1705276800, 1705881600);
    defer allocator.free(range);

    _ = parsed;
}
```

## Functions

### timeago(timestamp, reference) -> []u8

```zig
pub fn timeago(allocator: std.mem.Allocator, timestamp: anytype, reference: anytype) ![]u8
```

- `timestamp`: Unix seconds or ISO 8601 string.
- `reference`: Unix seconds or ISO 8601 string (the "current" time).
- Returns an owned string like `"3 hours ago"` or `"in 2 days"`.

Example:

```zig
const text = try whenwords.timeago(allocator, 1704067110, 1704067200);
```

### duration(seconds, options?) -> []u8

```zig
pub fn duration(allocator: std.mem.Allocator, seconds: anytype, options: ?whenwords.DurationOptions) ![]u8
```

- `seconds`: Non-negative number of seconds.
- `options`: `DurationOptions{ .compact = bool, .max_units = usize }`.
- Returns an owned string like `"2 hours, 30 minutes"` or `"2h 30m"`.

Example:

```zig
const text = try whenwords.duration(allocator, 9000, .{ .compact = true });
```

### parse_duration(string) -> i64

```zig
pub fn parse_duration(input: []const u8) !i64
```

- `input`: Duration string like `"2h 30m"`, `"2 hours and 30 minutes"`, `"2:30"`.
- Returns seconds as an integer.

Example:

```zig
const seconds = try whenwords.parse_duration("1.5h");
```

### human_date(timestamp, reference) -> []u8

```zig
pub fn human_date(allocator: std.mem.Allocator, timestamp: anytype, reference: anytype) ![]u8
```

- `timestamp`: Unix seconds or ISO 8601 string.
- `reference`: Unix seconds or ISO 8601 string.
- Returns strings like `"Today"`, `"Last Tuesday"`, or `"March 5"`.

Example:

```zig
const text = try whenwords.human_date(allocator, 1705276800, 1705276800);
```

### date_range(start, end) -> []u8

```zig
pub fn date_range(allocator: std.mem.Allocator, start: anytype, end: anytype) ![]u8
```

- `start`: Unix seconds or ISO 8601 string.
- `end`: Unix seconds or ISO 8601 string.
- Returns strings like `"March 5–7, 2024"`.

Example:

```zig
const text = try whenwords.date_range(allocator, 1705276800, 1705881600);
```

## Error handling

All functions return `error.InvalidTimestamp`, `error.InvalidDuration`, or `error.InvalidDurationString` for invalid input. Use `try`/`catch` to handle errors.

## Accepted types

- `timeago`, `human_date`, `date_range`: integer seconds, floating-point seconds, or ISO 8601 strings like `"2024-01-01T00:00:00Z"`.
- `duration`: integer or floating-point seconds.
- `parse_duration`: UTF-8 string input.
