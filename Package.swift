// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "async-http",
    platforms: [
        .macOS(.v12),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "AsyncHttp", targets: ["AsyncHttp"])
    ],
    targets: [
        .target(
            name: "AsyncHttp",
            path: "./Source"
        ),
        .testTarget(
            name: "AsyncHttpTests",
            dependencies: [
                "AsyncHttp"
            ],
            path: "./Tests"
        )
    ],
    
    swiftLanguageVersions: [.v5]
)
