// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "JSON",
    products: [
        .library(name: "JSON", targets: ["JSON"]),
        .library(name: "JSONDecoder", targets: ["JSONDecoder"])
    ],
    targets: [
        .target(name: "JSON"),
        .target(name: "JSONDecoder", dependencies: ["JSON"])
    ]
)
