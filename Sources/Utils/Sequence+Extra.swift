import Foundation

public extension Sequence where Element: AdditiveArithmetic {
	/// Get the sum of all the elements in the sequence.
	var sum: Element { reduce(.zero, +) }
}
