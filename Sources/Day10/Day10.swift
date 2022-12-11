import Foundation
import Parsing
import Types
import Utils

// MARK: Parsing

let instr = OneOf {
	"noop".map { [0] }
	Parse { "addx "; Int.parser() }.map { [0, $0] }
}

let addInstrs = LinesOf { instr }.map { $0.flatMap { $0 } }

// MARK: Solution logic

func solve1(_ addInstrs: [Int]) -> Int {
	addInstrs.scan(1, +).enumerated().dropFirst(20).every(n: 40).map(*).sum
}

func solve2(_ addInstrs: [Int]) -> String {
	let sprites = addInstrs.scan(1, +).dropLast(1).map { ($0 ... $0 + 2) }
	let chars = zip(1..., sprites).map { (cycle, sprite) in
		sprite.contains(cycle % 40) ? Character("#") : "."
	}
	return chars.groupsOf(40).map { String($0) }.joined(separator: "\n")
}

public let solver = Solver(
	parser: addInstrs,
	solve: { instrs in
		return (
			part1: solve1(instrs),
			part2: solve2(instrs)
		)
	}
)
