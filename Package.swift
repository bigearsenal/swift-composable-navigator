// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let snapshotFolders = [
    "PathBuilder/__Snapshots__",
    "NavigationTree/__Snapshots__",
    "Screen/__Snapshots__",
]

let tcaSnapshotFolders = [
    "__Snapshots__",
]

let testGybFiles = [
    "NavigationTree/NavigationTreeBuilder+AnyOf.swift.gyb",
]

let package = Package(
    name: "swift-composable-navigator",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(
            name: "ComposableNavigator",
            targets: ["ComposableNavigator"]
        ),
        .library(
            name: "ComposableDeeplinking",
            targets: ["ComposableDeeplinking"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/shibapm/Rocket", from: "1.3.0"), // dev
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
            from: "1.8.2"
        ), // dev
    ],
    targets: [
        .target(
            name: "ComposableNavigator",
            dependencies: [],
            exclude: [
                "NavigationTree/NavigationTreeBuilder+AnyOf.swift.gyb",
                "PathBuilder/PathBuilders/PathBuilder+AnyOf.swift.gyb",
            ]
        ),
        .target(
            name: "ComposableDeeplinking",
            dependencies: [
                .target(name: "ComposableNavigator"),
            ]
        ),
        .testTarget(
            name: "ComposableNavigatorTests",
            dependencies: ["ComposableNavigator", "SnapshotTesting"],
            exclude: testGybFiles + snapshotFolders
        ), // dev
        .testTarget(name: "ComposableDeeplinkingTests", dependencies: ["ComposableDeeplinking"]), // dev
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration(
        [
            "rocket": [
                "pre_release_checks": [
                    "clean_git",
                ],
                "before": [
                    // "make test",
                    // "make cleanup",
                ],
            ],
        ]
    )
    .write()
#endif
