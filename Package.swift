// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Objects",
    platforms: [.iOS(.v10)],
    products: [.library(name: "Objects", targets: ["Objects", "Coding", "Observable", "Dependancy"])],
    dependencies: [],
    targets: [.target(name: "Objects"), .target(name: "Coding"), .target(name: "Observable"), .target(name: "Dependancy")]
)
