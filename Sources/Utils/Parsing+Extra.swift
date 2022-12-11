import Foundation
import Parsing

public struct LinesOf<Element: Parser>: Parser where Element.Input == Substring {
	public let count: CountingRange
	public let element: Element

	public init(_ count: CountingRange = 0..., @ParserBuilder element: () -> Element) {
		self.count = count
		self.element = element()
	}

	public func parse(_ input: inout Element.Input) throws -> [Element.Output] {
		try Many(count) {
			element
		} separator: {
			"\n"
		}.parse(&input)
	}
}
