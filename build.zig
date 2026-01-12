const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("whenwords", .{
        .root_source_file = b.path("whenwords.zig"),
    });

    const test_module = b.createModule(.{
        .root_source_file = b.path("whenwords_test.zig"),
        .target = target,
        .optimize = optimize,
    });

    const tests = b.addTest(.{
        .root_module = test_module,
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run whenwords tests");
    test_step.dependOn(&run_tests.step);
}
