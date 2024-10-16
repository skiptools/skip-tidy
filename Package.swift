// swift-tools-version: 5.9
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import PackageDescription
import Foundation

let skipstone = [Target.PluginUsage.plugin(name: "skipstone", package: "skip")]

// Get the values we need to populate the LIBTIDY_VERSION and RELEASE_DATE macros later.
func tidyVersion() -> [String] {
    let PWD = (#filePath as NSString).deletingLastPathComponent
    let VERSION_FILE = NSString.path(withComponents: [PWD, "Sources", "CLibTidy", "version.txt"])
    if let CONTENTS = try? String(contentsOfFile: VERSION_FILE, encoding: .utf8).components(separatedBy: "\n") {
        return CONTENTS
    }

    return ["5.0.0", "2021/01/01"]
}

let package = Package(
    name: "skip-tidy",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipTidy", type: .dynamic, targets: ["SkipTidy"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.1.11"),
        .package(url: "https://source.skip.tools/skip-unit.git", from: "1.0.1"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.1.11"),
        .package(url: "https://source.skip.tools/skip-ffi.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SkipTidy", dependencies: [
            "CLibTidy",
            .product(name: "SkipFoundation", package: "skip-foundation"),
            .product(name: "SkipFFI", package: "skip-ffi"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipTidyTests", dependencies: [
            "SkipTidy",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),
        .target(name: "CLibTidy", dependencies: [
            .product(name: "SkipUnit", package: "skip-unit")
            ], sources: ["src"], cSettings: [
            .define("LIBTIDY_VERSION", to: "\"\(tidyVersion()[0])\"", nil),
            .define("RELEASE_DATE", to: "\"\(tidyVersion()[1])\"", nil)
        ], plugins: skipstone),
    ]
)
