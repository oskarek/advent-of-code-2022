import Foundation
import Parsing
import Types
import Utils

// MARK: Data types

struct Point: Equatable, Hashable {
	let x: Int
	let y: Int
}

// MARK: Parsing

let point = Parse(Point.init) { Int.parser(); ","; Int.parser() }

let rockPath = Many(1...) {
	point
} separator: {
	" -> "
}

// MARK: Solution logic

func points(from p1: Point, to p2: Point) -> Set<Point> {
	if p1.x == p2.x {
		return Set((min(p1.y, p2.y)...max(p1.y, p2.y)).map { Point(x: p1.x, y: $0) })
	} else if p1.y == p2.y {
		return Set((min(p1.x, p2.x)...max(p1.x, p2.x)).map { Point(x: $0, y: p1.y) })
	} else {
		fatalError("x or y has to be equal")
	}
}

func rockPathToPointsSet(_ rockPath: [Point]) -> Set<Point> {
	let pairs = zip(rockPath, Array(rockPath.dropFirst(1)))
	return pairs.map(points(from:to:)).reduce([]) { $0.union($1) }
}

func nextAlternatives(for point: Point) -> [Point] {
	return [0, -1, 1].map { Point(x: point.x + $0, y: point.y + 1) }
}

func solve(_ rockPaths: [[Point]], addFloor: Bool = false) -> Int {
	var filledPoints = rockPaths.map(rockPathToPointsSet).reduce(Set()) { $0.union($1) }
	let maxY = filledPoints.map(\.y).max()!
	var fallen = 0
	while !filledPoints.contains(.init(x: 500, y: 0)) {
		var sandPoint = Point(x: 500, y: 0)
		while let next = nextAlternatives(for: sandPoint).first(where: { !filledPoints.contains($0) && $0.y < maxY + 2 }) {
			sandPoint = next
		}
		if !addFloor && sandPoint.y == maxY + 1 { break }
		filledPoints.insert(sandPoint)
		fallen += 1
	}
	return fallen
}

public let solver = Solver(
	parser: LinesOf { rockPath },
	solve: { paths in
		return (
			part1: solve(paths),
			part2: solve(paths, addFloor: true)
		)
	}
)
