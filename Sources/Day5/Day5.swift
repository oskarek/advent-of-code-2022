import Foundation
import Parsing
import Types
import Utils

// MARK: Models

struct MoveInstruction {
	let quantity: Int
	let from: Int
	let to: Int
}

// MARK: Parsing

let crate = OneOf {
	"   ".map { Character?.none }
	Parse { "["; First(); "]" }.map(Character?.some)
}
let cratesRow = Many(1...) {
	crate
} separator: {
	" "
}

let moveInstruction = Parse(MoveInstruction.init) {
	"move "; Int.parser(); " from "; Int.parser(); " to "; Int.parser()
}

let parser = Parse {
	LinesOf { cratesRow }.map(makeCrateStacks)
	Skip { PrefixThrough("\n\n") }
	LinesOf { moveInstruction }
}

// MARK: Solution logic

/// Turn rows of crates intostacks of crates.
func makeCrateStacks(from crateRows: [[Character?]]) -> [[Character]] {
	crateRows.transposed().map { $0.compactMap { $0 } }
}

extension MoveInstruction {
	/// Perform this move instruction on the crate stacks.
	func perfom(on crateStacks: inout [[Character]], multiMove: Bool) {
		var cratesToMove = crateStacks[self.from - 1].prefix(self.quantity)
		if !multiMove { cratesToMove.reverse() }

		crateStacks[self.to - 1].insert(contentsOf: cratesToMove, at: 0)
		crateStacks[self.from - 1].removeFirst(self.quantity)
	}
}

/// Perform all the move instructions on the crate stacks.
func perform(_ instructions: [MoveInstruction], on crateStacks: [[Character]], multiMove: Bool) -> [[Character]] {
	var crateStacks = crateStacks
	for instruction in instructions {
		instruction.perfom(on: &crateStacks, multiMove: multiMove)
	}
	return crateStacks
}

public let solver = Solver(
	parser: parser,
	solve: { (input: ([[Character]], [MoveInstruction])) in
		let crateStacks = input.0
		let moveInstrs = input.1

		return (
			part1: perform(moveInstrs, on: crateStacks, multiMove: false)
				.map { "\($0.first!)" }.joined(),
			part2: perform(moveInstrs, on: crateStacks, multiMove: true)
				.map { "\($0.first!)" }.joined()
		)
	}
)
