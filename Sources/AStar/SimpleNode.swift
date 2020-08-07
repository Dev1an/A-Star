//
//  Node.swift
//  AStar
//
//  Created by Damiaan Dufaux on 19/08/16.
//  Copyright © 2016 Damiaan Dufaux. All rights reserved.
//


/// A simplified version of the `Graph`  protocol that allows optimal path finding between nodes without the need of a containing `Graph` type.
///
/// Use this protocol instead of `Graph` if your nodes store their outgoing edges.
///
/// When your nodes do not store edge information, consider using the `Graph` protocol.
public protocol GraphNode: Graph, Hashable {

	/// In a `GraphNode` `Graph` the nodes are of type `GraphNode`.
	associatedtype Node = Self

	// MARK: Optimal pathfinding requirements

	/**
	* List of other graph nodes that this node has an edge leading to.
	*/
	var connectedNodes: Set<Self> { get }


	/// Returns the estimated/heuristic cost to reach the indicated node from this node
	///
	/// - Parameter node: the end point of the edge who's cost is to be estimated
	/// - Returns: the heuristic cost
	func estimatedCost(to node: Self) -> Cost


	/// - Parameter node: the destination node
	/// - Returns: the actual cost to reach the indicated node from this node
	func cost(to node: Self) -> Cost
}

extension GraphNode where Node == Self {

	public func nodesAdjacent(to node: Node) -> Set<Node> {
		node.connectedNodes
	}

	public func estimatedCost(from start: Node, to end: Node) -> Cost {
		start.estimatedCost(to: end)
	}

	public func cost(from start: Node, to end: Node) -> Cost {
		start.cost(to: end)
	}

	// MARK: - A* Implementation

	/// Attempts to find the optimal path between this node and the indicated goal node.
	/// If such a path exists, it is returned in start to end order.
	/// If it doesn't exist, the returned array will be empty.
    ///
    /// - Parameter goalNode: the goal node of the pathfinding attempt
    /// - Returns: the optimal path between this node and the indicated goal node
    public func findPath(to goalNode: Self) -> [Self] {
		findPath(from: self, to: goalNode)
    }
	
	
    /// As with findPathToNode: except this node is the goal node and a startNode is specified
    ///
    /// - Parameter startNode: the start node of the pathfinding attempt
    /// - Returns: the optimal path between the indicated start node and this node
    public func findPath(from startNode: Self) -> [Self] {
        startNode.findPath(to: self)
    }
}
