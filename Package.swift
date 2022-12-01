// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "advent-of-code-2022",
	platforms: [.macOS(.v13)],
	products: [
		.library(name: "Day1", targets: ["Day1"]),
		.library(name: "Types", targets: ["Types"]),
		.library(name: "Utils", targets: ["Utils"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.10.0"),
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
	],
	targets: [
		.target(
			name: "Day1",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Types",
			dependencies: [
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Utils",
			dependencies: []
		),
		.executableTarget(
			name: "advent-of-code-2022",
			dependencies: [
				"Day1",
				"Types",
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Parsing", package: "swift-parsing"),
			],
			resources: [.process("Inputs")]
		),
	]
)
