const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const xarmod = b.createModule(.{
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
    });
    const xar = b.addLibrary(.{
        .name = "xar",
        .root_module = xarmod,
        .linkage = .static,
    });
    xarmod.addCSourceFiles(.{
        .files = &.{
            "xar/xar/lib/archive.c",
            "xar/xar/lib/arcmod.c",
            "xar/xar/lib/b64.c",
            "xar/xar/lib/bzxar.c",
            "xar/xar/lib/darwinattr.c",
            "xar/xar/lib/data.c",
            "xar/xar/lib/ea.c",
            "xar/xar/lib/err.c",
            "xar/xar/lib/ext2.c",
            "xar/xar/lib/fbsdattr.c",
            "xar/xar/lib/filetree.c",
            "xar/xar/lib/hash.c",
            "xar/xar/lib/io.c",
            "xar/xar/lib/linuxattr.c",
            "xar/xar/lib/lzmaxar.c",
            "xar/xar/lib/macho.c",
            "xar/xar/lib/script.c",
            "xar/xar/lib/signature.c",
            "xar/xar/lib/stat.c",
            "xar/xar/lib/subdoc.c",
            "xar/xar/lib/util.c",
            "xar/xar/lib/zxar.c",
        },
        .flags = &.{},
    });
    xarmod.addIncludePath(b.path("xar/xar/include"));
    xarmod.addIncludePath(.{ .cwd_relative = "/usr/include" });
    xarmod.addIncludePath(.{ .cwd_relative = "/usr/include/libxml2" });
    xarmod.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });
    xarmod.addCMacro("_GNU_SOURCE", "1");

    xarmod.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    xarmod.linkSystemLibrary("lzma", .{});
    xarmod.linkSystemLibrary("bz2", .{});
    xarmod.linkSystemLibrary("z", .{});
    xarmod.linkSystemLibrary("crypto", .{});
    xarmod.linkSystemLibrary("xml2", .{});
    xarmod.link_libc = true;
    b.installArtifact(xar);

    b.installDirectory(.{
        .source_dir = b.path("xar/xar/include"),
        .install_dir = .header,
        .install_subdir = "xar",
    });

    const xarexemod = b.createModule(.{
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
    });
    const xarexe = b.addExecutable(.{
        .name = "xar",
        .root_module = xarexemod,
    });
    xarexemod.addCSourceFile(.{
        .file = b.path("xar/xar/src/xar.c"),
        .flags = &.{},
    });
    xarexemod.addIncludePath(b.path("xar/xar/include"));
    xarexemod.addIncludePath(.{ .cwd_relative = "/usr/include" });
    xarexemod.addIncludePath(.{ .cwd_relative = "/usr/include/libxml2" });
    xarexemod.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });
    xarexemod.addCMacro("_GNU_SOURCE", "1");

    xarexemod.linkLibrary(xar);
    xarexemod.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    xarexemod.linkSystemLibrary("xml2", .{});
    xarexemod.linkSystemLibrary("z", .{});
    xarexemod.linkSystemLibrary("crypto", .{});
    xarexemod.linkSystemLibrary("lzma", .{});
    xarexemod.linkSystemLibrary("bz2", .{});
    xarexemod.linkLibrary(xar);

    xarexemod.link_libc = true;
    b.installArtifact(xarexe);

    const exemod = b.createModule(.{
        .root_source_file = null,
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "pbxz",
        .root_module = exemod,
    });
    exemod.addCSourceFile(.{
        .file = b.path("pbzx/pbzx.c"),
        .flags = &.{},
    });
    exemod.addIncludePath(b.path("zig-out/include"));
    exemod.addIncludePath(.{ .cwd_relative = "/usr/include" });
    exemod.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });

    exemod.linkLibrary(xar);
    exemod.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    exemod.linkSystemLibrary("xml2", .{});
    exemod.linkSystemLibrary("z", .{});
    exemod.linkSystemLibrary("crypto", .{});
    exemod.linkSystemLibrary("bz2", .{});
    exemod.linkSystemLibrary("lzma", .{});
    exemod.linkLibrary(xar);
    exemod.link_libc = true;
    b.installArtifact(exe);
}
