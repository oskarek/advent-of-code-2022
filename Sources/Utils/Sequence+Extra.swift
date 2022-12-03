import Foundation

public extension Sequence where Element: AdditiveArithmetic {
	/// Get the sum of all the elements in the sequence.
	var sum: Element { reduce(.zero, +) }
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
