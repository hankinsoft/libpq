// swift-tools-version:5.3
 
import PackageDescription
 
let package = Package(
    name: "libpq",

    platforms: [
        .iOS(.v12),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "libpq",
            targets: ["libpq"]),
    ],
    targets: [
        .binaryTarget(
            name: "libpq",
            path: "Frameworks/libpq.xcframework"
        )
    ]
)
