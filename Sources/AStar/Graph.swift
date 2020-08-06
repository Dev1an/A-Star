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
	func estimatedCost(from start: Node, to end: Node) -> Float

	/// The **actual** cost to reach the indicated end node from a given start node
	/// - Parameters:
	///   - start: the starting point of the path who's cost is to be estimated
	///   - end: the end point of the path who's cost is to be estimated
	func cost(from start: Node, to end: Node) -> Float
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
		var possibleSteps = [Step<Node>]()
		var eliminatedNodes: Set = [startNode]

		for connectedNode in nodesAdjacent(to: startNode) {
			let step = createStep(from: startNode, to: connectedNode, goal: goalNode)
			possibleSteps.sortedInsert(newElement: step)
		}

		var path = [Node]()
		while !possibleSteps.isEmpty {
			let step = possibleSteps.removeFirst()
			if step.node == goalNode {
				var cursor = step
				path.insert(step.node, at: 0)
				while let previous = cursor.previous {
					cursor = previous
					path.insert(previous.node, at: 0)
				}
				break
			}
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

		if path.count > 0 || goalNode == startNode {
			path.insert(startNode, at: 0)
		}

		return path
	}

	func createStep(from start: Node, to destination: Node, goal: Node) -> Step<Node> {
		Step(
			to: destination,
			stepCost: cost(from: start, to: destination),
			goalCost: estimatedCost(from: destination, to: goal)
		)
	}

	func createStep(from start: Step<Node>, to destination: Node, goal: Node) -> Step<Node> {
		Step(
			from: start,
			to: destination,
			stepCost: start.stepCost + cost(from: start.node, to: destination),
			goalCost: estimatedCost(from: destination, to: goal)
		)
	}
}

class Step<Node: Hashable> {
	var node: Node
	var previous: Step<Node>?

	var stepCost: Float
	var goalCost: Float

	init(to destination: Node, stepCost: Float, goalCost: Float) {
		node = destination
		self.stepCost = stepCost
		self.goalCost = goalCost
	}

	init(from previous: Step<Node>, to node: Node, stepCost: Float, goalCost: Float) {
		(self.node, self.previous) = (node, previous)
		self.stepCost = stepCost
		self.goalCost = goalCost
	}

	func cost() -> Float {
		return stepCost + goalCost
	}
}
