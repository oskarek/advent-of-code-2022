import Foundation
import Parsing
import Types
import Utils

// MARK: Parsers

let calorieGroupParser = Many(1...) {
	Int.parser()
} separator: {
	"\n"
}

let calorieGroupsParser = Many {
	calorieGroupParser
} separator: {
	"\n\n"
}

// MARK: Solver

public let solver = Solver(
	parser: calorieGroupsParser,
	solve: { calorieGroups in
		let sums = calorieGroups.map(\.sum).sorted(by: >)
		return (
			part1: sums[0],
			part2: sums.prefix(3).sum
		)
	}
)
