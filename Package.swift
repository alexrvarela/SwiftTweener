// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tweener",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3),
    ],
    products: [
        .library( name: "Tweener", targets: ["Tweener"]),
    ],
    targets: [
        .target( name: "Tweener", dependencies: [], path: "Source"),
        .testTarget(name: "TweenerTests", dependencies: ["Tweener"], path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)
