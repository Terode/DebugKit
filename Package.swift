
// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "DebugKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DebugKit",
            targets: ["DebugKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DebugKit",
            dependencies: [],
            path: "Sources/DebugKit",
            resources: [
                .process("Resources/DebugKitConfig.plist")
            ]
        )
    ]
)
