const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const xar = b.addLibrary(.{
        .name = "xar",
        .root_module = b.createModule(.{
            .root_source_file = null,
            .target = target,
            .optimize = optimize,
        }),
        .linkage = .static,
    });
    xar.addCSourceFiles(.{
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
    xar.addIncludePath(b.path("xar/xar/include"));
    xar.addIncludePath(.{ .cwd_relative = "/usr/include" });
    xar.addIncludePath(.{ .cwd_relative = "/usr/include/libxml2" });
    xar.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });
    xar.root_module.addCMacro("_GNU_SOURCE", "1");

    xar.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    xar.linkSystemLibrary("lzma");
    xar.linkSystemLibrary("bz2");
    xar.linkSystemLibrary("z");
    xar.linkSystemLibrary("crypto");
    xar.linkSystemLibrary("xml2");
    xar.linkLibC();
    b.installArtifact(xar);

    b.installDirectory(.{
        .source_dir = b.path("xar/xar/include"),
        .install_dir = .header,
        .install_subdir = "xar",
    });

    const xarexe = b.addExecutable(.{
        .name = "xar",
        .root_module = b.createModule(.{
            .root_source_file = null,
            .target = target,
            .optimize = optimize,
        }),
    });
    xarexe.addCSourceFile(.{
        .file = b.path("xar/xar/src/xar.c"),
        .flags = &.{},
    });
    xarexe.addIncludePath(b.path("xar/xar/include"));
    xarexe.addIncludePath(.{ .cwd_relative = "/usr/include" });
    xarexe.addIncludePath(.{ .cwd_relative = "/usr/include/libxml2" });
    xarexe.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });
    xarexe.root_module.addCMacro("_GNU_SOURCE", "1");

    xarexe.linkLibrary(xar);
    xarexe.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    xarexe.linkSystemLibrary("xml2");
    xarexe.linkSystemLibrary("z");
    xarexe.linkSystemLibrary("crypto");
    xarexe.linkSystemLibrary("lzma");
    xarexe.linkSystemLibrary("bz2");
    xarexe.linkLibrary(xar);

    xarexe.linkLibC();
    b.installArtifact(xarexe);

    const exe = b.addExecutable(.{
        .name = "pbxz",
        .root_module = b.createModule(.{
            .root_source_file = null,
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.addCSourceFile(.{
        .file = b.path("pbzx/pbzx.c"),
        .flags = &.{},
    });
    exe.addIncludePath(b.path("zig-out/include"));
    exe.addIncludePath(.{ .cwd_relative = "/usr/include" });
    exe.addIncludePath(.{ .cwd_relative = "/usr/include/x86_64-linux-gnu" });

    exe.linkLibrary(xar);
    exe.addLibraryPath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu" });
    exe.linkSystemLibrary("xml2");
    exe.linkSystemLibrary("z");
    exe.linkSystemLibrary("crypto");
    exe.linkSystemLibrary("bz2");
    exe.linkSystemLibrary("lzma");
    exe.linkLibrary(xar);
    exe.linkLibC();
    b.installArtifact(exe);
}
