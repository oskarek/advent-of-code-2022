import Foundation
import Parsing
import Types
import Utils

// MARK: Data types

enum Packet: Equatable {
	case int(Int)
	case list([Packet])
}

// MARK: Parsing

struct PacketParser: Parser {
	func parse(_ input: inout Substring) throws -> Packet {
		try OneOf {
			Int.parser().map(Packet.int)
			Parse(Packet.list) {
				"["
				Many {
					PacketParser()
				} separator: {
					","
				}
				"]"
			}
		}.parse(&input)
	}
}

let parser = Many {
	PacketParser()
	"\n"
	PacketParser()
} separator: {
	"\n\n"
}


// MARK: Solution logic

/// Compare two packets.
func <= (_ p1: Packet, _ p2: Packet) -> Bool {
	switch (p1, p2) {
	case (.int(let i1), .int(let i2)):
		return i1 <= i2

	case (.int(let i), let p2):
		return .list([.int(i)]) <= p2

	case (let p1, .int(let i)):
		return p1 <= .list([.int(i)])

	case (.list(let l1), .list(let l2)):
		for (e1, e2) in zip(l1, l2) {
			guard e1 <= e2 else { return false }
			if !(e2 <= e1) { return true }
		}
		return l1.count <= l2.count
	}
}

func indicesOfOrderedPairs(_ pairs: [(Packet, Packet)]) -> [Int] {
	zip(1..., pairs).filter { $1.0 <= $1.1 }.map(\.0)
}

func findDistressSignalDecoderKey(_ packets: [Packet]) -> Int {
	let divPacks: [Packet] = [.list([.list([.int(2)])]), .list([.list([.int(6)])])]
	let sortedPacks = (packets + divPacks).sorted(by: <=)

	return divPacks.map { sortedPacks.firstIndex(of: $0)! + 1 }.product
}

public let solver = Solver(
	parser: parser,
	solve: { pairs in
		return (
			part1: indicesOfOrderedPairs(pairs).sum,
			part2: findDistressSignalDecoderKey(pairs.flatMap { [$0, $1] })
		)
	}
)
