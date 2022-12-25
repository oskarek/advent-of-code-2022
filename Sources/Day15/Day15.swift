import Foundation
import Parsing
import Types
import Utils

// MARK: Data types

typealias Point = [Int]

struct Sensor {
	let pos: Point
	let closestBeacon: Point
}

// MARK: Parsing

let pos = Parse({ [$0, $1] }) { "x="; Int.parser(); ", y="; Int.parser() }
let sensor = Parse(Sensor.init) { "Sensor at "; pos;  ": closest beacon is at "; pos }

// MARK: Solution logic

func manhattanDist(from p1: Point, to p2: Point) -> Int {
	zip(p1, p2).map { abs($0 - $1) }.sum
}

/// Combine all the ranges that are overlapping.
func combine(_ ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
	let sortedRanges = ranges.sorted(by: { $0.lowerBound < $1.lowerBound })
	guard let first = sortedRanges.first else { return [] }
	return sortedRanges.dropFirst(1).reduce(into: [first]) { acc, range in
		if acc[acc.count-1].contains(range.lowerBound) {
			acc[acc.count-1] = (acc[acc.count-1].lowerBound ... max(range.upperBound, acc[acc.count-1].upperBound))
		} else {
			acc.append(range)
		}
	}
}

func beaconFreeRanges(atRow row: Int, sensors: [Sensor]) -> [ClosedRange<Int>] {
	sensors.compactMap { sensor in
		let maxXd = manhattanDist(from: sensor.pos, to: sensor.closestBeacon) - abs(row - sensor.pos[1])
		guard maxXd > 0 else { return nil }
		return (-maxXd ... maxXd).shift(sensor.pos[0])
	}
}

func solve1(_ sensors: [Sensor]) -> Int {
	let row = 2_000_000
	let emptyRanges = beaconFreeRanges(atRow: row, sensors: sensors)
	let numberOfBeaconsInRanges = Set(sensors.map(\.closestBeacon)).filter { b in b[1] == row && emptyRanges.contains { $0.contains(b[0]) } }.count
	return combine(emptyRanges).map { $0.upperBound - $0.lowerBound + 1 }.sum - numberOfBeaconsInRanges
}

func solve2(_ sensors: [Sensor]) -> Int {
	for y in 0 ... 4_000_000 {
		let emptyRanges = beaconFreeRanges(atRow: y, sensors: sensors).map { $0.clamped(to: 0 ... 4_000_000) }.filter { !$0.isEmpty }
		let combined = combine(emptyRanges)
		if combined.count > 1 { return (combined[0].upperBound + 1) * 4_000_000 + y }
	}
	fatalError("failed")
}


public let solver = Solver(
	parser: LinesOf { sensor },
	solve: { sensors in
		return (
			part1: solve1(sensors),
			part2: solve2(sensors)
		)
	}
)
