import Foundation

public struct PriorityQueue<T: Equatable & Hashable> {
	private var heap: [T] = []
	private var indices: [T: Int] = [:]
	private let order: (T, T) -> Bool

	public init(order: @escaping (T, T) -> Bool) {
		self.order = order
	}

	public var isEmpty: Bool { heap.isEmpty }

	public mutating func push(_ element: T) {
		heap.append(element)
		indices[element] = heap.count - 1
		siftUp(from: heap.count - 1)
	}

	public mutating func pop() -> T? {
		guard !isEmpty else { return nil }

		let result = heap[0]
		indices[result] = nil
		let last = heap.removeLast()
		if !heap.isEmpty {
			heap[0] = last
			indices[last] = 0
			siftDown(from: 0)
		}
		return result
	}

	public mutating func update(node: T) where T: Equatable {
		if let index = indices[node] {
			siftUp(from: index)
			siftDown(from: index)
		}
	}

	private mutating func siftUp(from index: Int) {
		var childIndex = index
		let child = heap[childIndex]
		var parentIndex = (childIndex - 1) / 2

		while childIndex > 0 && order(child, heap[parentIndex]) {
			heap[childIndex] = heap[parentIndex]
			indices[heap[parentIndex]] = childIndex
			childIndex = parentIndex
			parentIndex = (childIndex - 1) / 2
		}

		heap[childIndex] = child
		indices[child] = childIndex
	}

	private mutating func siftDown(from index: Int) {
		var parentIndex = index
		let parent = heap[parentIndex]
		var childIndex = 2 * parentIndex + 1

		while childIndex < heap.count {
			var child: T { heap[childIndex] }
			if childIndex + 1 < heap.count && order(heap[childIndex + 1], child) {
				childIndex += 1
			}

			guard order(child, parent) else { break }
			heap[parentIndex] = child
			indices[child] = parentIndex
			parentIndex = childIndex
			childIndex = 2 * parentIndex + 1
		}

		heap[parentIndex] = parent
		indices[parent] = parentIndex
	}
}
