import Foundation
import Parsing

public struct LinesOf<Element: Parser>: Parser where Element.Input == Substring {
	public let count: CountingRange
	public let element: Element

	public init(_ count: CountingRange = 0..., @ParserBuilder element: () -> Element) {
		self.count = count
		self.element = element()
	}

	public var body: some Parser<Substring, [Element.Output]> {
		Many(count) {
			element
		} separator: {
			"\n"
		} terminator: {
			"\n"
		}
	}
}
