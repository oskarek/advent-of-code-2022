import Foundation
import Parsing
import Types
import Utils

// MARK: Data types

struct RecipientTest {
	let divisor: Int
	let ifTrueMonkey: Int
	let ifFalseMonkey: Int

	func getRecipient(of item: Int) -> Int { item % divisor == 0 ? ifTrueMonkey : ifFalseMonkey }
}

struct Monkey {
	var items: [Int]
	let operation: (Int) -> Int
	let recipientTest: RecipientTest
}

// MARK: Parsing

let items = Parse {
	"Starting items: "
	Many {
		Int.parser()
	} separator: {
		", "
	}
}

let operation = Parse {
	"Operation: new = old"
	OneOf {
		" + ".map { (+) }
		" * ".map { (*) }
	}
	.flatMap { op in
		OneOf {
			"old".map { { op($0, $0) } }
			Int.parser().map { c in { op($0, c) } }
		}
	}
}

let parser = Many {
	Parse(Monkey.init) {
		Skip { "Monkey "; Int.parser(); ":"; Whitespace() }
		items; Whitespace()
		operation; Whitespace()
		Parse(RecipientTest.init) {
			"Test: divisible by "; Int.parser(); Whitespace()
			"If true: throw to monkey "; Int.parser(); Whitespace()
			"If false: throw to monkey "; Int.parser()
		}
	}
} separator: {
	"\n\n"
}

// MARK: Solution logic

func runRounds(_ monkeys: [Monkey], rounds: Int, worryAdjuster: (Int) -> Int = { $0 }) -> Int {
	var monkeys = monkeys
	var inspections: [Int] = .init(repeating: 0, count: monkeys.count)
	let divsProduct = monkeys.map(\.recipientTest.divisor).product

	for _ in 0 ..< rounds {
		for i in 0 ..< monkeys.count {
			inspections[i] += monkeys[i].items.count
			for item in monkeys[i].items {
				let itemWorry = worryAdjuster(monkeys[i].operation(item)) % divsProduct
				let recipient = monkeys[i].recipientTest.getRecipient(of: itemWorry)
				monkeys[recipient].items.append(itemWorry)
			}
			monkeys[i].items.removeAll()
		}
	}

	return inspections.sorted(by: >).prefix(2).product
}

public let solver = Solver(
	parser: parser,
	solve: { monkeys in
		return (
			part1: runRounds(monkeys, rounds: 20, worryAdjuster: { $0 / 3 }),
			part2: runRounds(monkeys, rounds: 10_000)
		)
	}
)
