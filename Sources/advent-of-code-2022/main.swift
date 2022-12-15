import ArgumentParser
import Foundation
import Day1
import Day2
import Day3
import Day4
import Day5
import Day6
import Day7
import Day8
import Day9
import Day10
import Day11
import Day12
import Day13
import Day14
import Types

// MARK: Solvers

let solvers: [Int: Solver] = [
	1: Day1.solver,
	2: Day2.solver,
	3: Day3.solver,
	4: Day4.solver,
	5: Day5.solver,
	6: Day6.solver,
	7: Day7.solver,
	8: Day8.solver,
	9: Day9.solver,
	10: Day10.solver,
	11: Day11.solver,
	12: Day12.solver,
	13: Day13.solver,
	14: Day14.solver,
]

// MARK: - Custom error type

struct RuntimeError: Error, CustomStringConvertible {
	let description: String
	init(_ description: String) { self.description = description }
}

// MARK: - Main program

struct AdventOfCode: ParsableCommand {
	@Argument(help: "The days you want to print the solution for.")
	var days: [Int] = []

	mutating func run() throws {
		if days.isEmpty { solvers.keys.max().map { days.append($0) } }
		for day in days {
			guard let inputUrl = Bundle.module.url(forResource: "day\(day)", withExtension: "txt") else {
				throw RuntimeError("Nu input file for day \(day) found.")
			}
			guard let solver = solvers[day] else {
				throw RuntimeError("No solver implemented for day \(day).")
			}
			let input = try String(contentsOf: inputUrl)
			let solution = try solver.printSolution(for: input)
			print("Day \(day) solutions:")
			print(solution)
			print()
		}
	}
}

AdventOfCode.main()
