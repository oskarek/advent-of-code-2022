import Foundation
import Parsing
import Types
import Utils

let sectionAssignment =
	Parse { Int.parser(); "-"; Int.parser() }.map { Set($0.0 ... $0.1) }

public let solver = Solver(
	parser: LinesOf { sectionAssignment; ","; sectionAssignment },
	solve: { pairs in
		return (
			part1: pairs.filter { $0.isSubset(of: $1) || $1.isSubset(of: $0) }.count,
			part2: pairs.filter { !$0.isDisjoint(with: $1) }.count
		)
	}
)
