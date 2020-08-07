//
//  Graph.swift
//  
//
//  Created by Damiaan on 06/08/2020.
//

/// This protocol declares the requirements for optimal pathfinding in a directed graph of nodes and implements the A* algorithm via an extension.
public protocol Graph {
	/// The type for the nodes or points in the graph
	associatedtype Node: Hashable
	associatedtype Cost: FloatingPoint

	// MARK: Optimal pathfinding requirements

	/// The endpoints of all edges that start from a certain reference node
	/// - Parameter node: The reference node
	func nodesAdjacent(to node: Node) -> Set<Node>

	/// The estimated/**heuristic** cost to reach the indicated end node from a given start node
	///
	/// The way you implement the estimation of the cost will impact the efficiency of the path finding algorithm.
	///
	/// **Admissibility**:
	///
	/// When the `estimatedCost` **never overestimates** the actual cost, the `findPath(from:to:)` method will find the **optimal** path.
	///
	/// **Monotonicity**
	///
	/// When the `estimatedCost` is a **monotone** decreasing funciton, the `findPath(from:to:)` method is guaranteed to find an optimal path without processing any node more than once. The function is said to be **monotone decreasing** when `estimatedCost(from: start, to: end) <= cost(from: start, to: intermediate) + estimatedCost(from: intermediate, to: end)` for every edge (`start`, `intermediate`).
	///
	/// - Parameters:
	///   - start: the starting point of the path who's cost is to be estimated
	///   - end: the end point of the path who's cost is to be estimated
	func estimatedCost(from start: Node, to end: Node) -> Cost

	/// The **actual** cost to reach the indicated end node from a given start node
	/// - Parameters:
	///   - start: the starting point of the path who's cost is to be estimated
	///   - end: the end point of the path who's cost is to be estimated
	func cost(from start: Node, to end: Node) -> Cost
}

extension Graph {
	// MARK: A* Implementation

	/// Attempts to find the optimal path from a reference node to the indicated goal node.
	/// If such a path exists, it is returned in start to end order.
	/// If it doesn't exist, the returned array will be empty.
	/// - Parameters:
	///   - startNode: the start node of the pathfinding attempt
	///   - goalNode: the goal node of the pathfinding attempt
	/// - Returns: An optimal path between start and goal if it exists, otherwise an empty array.
	public func findPath(from startNode: Node, to goalNode: Node) -> [Node] {
		guard startNode != goalNode else { return [goalNode] }

		var possibleSteps = [Step<Node, Cost>]()
		var eliminatedNodes: Set = [startNode]

		let firstStep = Step(to: startNode, stepCost: Cost.zero, goalCost: .zero)
		for connectedNode in nodesAdjacent(to: startNode) {
			let step = createStep(from: firstStep, to: connectedNode, goal: goalNode)
			possibleSteps.sortedInsert(newElement: step)
		}

		while !possibleSteps.isEmpty {
			let step = possibleSteps.removeFirst()
			guard step.node != goalNode else { return reconstructPath(from: step) }
			eliminatedNodes.insert(step.node)
			let nextNodes = nodesAdjacent(to: step.node).subtracting(eliminatedNodes)
			for node in nextNodes {
				// FIXME: don't create a step because in some cases it is never used
				let nextStep = createStep(from: step, to: node, goal: goalNode)
				let index = possibleSteps.binarySearch(element: nextStep)
				if index<possibleSteps.count && possibleSteps[index] == nextStep {
					if nextStep.stepCost < possibleSteps[index].stepCost {
						possibleSteps[index].previous = step
					}
				} else {
					possibleSteps.sortedInsert(newElement: nextStep)
				}
			}
		}

		return []
	}

	func createStep(from start: Step<Node, Cost>, to destination: Node, goal: Node) -> Step<Node, Cost> {
		Step(
			from: start,
			to: destination,
			stepCost: start.stepCost + cost(from: start.node, to: destination),
			goalCost: estimatedCost(from: destination, to: goal)
		)
	}

	func reconstructPath(from steps: Step<Node, Cost>) -> [Node] {
		let totalSteps = steps.index + 1
		return Array(unsafeUninitializedCapacity: totalSteps) { (buffer, count) in
			var cursor = steps
			var pointer = buffer.baseAddress!.advanced(by: steps.index)
			while let previous = cursor.previous {
				pointer.initialize(to: cursor.node)
				pointer = pointer.advanced(by: -1)
				cursor = previous
			}
			assert(pointer == buffer.baseAddress, "incrorrect step list")
			pointer.initialize(to: cursor.node)
			count = totalSteps
		}
	}
}

class Step<Node: Hashable, Cost: FloatingPoint> {
	let node: Node
	var previous: Step<Node, Cost>?
	let index: Int

	let stepCost: Cost
	let goalCost: Cost

	init(to destination: Node, stepCost: Cost, goalCost: Cost) {
		node = destination
		self.stepCost = stepCost
		self.goalCost = goalCost
		index = 0
	}

	init(from previous: Step<Node, Cost>, to node: Node, stepCost: Cost, goalCost: Cost) {
		(self.node, self.previous) = (node, previous)
		self.stepCost = stepCost
		self.goalCost = goalCost
		index = previous.index + 1
	}

	func cost() -> Cost {
		return stepCost + goalCost
	}
}
