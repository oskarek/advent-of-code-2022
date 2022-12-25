// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "advent-of-code-2022",
	platforms: [.macOS(.v13)],
	products: [
		.library(name: "Day1", targets: ["Day1"]),
		.library(name: "Day2", targets: ["Day2"]),
		.library(name: "Day3", targets: ["Day3"]),
		.library(name: "Day4", targets: ["Day4"]),
		.library(name: "Day5", targets: ["Day5"]),
		.library(name: "Day6", targets: ["Day6"]),
		.library(name: "Day7", targets: ["Day7"]),
		.library(name: "Day8", targets: ["Day8"]),
		.library(name: "Day9", targets: ["Day9"]),
		.library(name: "Day10", targets: ["Day10"]),
		.library(name: "Day11", targets: ["Day11"]),
		.library(name: "Day12", targets: ["Day12"]),
		.library(name: "Day13", targets: ["Day13"]),
		.library(name: "Day14", targets: ["Day14"]),
		.library(name: "Day15", targets: ["Day15"]),
		.library(name: "Types", targets: ["Types"]),
		.library(name: "Utils", targets: ["Utils"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.11.0"),
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
			name: "Day3",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day4",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day5",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day6",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day7",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day8",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day9",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day10",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day11",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day12",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day13",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day14",
			dependencies: [
				"Types",
				"Utils",
				.product(name: "Parsing", package: "swift-parsing"),
			]
		),
		.target(
			name: "Day15",
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
				"Day3",
				"Day4",
				"Day5",
				"Day6",
				"Day7",
				"Day8",
				"Day9",
				"Day10",
				"Day11",
				"Day12",
				"Day13",
				"Day14",
				"Day15",
				"Types",
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Parsing", package: "swift-parsing"),
			],
			resources: [.process("Inputs")]
		),
	]
)
