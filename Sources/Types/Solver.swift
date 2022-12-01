import Foundation
import Parsing

/// A solver for a problem containing a part 1 and a part 2.
public struct Solver {
	private let _printSolutions: (String) throws -> (String, String)

	public init<Input, Output1: CustomStringConvertible, Output2: CustomStringConvertible>(
		parse: @escaping (String) throws -> Input,
		solve: @escaping (Input) throws -> (part1: Output1, part2: Output2)
	) {
		_printSolutions = {
			let (sol1, sol2) = try solve(try parse($0))
			return (sol1.description, sol2.description)
		}
	}

	public init<P: Parser, Input, Output1: CustomStringConvertible, Output2: CustomStringConvertible>(
		parser: P,
		solve: @escaping (Input) throws -> (part1: Output1, part2: Output2)
	) where P.Input == Substring, P.Output == Input {
		self.init(parse: parser.parse, solve: solve)
	}

	public init<Input, Output1: CustomStringConvertible, Output2: CustomStringConvertible>(
		parse: @escaping (String) throws -> Input,
		solve1: @escaping (Input) throws -> Output1,
		solve2: @escaping (Input) throws -> Output2
	) {
		self.init(parse: parse, solve: { (try solve1($0), try solve2($0)) })
	}

	public init<P: Parser, Input, Output1: CustomStringConvertible, Output2: CustomStringConvertible>(
		parser: P,
		solve1: @escaping (Input) throws -> Output1,
		solve2: @escaping (Input) throws -> Output2
	) where P.Input == Substring, P.Output == Input {
		self.init(parse: parser.parse, solve: { (try solve1($0), try solve2($0)) })
	}

	public func printSolution(for input: String) throws -> String {
		let (part1, part2) = try _printSolutions(input)
		return """
		1)
		\(part1)
		2)
		\(part2)
		"""
	}
}
