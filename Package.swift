// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GitCommitInfoPlugin",
    products: [
        .plugin(
            name: "GitCommitInfoPlugin",
            targets: ["GitCommitInfoPlugin"]),
        .executable(name: "GitCommitInfoGenerator", targets: ["GitCommitInfoGenerator"])
    ],
    targets: [
        .plugin(
            name: "GitCommitInfoPlugin",
            capability: .buildTool(),
            dependencies: ["GitCommitInfoGenerator"]
        ),
        .target(name: "GitCommitInfoGenerator")
    ]
)
