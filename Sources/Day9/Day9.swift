import Foundation
import Parsing
import Types
import Utils

// MARK: Parsing

let parser = Parse(Array.init(repeating:count:)) {
	OneOf {
		"L".map { [-1, 0] }
		"R".map { [1, 0] }
		"U".map { [0, -1] }
		"D".map { [0, 1] }
	}
	" "
	Int.parser()
}

// MARK: Solution logic

typealias Vec = [Int]

/// Add a vector to another.
func += (_ vec1: inout Vec, _ vec2: Vec) {
	vec1 = zip(vec1, vec2).map(+)
}

extension Vec {
	mutating func moveToFollow(other: Vec) {
		let diffs = zip(other, self).map(-)
		guard diffs.contains(where: { abs($0) > 1 }) else { return }
		self += diffs.map { $0 == 0 ? 0 : Int($0 / abs($0)) }
	}
}

func tailVisitedPositions(after moves: [Vec], length: Int) -> Int {
	let startPos = [0, 0]
	var tailVisits: Set<Vec> = [startPos]
	var positions: [Vec] = Array(repeating: startPos, count: length)

	for move in moves {
		positions[0] += move
		var someDidntMove = false
		for knot in (1 ..< positions.count) {
			if someDidntMove { break }
			let prePos = positions[knot]
			positions[knot].moveToFollow(other: positions[knot - 1])
			if positions[knot] == prePos { someDidntMove = true }
		}
		tailVisits.insert(positions.last!)
	}
	return tailVisits.count
}

public let solver = Solver(
	parser: LinesOf { parser }.map { $0.flatMap { $0 } },
	solve: { headMoves in
		return (
			part1: tailVisitedPositions(after: headMoves, length: 2),
			part2: tailVisitedPositions(after: headMoves, length: 10)
		)
	}
)
