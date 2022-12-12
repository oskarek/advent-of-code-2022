import Foundation
import Parsing
import Types
import Utils

// MARK: Data types

typealias Vec<T> = [T]
typealias Point = Vec<Int>

// MARK: Solution logic

func elevation(_ char: Character) -> Int {
	if char == "S" { return 0 }
	if char == "E" { return elevation("z") }
	return Int(char.asciiValue! - Character("a").asciiValue!)
}

infix operator |+| : MultiplicationPrecedence
/// Add two vectors together.
func |+|<T: AdditiveArithmetic>(_ v1: Vec<T>, _ v2: Vec<T>) -> Vec<T> {
	zip(v1, v2).map(+)
}

func neighbs(_ point: Point, _ map: [[Character]]) -> [Point] {
	let candidates = [[0, 1], [0, -1], [1, 0], [-1, 0]].map { point |+| $0 }
	let isInMap: (Point) -> Bool = {
		map.indices.contains($0[1]) && map[$0[1]].indices.contains($0[0])
	}
	let hasOkElevation: (Point) -> Bool = {
		elevation(map[$0[1]][$0[0]]) >= elevation(map[point[1]][point[0]]) - 1
	}
	return candidates.filter { isInMap($0) && hasOkElevation($0) }
}

func solve(_ map: [[Character]], isValidStart: (Character) -> Bool) -> Int {
	var graph: [Point: [Point]] = [:]
	var sources: [Point] = []
	var target: Point!
	for y in map.indices {
		for x in map[y].indices {
			if map[y][x] == "E" { target = [x, y] }
			if isValidStart(map[y][x]) { sources.append([x, y]) }
			graph[[x, y]] = neighbs([x, y], map)
		}
	}
	let (_, distances) = shortestPaths_dijkstra(from: target!, graph: graph.mapValues { $0.map { (to: $0, weight: 1) } })
	return sources.compactMap { distances[$0] }.min() ?? 0
}

public let solver = Solver(
	parser: LinesOf { Prefix(1...) { $0 != "\n" }.map(Array.init) },
	solve: { graph in
		return (
			part1: solve(graph) { $0 == "S" },
			part2: solve(graph) { elevation($0) == 0 }
		)
	}
)
