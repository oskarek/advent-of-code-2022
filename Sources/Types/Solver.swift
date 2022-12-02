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
		self.init(parse: Parse { parser; Whitespace() }.parse, solve: solve)
	}

	public init<Input1, Input2, Output1: CustomStringConvertible, Output2: CustomStringConvertible>(
		parse1: @escaping (String) throws -> Input1,
		solve1: @escaping (Input1) throws -> Output1,
		parse2: @escaping (String) throws -> Input2,
		solve2: @escaping (Input2) throws -> Output2
	) {
		_printSolutions = {
			let sol1 = try solve1(try parse1($0))
			let sol2 = try solve2(try parse2($0))
			return (sol1.description, sol2.description)
		}
	}

	public init<P1: Parser, P2: Parser, Output1: CustomStringConvertible, Output2: CustomStringConvertible>(
		parser1: P1,
		solve1: @escaping (P1.Output) throws -> Output1,
		parser2: P2,
		solve2: @escaping (P2.Output) throws -> Output2
	) where P1.Input == Substring, P2.Input == Substring {
		self.init(
			parse1: Parse { parser1; Whitespace() }.parse,
			solve1: solve1,
			parse2: Parse { parser2; Whitespace() }.parse,
			solve2: solve2
		)
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
