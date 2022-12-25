import Foundation

public func shortestPaths_dijkstra<Node: Equatable & Hashable>(
	from source: Node,
	graph: [Node: [(to: Node, weight: Int)]]
) -> (predecessors: [Node: Node], distances: [Node: Int]) {
	var distances = [source: 0]
	var predecessors: [Node: Node] = [:]
	var visited = Set<Node>()

	// Create a priority queue to store the unvisited nodes
	var unvisited = PriorityQueue<Node> { distances[$0] ?? .max < distances[$1] ?? .max }
	graph.keys.forEach { unvisited.push($0) }

	while let current = unvisited.pop() {
		guard let dist = distances[current] else { break }
		visited.insert(current)

		for edge in graph[current]! {
			let neighbor = edge.to
			let weight = edge.weight
			if !visited.contains(neighbor), distances[neighbor] == nil || dist + weight < distances[neighbor]! {
				distances[neighbor] = dist + weight
				predecessors[neighbor] = current
				unvisited.update(node: neighbor)
			}
		}
	}
	return (predecessors, distances)
}
