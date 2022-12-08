import Foundation
import Parsing
import Types
import Utils

extension [[Int]] {
	/// Apply a transformation on all elements, where the closure also gets the element's outgoing elements in all directions.
	func mapWithSurrounding<Output>(_ transform: (Int, [any Sequence<Int>]) -> Output) -> [[Output]] {
		return self.enumerated().map { y, row in
			row.enumerated().map { x, elem in
				let col = self.map { $0[x] }
				let left = row[...(x - 1)].reversed()
				let right = row[(x + 1)...]
				let top = col[...(y - 1)].reversed()
				let bottom = col[(y + 1)...]

				return transform(elem, [left, right, top, bottom])
			}
		}
	}
}

/// Ge the number of trees that are visible from either edge.
func countOfVisible(_ map: [[Int]]) -> Int {
	map.mapWithSurrounding { elem, surrounding in
		surrounding.contains(where: { $0.allSatisfy { $0 < elem } }) ? 1 : 0
	}
	.map(\.sum).sum
}

/// Get the maximum scenic score for any tree on the map.
func maxScenicScore(_ map: [[Int]]) -> Int {
	map.mapWithSurrounding { elem, surrounding in
		surrounding.map { $0.prefix(untilIncluding: { $0 >= elem }).count }.product
	}
	.map { $0.max() ?? 0 }.max() ?? 0
}

public let solver = Solver(
	parser: LinesOf { Many(1...) { Digits(1) } },
	solve: { map in
		return (
			part1: countOfVisible(map),
			part2: maxScenicScore(map)
		)
	}
)
