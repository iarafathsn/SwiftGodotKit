// swift-tools-version: 5.9
import PackageDescription
let macLibgodotTarget: Target = .binaryTarget(
    name: "mac_libgodot",
    url: "https://github.com/iarafathsn/godot/releases/download/v4.7.0/libgodot-macos.xcframework.zip",
    checksum: "1e043940d4695ff7efe7dcd8e2a72a0dba292f254011721eafb46f2f840eb03f"
)

let iosLibgodotTarget: Target = .binaryTarget(
    name: "ios_libgodot",
    url: "https://github.com/iarafathsn/godot/releases/download/v4.7.0/libgodot-ios.xcframework.zip",
    checksum: "4b61d9a01ca908270d878da718e22053b07907e16b90f10d50d0593aaff9093b"
)

let package = Package(
    name: "SwiftGodotKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftGodotKit",
            targets: ["SwiftGodotKit"]),
        .executable(name: "TrivialSample", targets: ["TrivialSample"]),
    ],
    dependencies: [
    		  // This is tag 0.75.0
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", revision: "48112dd50fffe01f0af78e445a16991ecdc6bc94"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftGodotKit",
            dependencies: [
                "SwiftGodot",
                "libgodot",
                .target(name: "apple_plugin_stubs", condition: .when(platforms: [.iOS])),
                .target(name: "mac_libgodot", condition: .when(platforms: [.macOS])),
                .target(name: "ios_libgodot", condition: .when(platforms: [.iOS])),
            ]
        ),

        .executableTarget(
            name: "TrivialSample",
            dependencies: ["SwiftGodotKit"],

            // This line does not seem to do anything in Xcode, so you need to manually
            // copy main.pck and make it available from somwehere else
            resources: [
                .copy("main.pck"),
                .copy("main.tscn"),
                .copy("project.godot"),
                .copy(".godot"),
                .copy("godot"),
            ]
        ),

        .target(
            name: "apple_plugin_stubs",
            path: "Sources/apple_plugin_stubs",
            publicHeadersPath: "include"
        ),

        macLibgodotTarget,
        iosLibgodotTarget,
        .systemLibrary(
            name: "libgodot"
        ),
    ]
)
