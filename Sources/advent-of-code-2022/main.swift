import ArgumentParser
import Foundation
import Day1
import Day2
import Day3
import Types

// MARK: Solvers

let solvers: [Int: Solver] = [
	1: Day1.solver,
	2: Day2.solver,
	3: Day3.solver,
]

// MARK: - Custom error type

struct RuntimeError: Error, CustomStringConvertible {
	let description: String
	init(_ description: String) { self.description = description }
}

// MARK: - Main program

struct AdventOfCode: ParsableCommand {
	@Argument(help: "The day of the solution you want to print.")
	var day: Int

	func run() throws {
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

AdventOfCode.main()
