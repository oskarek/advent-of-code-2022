// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "advent-of-code-2022",
	platforms: [.macOS(.v13)],
	products: [
		.library(name: "Day1", targets: ["Day1"]),
		.library(name: "Day2", targets: ["Day2"]),
		.library(name: "Types", targets: ["Types"]),
		.library(name: "Utils", targets: ["Utils"]),
	],
	dependencies: [
		.package(url: "https://github.com/oskarek/swift-parsing", branch: "aoc"),
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
			name: "Day2",
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
			dependencies: [
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.executableTarget(
			name: "advent-of-code-2022",
			dependencies: [
				"Day1",
				"Day2",
				"Types",
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Parsing", package: "swift-parsing"),
			],
			resources: [.process("Inputs")]
		),
	]
)
