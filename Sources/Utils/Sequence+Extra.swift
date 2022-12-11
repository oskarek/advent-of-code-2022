import Foundation

public extension Sequence where Element: AdditiveArithmetic {
	/// Get the sum of all the elements in the sequence.
	var sum: Element { reduce(.zero, +) }
}

public extension Sequence where Element: Numeric {
	/// Get the product of all the elements in the sequence.
	var product: Element { reduce(1, *) }
}

public extension Collection {
	/// Combine all the elements of the collection into one, using the given combine closure.
	func combine(_ combine: (Element, Element) throws -> Element) rethrows -> Element {
		guard let first = self.first else { fatalError("reduce1 on empty array") }
		return try self.dropFirst().reduce(first, combine)
	}
}

public extension Array {
	/// Group the array into `n` pieces of equal size.
	func nGroups(_ n: Int) -> [Self] { groupsOf(self.count / n) }

	/// Group the array into pieces of size `size`.
	func groupsOf(_ size: Int) -> [Self] {
		guard self.count > 0, size > 0 else { return [] }
		return [Self(self.prefix(size))] + Self(self.dropFirst(size)).groupsOf(size)
	}
}

public extension Array {
	/// Transpose the array, with the precondition that all rows of the array are of same length.
	func transposed<E>() -> [[E]] where Element == [E] {
		guard let firstCount = self.first?.count else { return [] }
		guard self.allSatisfy({ $0.count == firstCount }) else {
			fatalError("transposing malformed array")
		}
		return (0 ..< firstCount).map { x in
			(0 ..< self.count).compactMap { self[$0][x] }
		}
	}
}

public extension Dictionary {
	func mapWithKeys<NewValue>(_ transform: (Key, Value) -> NewValue) -> [Key: NewValue] {
		var dict: [Key: NewValue] = [:]
		for (key, value) in self {
			dict[key] = transform(key, value)
		}
		return dict
	}
}

public extension Sequence {
	/// Returns all elements up until, _and including_, the first one that matches the given predicate.
	func prefix(untilIncluding predicate: (Element) -> Bool) -> [Element] {
		var foundMatch = false
		return self.prefix(while: { elem in
			defer { if predicate(elem) { foundMatch = true } }
			return !foundMatch
		})
	}
}

public extension Sequence {
	/// Get every nth element of the sequence, starting with the first.
	func every(n: Int) -> [Element] {
		self.enumerated().filter { (idx, elem) in idx % n == 0 }.map(\.element)
	}
}

public extension Sequence {
	/// Like reduce, but returns a list containing the successive reduced values.
	func scan(_ startValue: Element, _ combine: (Element, Element) -> Element) -> [Element] {
		self.reduce(into: [startValue]) { $0.append(combine($0.last!, $1)) }
	}
}
