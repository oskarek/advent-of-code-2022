import Foundation
import Parsing
import Types
import Utils

/// Get the priority of a given character (rucksack item).
func priority(of char: Character) -> Int {
	if char.isLowercase {
		return Int(char.asciiValue! - Character("a").asciiValue! + 1)
	} else {
		return Int(char.asciiValue! - Character("A").asciiValue! + 27)
	}
}

/// Get the sum of the priorities of all common elements of the given rucksacks.
func prioOfCommon(_ sacks: [[Character]]) -> Int {
	sacks.map(Set.init).combine { $0.intersection($1) }.map(priority).sum
}

public let solver = Solver(
	parser: LinesOf { Prefix(1...) { $0.isLetter }.map(Array.init) },
	solve: { rucksacks in
		return (
			part1: rucksacks.map { $0.nGroups(2) }.map(prioOfCommon).sum,
			part2: rucksacks.groupsOf(3).map(prioOfCommon).sum
		)
	}
)
