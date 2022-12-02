import Foundation
import Parsing
import Types
import Utils

// MARK: Models

enum Play {
	case rock
	case paper
	case scissor
}

enum Outcome {
	case loss
	case draw
	case win
}

// MARK: Parsers

let play1Parser = OneOf {
	"A".map { Play.rock }
	"B".map { Play.paper }
	"C".map { Play.scissor }
}
let play2Parser = OneOf {
	"X".map { Play.rock }
	"Y".map { Play.paper }
	"Z".map { Play.scissor }
}
let outcomeParser = OneOf {
	"X".map { Outcome.loss }
	"Y".map { Outcome.draw }
	"Z".map { Outcome.win }
}

// MARK: Solver

extension Outcome {
	var points: Int {
		switch self {
		case .loss: return 0
		case .draw: return 3
		case .win: return 6
		}
	}
}

extension Play {
	var value: Int {
		switch self {
		case .rock: return 1
		case .paper: return 2
		case .scissor: return 3
		}
	}

	func outcomeAgainst(other play: Play) -> Outcome {
		switch (self, play) {
		case (.rock, .paper): return .loss
		case (.rock, .rock): return .draw
		case (.rock, .scissor): return .win
		case (.paper, .scissor): return .loss
		case (.paper, .paper): return .draw
		case (.paper, .rock): return .win
		case (.scissor, .rock): return .loss
		case (.scissor, .scissor): return .draw
		case (.scissor, .paper): return .win
		}
	}

	func playForOutcome(_ outcome: Outcome) -> Play {
		[.rock, .paper, .scissor].first(where: { $0.outcomeAgainst(other: self) == outcome })!
	}
}

func points(for round: (Play, Play)) -> Int {
	let (theirs, mine) = round
	return mine.value + mine.outcomeAgainst(other: theirs).points
}

func points(for round: (Play, Outcome)) -> Int {
	let (theirMove, desiredOutcome) = round
	return theirMove.playForOutcome(desiredOutcome).value + desiredOutcome.points 
}


public let solver = Solver(
	parser1: LinesOf { play1Parser; " "; play2Parser },
	solve1: { $0.map(points(for:)).sum },
	parser2: LinesOf { play1Parser; " "; outcomeParser },
	solve2: { $0.map(points(for:)).sum }
)
