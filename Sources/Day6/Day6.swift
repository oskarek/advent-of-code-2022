import Foundation
import Parsing
import Types

func charsUntilFirstMarker(markerSize: Int, signal: [Character]) -> Int {
	signal.indices.dropFirst(markerSize - 1).first {
		Set(signal[$0 - (markerSize - 1) ... $0]).count == markerSize
	}! + 1
}

public let solver = Solver(
	parser: Rest().map(Array.init),
	solve: { signal in
		return (
			part1: charsUntilFirstMarker(markerSize: 4, signal: signal),
			part2: charsUntilFirstMarker(markerSize: 14, signal: signal)
		)
	}
)
