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
} terminator: {
	Whitespace()
}

// MARK: Solver

public let solver = Solver(
	parser: calorieGroupsParser,
	solve: { calorieGroups in
		let sums = calorieGroups.map(\.sum).sorted(by: >)
		return (sums[0], sums.prefix(3).sum)
	}
)
